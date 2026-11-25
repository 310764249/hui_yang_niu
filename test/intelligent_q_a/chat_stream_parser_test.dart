import 'package:flutter_test/flutter_test.dart';
import 'package:intellectual_breed/app/models/chat_v2_models.dart';
import 'package:intellectual_breed/app/modules/intelligent_q_a/services/chat_stream_parser.dart';

void main() {
  group('ChatStreamParser', () {
    test('parses fragmented SSE metadata, deltas, and completion', () {
      final parser = ChatStreamParser();

      expect(parser.add('event: conversation\ndata: {"conversation'), isEmpty);
      final metadata = parser.add('Id":"conversation-1"}\n\n');
      final firstDelta = parser.add(
        'event: response.output_text.delta\ndata: {"delta":"你好"}\n\n',
      );
      final secondDelta =
          parser.add('data: {"type":"delta","text":"，养殖户"}\n\n');
      final done = parser.add('data: [DONE]\n\n');

      expect(metadata.single.conversationId, 'conversation-1');
      expect(firstDelta.single.content, '你好');
      expect(firstDelta.single.isDelta, isTrue);
      expect(secondDelta.single.content, '，养殖户');
      expect(done.single.done, isTrue);
      expect(parser.finish(), isEmpty);
    });

    test('parses an approval event inside the platform envelope', () {
      final parser = ChatStreamParser();
      final events = parser.add(
        'data: {"code":0,"data":{"type":"approval_required",'
        '"approval":{"id":"approval-1","toolTitle":"新增档案",'
        '"summary":"将新增一条牛只档案"}}}\n\n',
      );

      expect(events.single.approval?.id, 'approval-1');
      expect(events.single.approval?.displayTitle, '新增档案');
    });

    test('accepts newline-delimited JSON and plain text fallbacks', () {
      final parser = ChatStreamParser();
      final jsonEvent = parser.add('{"type":"token","content":"A"}\n');
      final textEvent = parser.add('B\n');

      expect(jsonEvent.single.content, 'A');
      expect(jsonEvent.single.isDelta, isTrue);
      expect(textEvent.single.content, 'B');
    });

    test('uses a string conversation event as the conversation id', () {
      final parser = ChatStreamParser();
      final events = parser.add(
        'event: conversation.created\ndata: "conversation-2"\n\n',
      );

      expect(events.single.conversationId, 'conversation-2');
      expect(events.single.content, isNull);
    });

    test('treats a failed platform envelope as an error event', () {
      final parser = ChatStreamParser();
      final events = parser.add(
        'data: {"code":-1,"message":"无权执行该操作"}\n\n',
      );

      expect(events.single.error, '无权执行该操作');
      expect(events.single.content, isNull);
    });
  });

  test('chat 2.0 models accept OpenAPI response fields', () {
    final detail = ConversationDetailModel.fromJson({
      'id': 'conversation-1',
      'title': '本月支出',
      'created': '2026-11-24T12:00:00Z',
      'modified': '2026-11-24T12:01:00Z',
      'messages': [
        {
          'id': 'message-1',
          'role': 'assistant',
          'content': '合计 100 元',
          'totalToken': 12,
          'traces': [
            {'name': 'expense_report', 'requiresApproval': false},
          ],
        },
      ],
    });

    expect(detail.id, 'conversation-1');
    expect(detail.messages.single.content, '合计 100 元');
    expect(detail.messages.single.totalToken, 12);
    expect(detail.messages.single.traces.single.name, 'expense_report');
  });
}
