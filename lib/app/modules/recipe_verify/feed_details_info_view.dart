import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intellectual_breed/app/models/raw_material.dart';
import 'package:intellectual_breed/app/services/decimal_text_input_formatter.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import '../../services/colors.dart';

class FeedDetailsInfoView extends StatefulWidget {
  const FeedDetailsInfoView({
    super.key,
    required this.list,
    required this.onDelete,
    required this.title,
    required this.totalWeightController,
  });

  final List<RawMaterial> list;
  final TextEditingController totalWeightController;

  final ValueChanged<RawMaterial> onDelete;
  final String title;

  @override
  State<FeedDetailsInfoView> createState() => _FeedDetailsInfoViewState();
}

class _FeedDetailsInfoViewState extends State<FeedDetailsInfoView> {
  late TextEditingController totalWeightController = widget.totalWeightController;
  FocusNode totalWeightFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    totalWeightController.text = getTotalWeight().toStringAsFixed(2);

    totalWeightController.addListener(() {
      final value = totalWeightController.text.trim();
      if (value.isEmpty) return;
      if (value == ".") return;

      final input = double.tryParse(value);
      if (input == null) return;
      // setState(() {});
    });
    totalWeightFocusNode.addListener(() {
      if (!totalWeightFocusNode.hasFocus) {
        validateWeight(); // ✅ 失焦校验
      }
    });
  }

  num getTotalWeight() {
    num totalWeight = 0.0;
    for (var item in widget.list) {
      totalWeight += item.verifyWeight;
    }
    return totalWeight;
  }

  /// ✅ 输入完成或失焦时调用校验方法
  void validateWeight() {
    final input = double.tryParse(totalWeightController.text.trim()) ?? 0;
    final total = getTotalWeight();

    if (input < total) {
      totalWeightController.text = total.toStringAsFixed(2);
    }
    setState(() {}); // 刷新 UI 占比
  }

  /// ✅ 加减按钮修改
  void updateWeight(double delta) {
    final input = double.tryParse(totalWeightController.text.trim()) ?? 0;
    final newValue = input + delta;
    final total = getTotalWeight();

    if (newValue < total) {
      totalWeightController.text = total.toStringAsFixed(2);
    } else {
      totalWeightController.text = newValue.toStringAsFixed(2);
    }
    setState(() {});
  }

  @override
  void dispose() {
    totalWeightController.dispose();
    totalWeightFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 12, color: Colors.black),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8).copyWith(bottom: 0),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => updateWeight(-0.1),
                            icon: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: SaienteColors.blue2559F3.withAlpha(20),
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '-',
                                style: TextStyle(fontSize: 16, color: SaienteColors.appMain),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Center(
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) validateWeight(); // ✅ 失焦校验
                                },
                                child: TextField(
                                  controller: totalWeightController,
                                  focusNode: totalWeightFocusNode,
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                  onEditingComplete: validateWeight,
                                  decoration: const InputDecoration(border: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => updateWeight(0.1),
                            icon: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: SaienteColors.blue2559F3.withAlpha(20),
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                '+',
                                style: TextStyle(fontSize: 16, color: SaienteColors.appMain),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: SaienteColors.dark_app_main.withValues(alpha: 0.3)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Center(child: Text('饲料名称'))),
                    Expanded(child: Center(child: Text('重量(kg)'))),
                    Expanded(child: Center(child: Text('占比(%)'))),
                    SizedBox(width: 40),
                  ],
                ),
              ),
            ),
            ...widget.list.map(
              (item) => FeedItemView(
                key: ValueKey('${item.id}${totalWeightController.text}'),
                item: item,
                totalWeight: num.tryParse(totalWeightController.text) ?? getTotalWeight(),
                onDelete: widget.onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedItemView extends StatefulWidget {
  const FeedItemView({
    super.key,
    required this.item,
    required this.totalWeight,
    required this.onDelete,
  });

  final RawMaterial item;
  final num totalWeight;
  final ValueChanged<RawMaterial> onDelete;

  @override
  State<FeedItemView> createState() => _FeedItemViewState();
}

class _FeedItemViewState extends State<FeedItemView> {
  TextEditingController weightController = TextEditingController();
  TextEditingController percentController = TextEditingController();

  /// 防止循环触发监听
  bool isChanging = false;

  @override
  void initState() {
    super.initState();
    weightController.text = widget.item.verifyWeight.toStringAsFixed(2);
    percentController.text = (widget.item.verifyWeight / widget.totalWeight * 100).toStringAsFixed(
      2,
    );

    weightController.addListener(_onWeightChanged);
    percentController.addListener(_onPercentChanged);
  }

  /// ✅ 修改重量 → 更新占比
  void _onWeightChanged() {
    if (isChanging) return;
    isChanging = true;

    final wStr = weightController.text.trim();
    if (wStr.isEmpty || wStr == "." || widget.totalWeight <= 0) {
      isChanging = false;
      return;
    }

    final weight = double.tryParse(wStr) ?? 0;
    widget.item.verifyWeight = weight;

    final percent = weight / widget.totalWeight * 100;
    percentController.text = percent.toStringAsFixed(2);

    setState(() {});
    isChanging = false;
  }

  /// ✅ 修改占比 → 更新重量
  void _onPercentChanged() {
    if (isChanging) return;
    isChanging = true;

    final pStr = percentController.text.trim();
    if (pStr.isEmpty || pStr == "." || widget.totalWeight <= 0) {
      isChanging = false;
      return;
    }

    final percent = double.tryParse(pStr) ?? 0;
    double weight = widget.totalWeight * percent / 100.0;

    widget.item.verifyWeight = weight;
    weightController.text = weight.toStringAsFixed(2);

    setState(() {});
    isChanging = false;
  }

  @override
  void dispose() {
    weightController.dispose();
    percentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: SaienteColors.dark_app_main.withValues(alpha: 0.3), width: 0.4),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(widget.item.name ?? '')),
          _divider(),
          Expanded(
            child: TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          _divider(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: percentController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                const Text('%'),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                onPressed: () {
                  widget.onDelete(widget.item);
                },
                icon: const Icon(Icons.delete_forever_sharp, color: SaienteColors.appMain),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => SizedBox(
    height: 50,
    width: 0.5,
    child: ColoredBox(color: SaienteColors.dark_app_main.withValues(alpha: 0.3)),
  );
}
