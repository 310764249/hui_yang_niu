import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:record/record.dart';

import '../../../network/httpsClient.dart';

class TencentAsrException implements Exception {
  const TencentAsrException(this.message);

  final String message;

  @override
  String toString() => message;
}

class TencentAsrCredentials {
  const TencentAsrCredentials({
    required this.appId,
    required this.secretId,
    required this.secretKey,
    this.token,
  });

  final String appId;
  final String secretId;
  final String secretKey;
  final String? token;

  factory TencentAsrCredentials.fromMap(Map<String, dynamic> json) {
    return TencentAsrCredentials(
      appId: (json['appId'] ?? json['appid'] ?? '').toString(),
      secretId: (json['secretId'] ?? json['secretid'] ?? '').toString(),
      secretKey: (json['secretKey'] ?? json['secretkey'] ?? '').toString(),
      token: (json['token'] ?? json['sessionToken'])?.toString(),
    );
  }

  bool get isComplete =>
      appId.isNotEmpty && secretId.isNotEmpty && secretKey.isNotEmpty;
}

class TencentAsrSigner {
  static Uri buildWebSocketUri({
    required TencentAsrCredentials credentials,
    required String voiceId,
    DateTime? now,
    int? nonce,
    String engineModelType = '16k_zh',
  }) {
    if (!credentials.isComplete) {
      throw const TencentAsrException('语音识别凭证不完整');
    }

    final timestamp = (now ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000;
    final parameters = SplayTreeMap<String, String>.from({
      'engine_model_type': engineModelType,
      'expired': '${timestamp + 300}',
      'filter_punc': '0',
      'needvad': '1',
      'nonce': '${nonce ?? Random.secure().nextInt(1 << 31)}',
      'secretid': credentials.secretId,
      'timestamp': '$timestamp',
      'voice_format': '1',
      'voice_id': voiceId,
    });
    final token = credentials.token;
    if (token != null && token.isNotEmpty) {
      parameters['token'] = token;
    }

    final canonicalQuery = parameters.entries
        .map((entry) => '${entry.key}=${Uri.encodeQueryComponent(entry.value)}')
        .join('&');
    final canonicalRequest =
        'asr.cloud.tencent.com/asr/v2/${credentials.appId}?$canonicalQuery';
    final digest = Hmac(
      sha1,
      utf8.encode(credentials.secretKey),
    ).convert(utf8.encode(canonicalRequest));
    parameters['signature'] = base64Encode(digest.bytes);

    return Uri(
      scheme: 'wss',
      host: 'asr.cloud.tencent.com',
      path: '/asr/v2/${credentials.appId}',
      queryParameters: parameters,
    );
  }
}

class TencentAsrAuthorizationProvider {
  TencentAsrAuthorizationProvider({HttpsClient? httpsClient})
    : _httpsClient = httpsClient ?? HttpsClient();

  static const String _authorizationPath = String.fromEnvironment(
    'TENCENT_ASR_AUTH_PATH',
    defaultValue: '/api/chat/speech/authorization',
  );
  static const String _appId = String.fromEnvironment('TENCENT_ASR_APP_ID');
  static const String _secretId = String.fromEnvironment(
    'TENCENT_ASR_SECRET_ID',
  );
  static const String _secretKey = String.fromEnvironment(
    'TENCENT_ASR_SECRET_KEY',
  );
  static const String _token = String.fromEnvironment('TENCENT_ASR_TOKEN');

  final HttpsClient _httpsClient;

  Future<Uri> createWebSocketUri(String voiceId) async {
    if (_authorizationPath.isNotEmpty) {
      try {
        final response = await _httpsClient.get(
          _authorizationPath,
          queryParameters: {'voiceId': voiceId},
        );
        final uri = _parseAuthorization(response, voiceId);
        if (uri != null) return uri;
      } catch (_) {
        // Development builds may use dart-define credentials as a fallback.
      }
    }

    const credentials = TencentAsrCredentials(
      appId: _appId,
      secretId: _secretId,
      secretKey: _secretKey,
      token: _token,
    );
    if (credentials.isComplete) {
      return TencentAsrSigner.buildWebSocketUri(
        credentials: credentials,
        voiceId: voiceId,
      );
    }

    throw const TencentAsrException('语音识别服务尚未配置');
  }

