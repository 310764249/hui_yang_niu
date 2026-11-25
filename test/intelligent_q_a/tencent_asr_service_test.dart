import 'dart:collection';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellectual_breed/app/modules/intelligent_q_a/services/tencent_asr_service.dart';

void main() {
  test('Tencent ASR signer creates a short-lived signed websocket URL', () {
    final uri = TencentAsrSigner.buildWebSocketUri(
      credentials: const TencentAsrCredentials(
        appId: '123456',
        secretId: 'test-secret-id',
        secretKey: 'test-secret-key',
        token: 'temporary-token',
      ),
      voiceId: 'voice-1',
      now: DateTime.fromMillisecondsSinceEpoch(1700000000000),
      nonce: 42,
    );

    expect(uri.scheme, 'wss');
    expect(uri.host, 'asr.cloud.tencent.com');
    expect(uri.path, '/asr/v2/123456');
    expect(uri.queryParameters['timestamp'], '1700000000');
    expect(uri.queryParameters['expired'], '1700000300');
    expect(uri.queryParameters['voice_format'], '1');
    expect(uri.queryParameters['token'], 'temporary-token');

    final unsigned = SplayTreeMap<String, String>.from(uri.queryParameters)
      ..remove('signature');
    final canonicalQuery = unsigned.entries
        .map((entry) => '${entry.key}=${Uri.encodeQueryComponent(entry.value)}')
        .join('&');
    final canonical = 'asr.cloud.tencent.com/asr/v2/123456?$canonicalQuery';
    final expected = base64Encode(
      Hmac(
        sha1,
        utf8.encode('test-secret-key'),
      ).convert(utf8.encode(canonical)).bytes,
    );
    expect(uri.queryParameters['signature'], expected);
  });

  test('Tencent ASR signer rejects incomplete credentials', () {
    expect(
      () => TencentAsrSigner.buildWebSocketUri(
        credentials: const TencentAsrCredentials(
          appId: '',
          secretId: '',
          secretKey: '',
        ),
        voiceId: 'voice-1',
      ),
      throwsA(isA<TencentAsrException>()),
    );
  });
}
