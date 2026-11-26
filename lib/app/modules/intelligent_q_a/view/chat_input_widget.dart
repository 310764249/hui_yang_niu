import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../services/tencent_asr_service.dart';

class ChatInputWidget extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool enabled;

  const ChatInputWidget({super.key, required this.onSend, this.enabled = true});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final TencentAsrService _asrService = TencentAsrService();
  StreamSubscription<String>? _transcriptSubscription;
  bool _isVoiceMode = false;
  bool _isPressingVoice = false;
  bool _isListening = false;
  bool _isStarting = false;
  String _textBeforeSpeech = '';

  void _sendText() {
    if (!widget.enabled || _isListening || _isStarting) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  void _toggleInputMode() {
    if (!widget.enabled || _isStarting || _isListening) return;
    FocusScope.of(context).unfocus();
    setState(() => _isVoiceMode = !_isVoiceMode);
  }

  Future<void> _onVoicePressStart() async {
    if (!widget.enabled || _isStarting || _isListening) return;
    _isPressingVoice = true;
    HapticFeedback.mediumImpact();
    await _startSpeechRecognition();
    if (!_isPressingVoice && _isListening) {
      await _stopSpeechRecognition();
    }
  }

  Future<void> _onVoicePressEnd() async {
    _isPressingVoice = false;
    if (_isListening) await _stopSpeechRecognition();
  }

  Future<void> _startSpeechRecognition() async {
    FocusScope.of(context).unfocus();
    setState(() => _isStarting = true);
    _textBeforeSpeech = _controller.text.trimRight();
    await _transcriptSubscription?.cancel();
    _transcriptSubscription = _asrService.transcripts.listen(
      _applyTranscript,
      onError: (Object error) async {
        if (!mounted) return;
        Toast.show(_errorMessage(error));
        await _asrService.cancel();
        if (mounted) {
          setState(() {
            _isListening = false;
            _isStarting = false;
          });
        }
      },
    );

    try {
      await _asrService.start();
      if (!mounted) return;
      setState(() {
        _isListening = true;
        _isStarting = false;
      });
    } catch (error) {
      if (!mounted) return;
      Toast.show(_errorMessage(error));
      setState(() {
        _isPressingVoice = false;
        _isListening = false;
        _isStarting = false;
      });
    }
  }

  Future<void> _stopSpeechRecognition() async {
    if (!_isListening) return;
    setState(() => _isStarting = true);
    try {
      final transcript = await _asrService.stop();
      if (transcript.isNotEmpty) _applyTranscript(transcript);
    } catch (error) {
      Toast.show(_errorMessage(error));
    } finally {
      if (mounted) {
        setState(() {
          _isVoiceMode = false;
          _isListening = false;
          _isStarting = false;
        });
      }
    }
  }

  void _applyTranscript(String transcript) {
    if (!mounted || transcript.isEmpty) return;
    final separator = _textBeforeSpeech.isEmpty ? '' : ' ';
    final text = '$_textBeforeSpeech$separator$transcript';
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  String _errorMessage(Object error) {
    if (error is TencentAsrException) return error.message;
    return '语音识别失败，请稍后重试';
  }

  @override
  void dispose() {
    _transcriptSubscription?.cancel();
    _asrService.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              tooltip: _isVoiceMode ? '键盘输入' : '语音输入',
              onPressed: widget.enabled ? _toggleInputMode : null,
              icon: Icon(
                _isVoiceMode ? Icons.keyboard_alt_outlined : Icons.mic_none,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _isVoiceMode ? _buildVoiceInput() : _buildTextInput(),
            ),
            if (!_isVoiceMode) ...[
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: '发送',
                onPressed:
                    widget.enabled && !_isListening && !_isStarting
                        ? _sendText
                        : null,
                icon: const Icon(Icons.send, size: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: _controller,
          enabled: widget.enabled && !_isListening && !_isStarting,
          minLines: 1,
          maxLines: 4,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _sendText(),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.enabled ? '请输入内容...' : '正在生成回答...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceInput() {
    final isBusy = _isStarting && !_isListening;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.enabled ? (_) => _onVoicePressStart() : null,
      onTapUp: widget.enabled ? (_) => _onVoicePressEnd() : null,
      onTapCancel: widget.enabled ? _onVoicePressEnd : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              _isListening ? const Color(0xFFE4EAF3) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color:
                _isListening
                    ? const Color(0xFF9DB7DA)
                    : const Color(0xFFE5E5E5),
          ),
        ),
        child:
            isBusy
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Text(
                  _isListening ? '松开结束' : '按住说话',
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
      ),
    );
  }
}
