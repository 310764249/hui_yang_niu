import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:intellectual_breed/app/widgets/custom_checkbox.dart';

class UserAgreement extends StatefulWidget {
  final bool initialValue; //初始状态
  final ValueChanged<bool>? onChanged; //checkbox事件
  final VoidCallback? agreeAction; //agreeAction
  final VoidCallback? privacyAction; //privacyAction

  const UserAgreement({
    super.key,
    required this.initialValue,
    this.onChanged,
    this.agreeAction,
    this.privacyAction,
  });

  @override
  State<UserAgreement> createState() => _UserAgreementState();
}

class _UserAgreementState extends State<UserAgreement> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        CustomCheckbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value;
              widget.onChanged!(isChecked);
            });
          },
        ),
        Text("我已阅读和同意", style: TextStyle(fontSize: ScreenAdapter.fontSize(14))),
        InkWell(
          onTap: widget.agreeAction,
          child: Text(
            "《用户协议》",
            style: TextStyle(
                color: Color(0xFF2A5DF3), fontSize: ScreenAdapter.fontSize(14)),
          ),
        ),
        const Text("和"),
        InkWell(
          onTap: widget.privacyAction,
          child: Text(
            "《隐私条款》",
            style: TextStyle(
                color: Color(0xFF2A5DF3), fontSize: ScreenAdapter.fontSize(14)),
          ),
        ),
      ],
    );
  }
}
