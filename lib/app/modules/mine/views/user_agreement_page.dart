import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../models/user_agreement_entity.dart';

class UserAgreementPage extends StatelessWidget {
  final UserAgreementEntity data;

  const UserAgreementPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(data.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 标题
            Text(
              data.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 16),

            /// 富文本内容
            Html(
              data: data.content,
              style: {
                "body": Style(
                  fontSize: FontSize(16),
                  lineHeight: const LineHeight(1.6),
                  padding: HtmlPaddings.zero,
                ),
              },
            ),

            const SizedBox(height: 30),

            /// 发布者
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "发布者：${data.publisher}",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