  Uri? _parseAuthorization(Object? response, String voiceId) {
    if (response is String && response.startsWith('wss://')) {
      return Uri.tryParse(response);
    }
    if (response is! Map) return null;

    final json = response.cast<String, dynamic>();
    final url = (json['websocketUrl'] ?? json['url'])?.toString();
    if (url != null && url.startsWith('wss://')) {
      return Uri.tryParse(url);
    }

    final credentials = TencentAsrCredentials.fromMap(json);
    if (!credentials.isComplete) return null;
    return TencentAsrSigner.buildWebSocketUri(
      credentials: credentials,
      voiceId: voiceId,
    );
  }
}

class TencentAsrService {
  TencentAsrService({TencentAsrAuthorizationProvider? authorizationProvider})
    : _authorizationProvider =
          authorizationProvider ?? TencentAsrAuthorizationProvider();

  static const int _packetBytes = 6400;

  final TencentAsrAuthorizationProvider _authorizationProvider;
  final AudioRecorder _recorder = AudioRecorder();
  final StreamController<String> _transcriptController =
      StreamController<String>.broadcast();
  final Map<int, String> _sentences = {};
  final List<int> _pendingAudio = [];

  WebSocket? _socket;
  StreamSubscription<dynamic>? _socketSubscription;
  StreamSubscription<Uint8List>? _audioSubscription;
  Completer<void>? _handshakeCompleter;
  Completer<void>? _finishedCompleter;
  bool _isRunning = false;
  bool _isEnding = false;
  bool _isDisposed = false;

  Stream<String> get transcripts => _transcriptController.stream;
  bool get isRunning => _isRunning;
  String get transcript => _joinedTranscript;

