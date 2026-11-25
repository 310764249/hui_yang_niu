class ChatMessageModel {
  ChatMessageModel({
    this.id,
    required this.content,
    required this.role,
    this.created,
    this.modified,
    this.status,
    this.model,
    this.inputToken = 0,
    this.outputToken = 0,
    this.totalToken = 0,
    this.rounds = 0,
    this.traces = const [],
  });

  final String? id;
  String content;
  final String role;
  final String? created;
  final String? modified;
  final String? status;
  final String? model;
  final int inputToken;
  final int outputToken;
  final int totalToken;
  final int rounds;
  final List<ChatTraceModel> traces;

  bool get isUser => role.toLowerCase() == 'user';

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString(),
      content: json['content']?.toString() ?? '',
      role: json['role']?.toString() ?? 'assistant',
      created: json['created']?.toString(),
      modified: json['modified']?.toString(),
      status: json['status']?.toString(),
      model: json['model']?.toString(),
      inputToken: _asInt(json['inputToken']),
      outputToken: _asInt(json['outputToken']),
      totalToken: _asInt(json['totalToken']),
      rounds: _asInt(json['rounds']),
      traces: _asMapList(json['traces']).map(ChatTraceModel.fromJson).toList(),
    );
  }
}

class ChatTraceModel {
  const ChatTraceModel({
    this.id,
    this.name,
    this.title,
    this.kind,
    this.status,
    this.arguments,
    this.result,
    this.approvalId,
    this.callId,
    this.requiresApproval = false,
  });

  final String? id;
  final String? name;
  final String? title;
  final String? kind;
  final String? status;
  final String? arguments;
  final String? result;
  final String? approvalId;
  final String? callId;
  final bool requiresApproval;

  factory ChatTraceModel.fromJson(Map<String, dynamic> json) {
    return ChatTraceModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      title: json['title']?.toString(),
      kind: json['kind']?.toString(),
      status: json['status']?.toString(),
      arguments: json['arguments']?.toString(),
      result: json['result']?.toString(),
      approvalId: json['approvalId']?.toString(),
      callId: json['callId']?.toString(),
      requiresApproval: json['requiresApproval'] == true,
    );
  }
}

class ConversationSummaryModel {
  const ConversationSummaryModel({
    required this.id,
    required this.title,
    required this.messageCount,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final int messageCount;
  final String? createdAt;
  final String? updatedAt;

  factory ConversationSummaryModel.fromJson(Map<String, dynamic> json) {
    return ConversationSummaryModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '新会话',
      messageCount: _asInt(json['messageCount']),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

class ConversationDetailModel {
  const ConversationDetailModel({
    required this.id,
    required this.title,
    this.created,
    this.modified,
    this.messages = const [],
  });

  final String id;
  final String title;
  final String? created;
  final String? modified;
  final List<ChatMessageModel> messages;

  factory ConversationDetailModel.fromJson(Map<String, dynamic> json) {
    return ConversationDetailModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '新会话',
      created: json['created']?.toString(),
      modified: json['modified']?.toString(),
      messages:
          _asMapList(json['messages']).map(ChatMessageModel.fromJson).toList(),
    );
  }
}

class ApprovalModel {
  const ApprovalModel({
    required this.id,
    this.callId,
    this.conversationId,
    this.chatMessageRecordId,
    this.toolName,
    this.toolTitle,
    this.category,
    this.arguments,
    this.summary,
    this.created,
    this.comment,
    this.expiresAt,
    this.decidedAt,
    this.status,
  });

  final String id;
  final String? callId;
  final String? conversationId;
  final String? chatMessageRecordId;
  final String? toolName;
  final String? toolTitle;
  final String? category;
  final String? arguments;
  final String? summary;
  final String? created;
  final String? comment;
  final String? expiresAt;
  final String? decidedAt;
  final String? status;

  String get displayTitle =>
      _firstNonEmpty([toolTitle, toolName, summary]) ?? '需要确认的操作';

  factory ApprovalModel.fromJson(Map<String, dynamic> json) {
    return ApprovalModel(
      id: (json['id'] ?? json['approvalId'])?.toString() ?? '',
      callId: json['callId']?.toString(),
      conversationId: json['conversationId']?.toString(),
      chatMessageRecordId: json['chatMessageRecordId']?.toString(),
      toolName: json['toolName']?.toString(),
      toolTitle: json['toolTitle']?.toString(),
      category: json['category']?.toString(),
      arguments: json['arguments']?.toString(),
      summary: json['summary']?.toString(),
      created: json['created']?.toString(),
      comment: json['comment']?.toString(),
      expiresAt: json['expiresAt']?.toString(),
      decidedAt: json['decidedAt']?.toString(),
      status: json['status']?.toString(),
    );
  }
}

List<Map<String, dynamic>> _asMapList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => item.cast<String, dynamic>())
      .toList();
}

int _asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String? _firstNonEmpty(Iterable<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) return value.trim();
  }
  return null;
}
