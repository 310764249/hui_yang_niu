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
    // final input = double.tryParse(totalWeightController.text.trim()) ?? 0;
    // final total = getTotalWeight();
    //
    // if (input < total) {
    //   totalWeightController.text = total.toStringAsFixed(2);
    // }
    // setState(() {}); // 刷新 UI 占比
  }

  /// 子项修改完成回调
  void onValueChanged(RawMaterial item, double weight, double percent) {
    // 更新当前 item 的数值
    item.verifyWeight = weight;

    // 重算所有项的 totalWeight
    final total = getTotalWeight();

    // 当前用户输入的总重量
    final inputTotal = double.tryParse(totalWeightController.text.trim()) ?? 0;

    // ✅ 如果单项变大导致 sum > totalWeight → 自动扩大总重量
    if (total > inputTotal) {
      totalWeightController.text = total.toStringAsFixed(2);
    }

    // 通知界面刷新比例显示
    setState(() {});
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
                allItems: widget.list,
                totalWeight: num.tryParse(totalWeightController.text) ?? getTotalWeight(),
                onDelete: widget.onDelete,
                onValueChanged: onValueChanged,
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
    required this.allItems, // ✅ 新增
    this.onValueChanged,
  });

  final RawMaterial item;
  final num totalWeight;
  final List<RawMaterial> allItems; // ✅ 新增
  final ValueChanged<RawMaterial> onDelete;
  final void Function(RawMaterial item, double weight, double percent)? onValueChanged;

  @override
  State<FeedItemView> createState() => _FeedItemViewState();
}

class _FeedItemViewState extends State<FeedItemView> {
  TextEditingController weightController = TextEditingController();
  TextEditingController percentController = TextEditingController();

  bool isChanging = false;

  double lastValidWeight = 0;
  double lastValidPercent = 0;

  @override
  void initState() {
    super.initState();
    weightController.text = widget.item.verifyWeight.toStringAsFixed(2);
    percentController.text = (widget.item.verifyWeight / widget.totalWeight * 100).toStringAsFixed(
      2,
    );

    lastValidWeight = widget.item.verifyWeight;
    lastValidPercent = (widget.item.verifyWeight / widget.totalWeight * 100);

    weightController.addListener(_onWeightChanged);
    percentController.addListener(_onPercentChanged);
  }

  /// ✅ 求其他项重量之和
  double _sumOtherWeights() {
    double sum = 0;
    for (var i in widget.allItems) {
      if (i != widget.item) {
        sum += i.verifyWeight;
      }
    }
    return sum;
  }

  /// ✅ 校验累加不超过总量
  bool _validateTotalWeight(double newWeight) {
    final total = _sumOtherWeights() + newWeight;
    return total <= widget.totalWeight;
  }

  void _onWeightChanged() {
    if (isChanging) return;
    isChanging = true;

    final wStr = weightController.text.trim();
    if (wStr.isEmpty || wStr == '.' || widget.totalWeight <= 0) {
      isChanging = false;
      return;
    }

    final weight = double.tryParse(wStr) ?? 0;

    /// 单项重量不可超过总重量
    if (weight > widget.totalWeight) {
      _showError("重量不能超过总量");
      _restoreLast();
      return;
    }

    /// 所有项累加不可超过总重量
    if (!_validateTotalWeight(weight)) {
      _showError("所有重量总和不能超过总量");
      _restoreLast();
      return;
    }

    final percent = weight / widget.totalWeight * 100;

    widget.item.verifyWeight = weight;
    percentController.text = percent.toStringAsFixed(2);

    lastValidWeight = weight;
    lastValidPercent = percent;

    setState(() {});
    isChanging = false;
  }

  void _onPercentChanged() {
    if (isChanging) return;
    isChanging = true;

    final pStr = percentController.text.trim();
    if (pStr.isEmpty || pStr == '.' || widget.totalWeight <= 0) {
      isChanging = false;
      return;
    }

    final percent = double.tryParse(pStr) ?? 0;

    /// 单项占比不可超过100%
    if (percent > 100) {
      _showError("占比不能大于100%");
      _restoreLast();
      return;
    }

    final weight = widget.totalWeight * percent / 100;

    /// 所有项累加不可超过总重量
    if (!_validateTotalWeight(weight)) {
      _showError("所有重量总和不能超过总量");
      _restoreLast();
      return;
    }

    widget.item.verifyWeight = weight;
    weightController.text = weight.toStringAsFixed(2);

    lastValidWeight = weight;
    lastValidPercent = percent;

    setState(() {});
    isChanging = false;
  }

  /// ✅ 恢复到上次合法值
  void _restoreLast() {
    weightController.text = lastValidWeight.toStringAsFixed(2);
    percentController.text = lastValidPercent.toStringAsFixed(2);
    isChanging = false;
  }

  /// ✅ 失焦回调触发真实提交
  void _triggerCallback() {
    final weight = double.tryParse(weightController.text) ?? 0;
    final percent = double.tryParse(percentController.text) ?? 0;
    widget.onValueChanged?.call(widget.item, weight, percent);
  }

  @override
  void dispose() {
    weightController.dispose();
    percentController.dispose();
    super.dispose();
  }

  /// ✅ 错误提示
  void _showError(String text) {
    Toast.show(text);
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(SnackBar(content: Text(text), duration: const Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: SaienteColors.dark_app_main.withValues(alpha: 0.3), width: .4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text((widget.item.name ?? ''), maxLines: 1),
            ),
          ),
          _divider(),

          /// ✅ 重量输入框
          Expanded(
            child: TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(border: InputBorder.none),
              onEditingComplete: _triggerCallback,
              onTapOutside: (_) => _triggerCallback(),
            ),
          ),
          _divider(),

          /// ✅ 占比输入框
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
                    onEditingComplete: _triggerCallback,
                    onTapOutside: (_) => _triggerCallback(),
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
              child: InkWell(
                onTap: () => widget.onDelete(widget.item),
                child: const Icon(Icons.delete_forever_sharp, color: SaienteColors.appMain),
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
