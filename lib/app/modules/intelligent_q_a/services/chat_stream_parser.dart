import 'dart:convert';

import '../../../models/chat_v2_models.dart';

class ChatStreamEvent {
  const ChatStreamEvent({
    required this.type,
    this.content,
    this.conversationId,
    this.approval,
    this.error,
    this.done = false,
  });

  final String type;
  final String? content;
  final String? conversationId;
  final ApprovalModel? approval;
  final String? error;
  final bool done;

  bool get isDelta {
    final normalized = type.toLowerCase();
    return normalized.contains('delta') ||
        normalized.contains('chunk') ||
        normalized.contains('token');
  }
}

/// Incrementally parses standard SSE frames and newline-delimited fallbacks.
class ChatStreamParser {
  String _buffer = '';
  String? _eventName;
  final List<String> _dataLines = [];

  List<ChatStreamEvent> add(String chunk) {
    _buffer += chunk.replaceAll('\r\n', '\n');
    final events = <ChatStreamEvent>[];
    var newline = _buffer.indexOf('\n');
    while (newline >= 0) {
      final line = _buffer.substring(0, newline).replaceAll('\r', '');
      _buffer = _buffer.substring(newline + 1);
      _consumeLine(line, events);
      newline = _buffer.indexOf('\n');
    }
    return events;
  }

  List<ChatStreamEvent> finish() {
    final events = <ChatStreamEvent>[];
    if (_buffer.isNotEmpty) {
      _consumeLine(_buffer.replaceAll('\r', ''), events);
      _buffer = '';
    }
    _dispatch(events);
    return events;
  }

  void _consumeLine(String line, List<ChatStreamEvent> events) {
    if (line.isEmpty) {
      _dispatch(events);
      return;
    }
    if (line.startsWith(':')) return;
    if (line.startsWith('event:')) {
      _eventName = line.substring(6).trim();
      return;
    }
    if (line.startsWith('data:')) {
      _dataLines.add(line.substring(5).trimLeft());
      return;
    }
    if (line.startsWith('id:') || line.startsWith('retry:')) return;

    // Some servers emit NDJSON or plain text while still using the SSE MIME type.
    _dataLines.add(line);
    _dispatch(events);
  }

  void _dispatch(List<ChatStreamEvent> events) {
    if (_dataLines.isEmpty) {
      _eventName = null;
      return;
    }
    final payload = _dataLines.join('\n');
    _dataLines.clear();
    final parsed = _parsePayload(payload, _eventName);
    _eventName = null;
    if (parsed != null) events.add(parsed);
  }

  ChatStreamEvent? _parsePayload(String payload, String? eventName) {
    final trimmed = payload.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed == '[DONE]') {
      return const ChatStreamEvent(type: 'done', done: true);
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(trimmed);
    } on FormatException {
      return ChatStreamEvent(type: eventName ?? 'delta', content: payload);
    }

    if (decoded is String) {
      final normalizedEvent = eventName?.toLowerCase() ?? '';
      if (normalizedEvent.contains('conversation')) {
        return ChatStreamEvent(
          type: eventName ?? 'conversation',
          conversationId: decoded,
        );
      }
      if (normalizedEvent.contains('error')) {
        return ChatStreamEvent(type: eventName ?? 'error', error: decoded);
      }
      if (normalizedEvent.contains('done') ||
          normalizedEvent.contains('completed')) {
        return ChatStreamEvent(type: eventName ?? 'done', done: true);
      }
      return ChatStreamEvent(type: eventName ?? 'delta', content: decoded);
    }
    if (decoded is! Map) return null;

    var map = decoded.cast<String, dynamic>();
    final envelopeCode = map['code'];
    if (envelopeCode is num && envelopeCode != 0) {
      return ChatStreamEvent(
        type: eventName ?? 'error',
        error: map['message']?.toString() ?? '请求失败',
      );
    }
    if (map['code'] != null && map['data'] is Map) {
      map = (map['data'] as Map).cast<String, dynamic>();
    }

    final type = eventName ??
        _findString(map, const ['type', 'event', 'kind', 'status']) ??
        'message';
    final normalizedType = type.toLowerCase();
    final conversationId = _findStringDeep(
      map,
      const ['conversationId', 'conversation_id'],
    );

    ApprovalModel? approval;
    final approvalMap =
        _findMapDeep(map, const ['approval', 'approvalRequest']);
    if (approvalMap != null) {
      approval = ApprovalModel.fromJson(approvalMap);
    } else if (normalizedType.contains('approval') ||
        map['approvalId'] != null) {
      approval = ApprovalModel.fromJson(map);
    }

    final isError = normalizedType.contains('error') || map['error'] != null;
    final error = isError
        ? _findStringDeep(map, const ['error', 'message', 'detail', 'title'])
        : null;
    final done = normalizedType.contains('done') ||
        normalizedType.contains('completed') ||
        map['done'] == true;

    String? content;
    if (!isError && approval == null) {
      content = _findStringDeep(
        map,
        const ['delta', 'content', 'text', 'answer', 'outputText'],
      );
      if (content == null && map['data'] is String) {
        content = map['data'] as String;
      }
    }

    return ChatStreamEvent(
      type: type,
      content: content,
      conversationId: conversationId,
      approval: approval,
      error: error,
      done: done,
    );
  }
}

String? _findString(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = map[key];
    if (value is String && value.isNotEmpty) return value;
  }
  return null;
}

String? _findStringDeep(dynamic value, List<String> keys) {
  if (value is Map) {
    final map = value.cast<dynamic, dynamic>();
    for (final key in keys) {
      final item = map[key];
      if (item is String && item.isNotEmpty) return item;
    }
    for (final item in map.values) {
      final found = _findStringDeep(item, keys);
      if (found != null) return found;
    }
  } else if (value is List) {
    for (final item in value) {
      final found = _findStringDeep(item, keys);
      if (found != null) return found;
    }
  }
  return null;
}

Map<String, dynamic>? _findMapDeep(dynamic value, List<String> keys) {
  if (value is Map) {
    final map = value.cast<dynamic, dynamic>();
    for (final key in keys) {
      final item = map[key];
      if (item is Map) return item.cast<String, dynamic>();
    }
    for (final item in map.values) {
      final found = _findMapDeep(item, keys);
      if (found != null) return found;
    }
  } else if (value is List) {
    for (final item in value) {
      final found = _findMapDeep(item, keys);
      if (found != null) return found;
    }
  }
  return null;
}
