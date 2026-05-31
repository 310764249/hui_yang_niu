import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/page_info.dart';
import 'package:intellectual_breed/app/models/simple_event.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:intellectual_breed/app/services/colors.dart';

class DayProfitItem {
  final String name;
  final String? categoryName;

  /// 入库
  final double? income;

  /// 出库
  final double? payment;

  /// 当前库存
  final double profit;
  final List<String> incomeIdList;
  final List<String> payIdList;

  DayProfitItem({
    required this.name,
    this.categoryName,
    this.income,
    this.payment,
    required this.profit,
    this.incomeIdList = const [],
    this.payIdList = const [],
  });
}

class SingleDayProfitCard extends StatelessWidget {
  final String date;

  /// 总入库
  final double totalIncome;

  /// 总出库
  final double totalPayment;

  final List<DayProfitItem> list;

  final void Function(DayProfitItem item)? onTap;

  const SingleDayProfitCard({
    super.key,
    required this.date,
    required this.totalIncome,
    required this.totalPayment,
    required this.list,
    this.onTap,
  });

  static final HttpsClient _httpsClient = HttpsClient();

  void _openDetail(DayProfitItem item, List<String> ids, {bool isIncome = false}) {
    if (ids.isEmpty) {
      return;
    }
    final categoryName = item.categoryName ?? item.name;
    String id = ids.first;
    if (categoryName.contains('人工') || item.name.contains('人工') || item.name.contains('工资')) {
      Get.toNamed(Routes.MANUAL_ASSESS_DETAIL, arguments: id);
    } else if (categoryName.contains('销售') || item.name.contains('销售')) {
      Get.toNamed(Routes.SALES_ASSESS_DETAIL, arguments: id);
    } else if (categoryName.contains('采购') || item.name.contains('采购')) {
      Get.toNamed(Routes.PURCHASE_ASSESS_DETAIL, arguments: id);
    } else if (isIncome) {
      Get.toNamed(Routes.SALES_ASSESS_DETAIL, arguments: id);
    } else {
      Get.toNamed(Routes.PURCHASE_ASSESS_DETAIL, arguments: id);
    }
  }

  Future<void> _openItemDetail(DayProfitItem item) async {
    final incomeIds = _resolveIncomeIds(item);
    if (incomeIds.isNotEmpty) {
      _openDetail(item, incomeIds, isIncome: true);
      return;
    }
    final payIds = _resolvePayIds(item);
    if (payIds.isNotEmpty) {
      _openDetail(item, payIds);
      return;
    }

    if (_allIncomeIds().isNotEmpty) {
      _openDetail(item, _allIncomeIds(), isIncome: true);
      return;
    }
    if (_allPayIds().isNotEmpty) {
      _openDetail(item, _allPayIds());
      return;
    }

    await _openDetailByLookup(item);
  }

  Future<void> _openIncomeDetail(DayProfitItem item) async {
    final incomeIds = _resolveIncomeIds(item);
    if (incomeIds.isNotEmpty) {
      _openDetail(item, incomeIds, isIncome: true);
      return;
    }
    await _openDetailByLookup(item);
  }

  Future<void> _openPayDetail(DayProfitItem item) async {
    final payIds = _resolvePayIds(item);
    if (payIds.isNotEmpty) {
      _openDetail(item, payIds);
      return;
    }
    await _openDetailByLookup(item);
  }

  List<String> _resolveIncomeIds(DayProfitItem item) {
    if (item.incomeIdList.isNotEmpty) {
      return item.incomeIdList;
    }
    if ((item.income ?? 0) > 0) {
      return _allIncomeIds();
    }
    return const [];
  }

  List<String> _resolvePayIds(DayProfitItem item) {
    if (item.payIdList.isNotEmpty) {
      return item.payIdList;
    }
    if ((item.payment ?? 0) > 0) {
      return _allPayIds();
    }
    return const [];
  }

  List<String> _allIncomeIds() {
    return list.expand((e) => e.incomeIdList).toList();
  }

  List<String> _allPayIds() {
    return list.expand((e) => e.payIdList).toList();
  }

  Future<void> _openDetailByLookup(DayProfitItem item) async {
    final lookup = _buildLookup(item);
    if (lookup == null) {
      Toast.show('暂无详情');
      return;
    }

    try {
      Toast.showLoading();
      final response = await _httpsClient.get(
        lookup.api,
        queryParameters: {'PageIndex': 1, 'PageSize': 200},
      );
      final pageInfo = PageInfo.fromJson(response);
      final events =
          pageInfo.list
              .whereType<Map<String, dynamic>>()
              .map(SimpleEvent.fromJson)
              .toList();
      final matched = events.cast<SimpleEvent?>().firstWhere(
        (event) => event != null && lookup.matcher(event),
        orElse: () => null,
      );
      Toast.dismiss();
      if (matched == null) {
        Toast.show('未找到对应详情');
        return;
      }
      Get.toNamed(lookup.route, arguments: matched);
    } catch (error) {
      Toast.dismiss();
      if (error is ApiException) {
        Toast.failure(msg: error.toString());
      } else {
        Toast.show('跳转失败');
      }
    }
  }