  Future<void> start() async {
    if (_isDisposed) {
      throw const TencentAsrException('语音识别服务已关闭');
    }
    if (_isRunning) return;
    if (!await _recorder.hasPermission()) {
      throw const TencentAsrException('请允许使用麦克风后再试');
    }

    _sentences.clear();
    _pendingAudio.clear();
    _isEnding = false;
    _handshakeCompleter = Completer<void>();
    _finishedCompleter = Completer<void>();
    unawaited(_finishedCompleter!.future.catchError((_) {}));
    final voiceId = _createVoiceId();

    try {
      final uri = await _authorizationProvider.createWebSocketUri(voiceId);
      final socket = await WebSocket.connect(
        uri.toString(),
      ).timeout(const Duration(seconds: 12));
      socket.pingInterval = const Duration(seconds: 10);
      _socket = socket;
      _socketSubscription = socket.listen(
        _handleSocketMessage,
        onError: _handleSocketError,
        onDone: _handleSocketDone,
        cancelOnError: false,
      );
      await _handshakeCompleter!.future.timeout(const Duration(seconds: 12));

      final audioStream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
          autoGain: true,
          echoCancel: true,
          noiseSuppress: true,
          streamBufferSize: _packetBytes,
        ),
      );
      _audioSubscription = audioStream.listen(
        _handleAudio,
        onError: _handleAudioError,
      );
      _isRunning = true;
    } catch (error) {
      await _cleanup(closeSocket: true);
      if (error is TencentAsrException) rethrow;
      throw const TencentAsrException('语音识别连接失败，请稍后重试');
    }
  }

  Future<String> stop() async {
    if (!_isRunning) return _joinedTranscript;

    try {
      await _recorder.stop();
      await _audioSubscription?.cancel();
      _audioSubscription = null;
      _flushAudio();
      _isEnding = true;
      _socket?.add(jsonEncode({'type': 'end'}));
      await _finishedCompleter!.future.timeout(const Duration(seconds: 15));
      return _joinedTranscript;
    } on TencentAsrException {
      rethrow;
    } catch (_) {
      throw const TencentAsrException('获取语音识别结果失败');
    } finally {
      await _cleanup(closeSocket: true);
    }
  }

  Future<void> cancel() async {
    _isEnding = true;
    try {
      if (_isRunning) await _recorder.cancel();
    } catch (_) {
      // Ignore platform cleanup failures while cancelling.
    }
    await _cleanup(closeSocket: true);
  }

  void _handleAudio(Uint8List bytes) {
    if (_isEnding || bytes.isEmpty) return;
    _pendingAudio.addAll(bytes);
    while (_pendingAudio.length >= _packetBytes) {
      final packet = Uint8List.fromList(_pendingAudio.sublist(0, _packetBytes));
      _pendingAudio.removeRange(0, _packetBytes);
      _socket?.add(packet);
    }
  }

  void _flushAudio() {
    if (_pendingAudio.isEmpty) return;
    _socket?.add(Uint8List.fromList(_pendingAudio));
    _pendingAudio.clear();
  }

  void _handleAudioError(Object error, StackTrace stackTrace) {
    _fail(const TencentAsrException('录音中断，请重试'));
  }

  void _handleSocketMessage(dynamic raw) {
    if (raw is! String) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return;
      final json = decoded.cast<String, dynamic>();
      final code = (json['code'] as num?)?.toInt() ?? -1;
      if (code != 0) {
        final message = json['message']?.toString();
        _fail(
          TencentAsrException(
            message == null || message.isEmpty ? '语音识别失败（$code）' : message,
          ),
        );
        return;
      }

      if (!(_handshakeCompleter?.isCompleted ?? true)) {
        _handshakeCompleter!.complete();
      }

      final result = json['result'];
      if (result is Map) {
        final resultJson = result.cast<String, dynamic>();
        final index = (resultJson['index'] as num?)?.toInt() ?? 0;
        final text = resultJson['voice_text_str']?.toString() ?? '';
        _sentences[index] = text;
        _transcriptController.add(_joinedTranscript);
      }

      if (json['final'] == 1 && !(_finishedCompleter?.isCompleted ?? true)) {
        _finishedCompleter!.complete();
      }
    } catch (_) {
      _fail(const TencentAsrException('语音识别返回数据无法解析'));
    }
  }

  void _handleSocketError(Object error, StackTrace stackTrace) {
    _fail(const TencentAsrException('语音识别网络已断开'));
  }

  void _handleSocketDone() {
    if (_isEnding && (_finishedCompleter?.isCompleted ?? false)) return;
    _fail(const TencentAsrException('语音识别连接已断开'));
  }

  void _fail(TencentAsrException error) {
    if (!(_handshakeCompleter?.isCompleted ?? true)) {
      _handshakeCompleter!.completeError(error);
    }
    if (!(_finishedCompleter?.isCompleted ?? true)) {
      _finishedCompleter!.completeError(error);
    }
    if (!_transcriptController.isClosed) {
      _transcriptController.addError(error);
    }
  }

  String get _joinedTranscript {
    final indexes = _sentences.keys.toList()..sort();
    return indexes.map((index) => _sentences[index]).join().trim();
  }

  String _createVoiceId() {
    final random = Random.secure();
    return '${DateTime.now().microsecondsSinceEpoch}-'
        '${random.nextInt(1 << 32).toRadixString(16)}';
  }

  Future<void> _cleanup({required bool closeSocket}) async {
    _isRunning = false;
    _isEnding = true;
    _pendingAudio.clear();
    await _audioSubscription?.cancel();
    _audioSubscription = null;
    await _socketSubscription?.cancel();
    _socketSubscription = null;
    if (closeSocket) {
      try {
        await _socket?.close();
      } catch (_) {
        // The server may already have closed the connection.
      }
    }
    _socket = null;
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await cancel();
    await _recorder.dispose();
    await _transcriptController.close();
  }
}
