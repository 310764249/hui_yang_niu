import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/colors.dart';

import '../../models/manual_work_month_entity.dart';

class MonthProfitListView extends StatelessWidget {
  final ManualWorkMonthEntity data;
  final void Function(MonthCategoryDetailEntity item)? onTap;

  const MonthProfitListView({super.key, required this.data, this.onTap});

  Color _color(double v) => v > 0 ? SaienteColors.appMain : (v < 0 ? Colors.red : Colors.black87);
  String _money(double value, {bool signed = false}) {
    if (value == 0) {
      return signed ? '+0' : '0';
    }
    final abs = value.abs().toStringAsFixed(0);
    if (!signed) {
      return value < 0 ? '-$abs' : abs;
    }
    return value > 0 ? '+$abs' : '-$abs';
  }

  void _openDetail(String categoryName, List<String> ids, {bool isIncome = false}) {
    if (ids.isEmpty) {
      return;
    }
    String id = ids.first;
    if (categoryName.contains('人工') || categoryName.contains('工资')) {
      Get.toNamed(Routes.MANUAL_ASSESS_DETAIL, arguments: id);
    } else if (categoryName.contains('销售')) {
      Get.toNamed(Routes.SALES_ASSESS_DETAIL, arguments: id);
    } else if (categoryName.contains('采购')) {
      Get.toNamed(Routes.PURCHASE_ASSESS_DETAIL, arguments: id);
    } else if (isIncome) {
      Get.toNamed(Routes.SALES_ASSESS_DETAIL, arguments: id);
    } else {
      Get.toNamed(Routes.PURCHASE_ASSESS_DETAIL, arguments: id);
    }
  }

  void _openItemDetail(String categoryName, MonthCategoryDetailEntity item) {
    if (item.incomeIdList.isNotEmpty) {
      _openDetail(categoryName, item.incomeIdList, isIncome: true);
      return;
    }
    if (item.payIdList.isNotEmpty) {
      _openDetail(categoryName, item.payIdList);
    }
  }

  void _openCategoryDetail(MonthCategoryEntity category) {
    if (category.incomeIdList.isNotEmpty) {
      _openDetail(category.categoryName, category.incomeIdList, isIncome: true);
      return;
    }
    if (category.payIdList.isNotEmpty) {
      _openDetail(category.categoryName, category.payIdList);
    }
  }

  List<String> _allIncomeIds() {
    return data.categoryList.expand((e) => e.incomeIdList).toList();
  }

  List<String> _allPayIds() {
    return data.categoryList.expand((e) => e.payIdList).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 月份 Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Row(
            children: [
              Text(
                "${data.date}月",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _openDetail('销售', _allIncomeIds(), isIncome: true),
                behavior: HitTestBehavior.translucent,
                child: Text(
                  "${_money(data.income, signed: true)}元",
                  style: const TextStyle(fontSize: 14, color: SaienteColors.appMain),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _openDetail('采购', _allPayIds()),
                behavior: HitTestBehavior.translucent,
                child: Text(
                  "${_money(-data.payment, signed: true)}元",
                  style: const TextStyle(fontSize: 14, color: Colors.red),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "= ${_money(data.income - data.payment, signed: true)}元",
                style: TextStyle(
                  fontSize: 14,
                  color: _color(data.income - data.payment),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        /// 分类列表
        ...data.categoryList.map((category) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 分类名称 + 分类合计
                Row(
                  children: [
                    Text(
                      category.categoryName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: SaienteColors.appMain,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _openCategoryDetail(category),
                      behavior: HitTestBehavior.translucent,
                      child: Text(
                        '${_money(category.income, signed: true)}  '
                        '${_money(-category.payment, signed: true)}'
                        ' = ${_money(category.income - category.payment, signed: true)}元',
                        style: TextStyle(
                          fontSize: 13,
                          color: _color(category.income - category.payment),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// 表头
                const Row(
                  children: [
                    Expanded(child: Text("项目名称", style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                      child: Text(
                        "收入（元）",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "支出（元）",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "盈利",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// 三级明细
                ...category.list.map((e) {
                  return GestureDetector(
                    onTap: () {
                      if (onTap != null) {
                        onTap!.call(e);
                        return;
                      }
                      _openItemDetail(category.categoryName, e);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _openItemDetail(category.categoryName, e),
                              behavior: HitTestBehavior.translucent,
                              child: Text(e.name),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _openDetail(
                                category.categoryName,
                                e.incomeIdList.isEmpty ? category.incomeIdList : e.incomeIdList,
                                isIncome: true,
                              ),
                              behavior: HitTestBehavior.translucent,
                              child: Text(
                                e.income > 0 ? "+${e.income.toStringAsFixed(0)}" : "-",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: SaienteColors.appMain),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _openDetail(
                                category.categoryName,
                                e.payIdList.isEmpty ? category.payIdList : e.payIdList,
                              ),
                              behavior: HitTestBehavior.translucent,
                              child: Text(
                                e.payment > 0 ? "-${e.payment.toStringAsFixed(0)}" : "-",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              e.profit > 0
                                  ? "+${e.profit.toStringAsFixed(0)}"
                                  : e.profit.toStringAsFixed(0),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: _color(e.profit)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