  _LookupConfig? _buildLookup(DayProfitItem item) {
    final categoryName = item.categoryName ?? item.name;
    final normalizedName = item.name.replaceAll(RegExp(r'^(采购|销售|人工|工资)[-:：]?'), '').trim();

    if (categoryName.contains('人工') || item.name.contains('人工') || item.name.contains('工资')) {
      final manualTypes = AppDictList.searchItems('rglx') ?? [];
      return _LookupConfig(
        api: '/api/manualWork',
        route: Routes.MANUAL_ASSESS_DETAIL,
        matcher: (event) {
          final eventDate = (event.date ?? '').split(' ').first;
          if (eventDate != date) {
            return false;
          }
          final amount = double.tryParse('${event.data['amount'] ?? ''}') ?? 0;
          if ((amount - (item.payment ?? item.income ?? 0)).abs() > 0.01) {
            return false;
          }
          Map? type;
          for (final entry in manualTypes) {
            if ('${entry['value']}' == '${event.type}') {
              type = entry;
              break;
            }
          }
          final label = (type?['label'] ?? '').toString();
          return label.isEmpty || categoryName.contains(label) || item.name.contains(label);
        },
      );
    }

    if (categoryName.contains('采购') || item.name.contains('采购')) {
      return _LookupConfig(
        api: '/api/purchase',
        route: Routes.PURCHASE_ASSESS_DETAIL,
        matcher: (event) {
          final eventDate = (event.date ?? '').split(' ').first;
          if (eventDate != date) {
            return false;
          }
          final amount = double.tryParse('${event.data['amount'] ?? ''}') ?? 0;
          final name = (event.data['name'] ?? '').toString().trim();
          return (amount - (item.payment ?? 0)).abs() <= 0.01 &&
              (name == normalizedName || item.name.contains(name));
        },
      );
    }

    if (categoryName.contains('销售') || item.name.contains('销售')) {
      return _LookupConfig(
        api: '/api/sales',
        route: Routes.SALES_ASSESS_DETAIL,
        matcher: (event) {
          final eventDate = (event.date ?? '').split(' ').first;
          if (eventDate != date) {
            return false;
          }
          final amount = double.tryParse('${event.data['amount'] ?? ''}') ?? 0;
          return (amount - (item.income ?? 0)).abs() <= 0.01;
        },
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 顶部日期 + 总库存统计
          Row(
            children: [
              Text(date, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => _openDetail(
                        DayProfitItem(name: '销售', profit: 0),
                        _allIncomeIds(),
                        isIncome: true,
                      ),
                      behavior: HitTestBehavior.translucent,
                      child: Text(
                        totalIncome.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 15,
                          color: SaienteColors.appMain,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Text(' - '),
                    GestureDetector(
                      onTap: () => _openDetail(DayProfitItem(name: '采购', profit: 0), _allPayIds()),
                      behavior: HitTestBehavior.translucent,
                      child: Text(
                        totalPayment.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      ' = ${(totalIncome - totalPayment).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: SaienteColors.appMain,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // const Spacer(),
              //
              // Text(
              //   '入库 ${totalIncome.toStringAsFixed(0)}',
              //   style: const TextStyle(fontSize: 14, color: SaienteColors.appMain),
              // ),
              //
              // const SizedBox(width: 12),
              //
              // Text(
              //   '出库 ${totalPayment.toStringAsFixed(0)}',
              //   style: const TextStyle(fontSize: 14, color: Colors.red),
              // ),
            ],
          ),

          const SizedBox(height: 12),

          /// 表头
          const Row(
            children: [
              Expanded(child: Text('物资名称', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                child: Text(
                  '入库',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  '出库',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  '当前库存',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// 内容列表
          ...list.map((e) {
            return GestureDetector(
              onTap: () async {
                if (onTap != null) {
                  onTap!.call(e);
                  return;
                }
                await _openItemDetail(e);
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    /// 名称
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => _openItemDetail(e),
                        behavior: HitTestBehavior.translucent,
                        child: Text(e.name),
                      ),
                    ),

                    /// 入库
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => _openIncomeDetail(e),
                        behavior: HitTestBehavior.translucent,
                        child: Text(
                          e.income == null || e.income == 0 ? '-' : e.income!.toStringAsFixed(0),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: SaienteColors.appMain),
                        ),
                      ),
                    ),

                    /// 出库
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => _openPayDetail(e),
                        behavior: HitTestBehavior.translucent,
                        child: Text(
                          e.payment == null || e.payment == 0 ? '-' : e.payment!.toStringAsFixed(0),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),

                    /// 当前库存
                    Expanded(
                      child: Text(
                        e.profit.toStringAsFixed(0),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: SaienteColors.appMain,
                          fontWeight: FontWeight.w500,
                        ),
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
  }
}

class _LookupConfig {
  final String api;
  final String route;
  final bool Function(SimpleEvent event) matcher;

  const _LookupConfig({
    required this.api,
    required this.route,
    required this.matcher,
  });
}
