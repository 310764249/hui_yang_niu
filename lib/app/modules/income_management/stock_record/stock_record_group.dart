import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/material_item_model.dart';
import 'package:intellectual_breed/app/modules/material_management/add_inventory.dart';
import 'package:intellectual_breed/app/modules/material_management/material_service.dart';
import 'package:intellectual_breed/app/modules/income_management/stock_record/stock_record_day_view.dart';
import 'package:intellectual_breed/app/modules/income_management/stock_record/stock_record_month.dart';
import 'package:intellectual_breed/app/widgets/radio_button_group.dart';

import '../../../services/colors.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/single_select_wrap.dart';

class StockRecordGroup extends StatefulWidget {
  const StockRecordGroup({super.key});

  @override
  State<StockRecordGroup> createState() => _StockRecordGroupState();
}

class _StockRecordGroupState extends State<StockRecordGroup> with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  List<MaterialItemModel> stockList = [];
  List? unitList;

  //人工按日统计
  // /api/manualwork/daystatistics
  //人工按月统计
  // /api/manualwork/monthstatistics

  // 0日 1月
  final ValueNotifier<int> _tabIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    getUnitList();
    getStockList();
  }

  void getUnitList() async {
    final list = await MaterialService.getDic('wzdw');
    if (!mounted) {
      return;
    }
    setState(() {
      unitList = list;
    });
  }

  void getStockList() async {
    var list = await MaterialService.getMaterialListWithType(null);
    if (!mounted) {
      return;
    }
    setState(() {
      stockList = (list ?? []).where((item) => (item.count ?? item.currentCount ?? 0) > 0).toList();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _stockSummary(),
        const SizedBox(height: 12),
        ValueListenableBuilder(
          valueListenable: _tabIndex,
          builder: (context, value, child) {
            bool isMaterial = value == 0;
            return SingleSelectWrap(
              items: const ['按日统计', "按月统计"],
              initialIndex: value,
              onChanged: (value) {
                _tabIndex.value = value;
                _pageController.jumpToPage(value);
              },
            );
          },
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [StockRecordDayView(), StockRecordMonth()],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _stockSummary() {
    if (stockList.isEmpty) {
      return const SizedBox();
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('当前库存', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 58,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stockList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = stockList[index];
                final count = item.count ?? item.currentCount ?? 0;
                final unitText = _unitText(item.unit);
                return GestureDetector(
                  onTap: () {
                    AddInventoryView.push(
                      context,
                      addInventoryEnum: AddInventoryEnum.viewer,
                      materialId: item.id ?? item.materialId,
                      materialName: item.name ?? item.materialName,
                      unitName: unitText,
                      countText: count.toString(),
                    );
                  },
                  child: Container(
                    width: 110,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: SaienteColors.backGrey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _displayName(item.name ?? item.materialName ?? '', unitText),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const Spacer(),
                        Text(
                          count.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: SaienteColors.appMain,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _displayName(String name, String unitText) {
    if (name.isEmpty || unitText.isEmpty) {
      return name;
    }
    return '$name($unitText)';
  }

  String _unitText(num? unit) {
    final target = unit?.toString();
    if (target == null || target.isEmpty) {
      return '';
    }
    final match = unitList?.firstWhere(
      (e) => e['value'].toString() == target,
      orElse: () => <String, dynamic>{},
    );
    return (match?['key'] ?? '').toString();
  }
}
