import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/widgets/empty_view.dart';

import '../../models/abnormal_list_entity.dart';

class AbnormalListView extends StatefulWidget {
  const AbnormalListView({super.key});

  @override
  State<AbnormalListView> createState() => _AbnormalListViewState();
}

class _AbnormalListViewState extends State<AbnormalListView> with AutomaticKeepAliveClientMixin {
  HttpsClient httpsClient = HttpsClient();

  AbnormalListEntity? abnormalListEntity;

  getAbnormalList() async {
    String api = '/api/intelligenteartag/getabnormallist';
    var response = await httpsClient.get(api);
    try {
      AbnormalListEntity abnormalListEntity = AbnormalListEntity.fromJson(response);
      setState(() {
        this.abnormalListEntity = abnormalListEntity;
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  /// 筛选类型
  int selectedType = 0;

  /// 0=全部 1=体温异常 2=环境异常 3=耳标丢失
  List<AbnormalItemModel> get filterList {
    final List<AbnormalItemModel> list = [...(abnormalListEntity?.list ?? <AbnormalItemModel>[])]
      ..sort((a, b) => (b.updateTime ?? DateTime(2000)).compareTo(a.updateTime ?? DateTime(2000)));

    switch (selectedType) {
      case 1:
        return list.where((e) => _isOn(e.high)).toList();

      case 2:
        return list.where((e) => _isOn(e.low)).toList();

      case 3:
        return list.where((e) => _isOn(e.lose)).toList();

      default:
        return list;
    }
  }

  bool _isHigh(AbnormalItemModel item) {
    return _isOn(item.high);
  }

  bool _isLow(AbnormalItemModel item) {
    return _isOn(item.low);
  }

  bool _isLose(AbnormalItemModel item) {
    return _isOn(item.lose);
  }

  bool _isOn(String? v) => v == 'on';

  @override
  void initState() {
    super.initState();
    getAbnormalList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (abnormalListEntity == null) {
      return const EmptyView();
    }

    /// 按时间倒序
    final list = filterList;
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          /// 顶部统计
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTopItem(
                  color: Colors.red,
                  count: abnormalListEntity?.highNum ?? 0,
                  title: '体温异常',
                ),

                _buildTopItem(
                  color: const Color(0xFF8BC34A),
                  count: abnormalListEntity?.lowNum ?? 0,
                  title: '环境异常',
                ),

                _buildTopItem(
                  color: const Color(0xFFE6B31E),
                  count: abnormalListEntity?.loseNum ?? 0,
                  title: '耳标丢失',
                ),
              ],
            ),
          ),

          Container(height: 1, color: const Color(0xFFF2F2F2)),

          /// 筛选
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Row(
              children: [
                Expanded(child: _buildFilterItem(title: '全部', index: 0)),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterDotItem(color: Colors.red, label: '体温异常', index: 1),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterDotItem(color: const Color(0xFF8BC34A), label: '环境异常', index: 2),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterDotItem(color: const Color(0xFFE6B31E), label: '耳标丢失', index: 3),
                ),
              ],
            ),
          ),

          /// 表头
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(color: Color(0xFFF7F8FA)),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text('类型', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text('耳号', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text('位置', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text('时间', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),

          /// 数据
          if (list.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 50), child: EmptyView())
          else
            Expanded(
              child: ListView.separated(
                itemCount: list.length,

                separatorBuilder: (_, __) => Container(height: 1, color: const Color(0xFFF5F5F5)),
                itemBuilder: (context, index) {
                  final item = list[index];

                  return Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        /// 类型
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: _typeColor(item),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),

                        /// 耳号
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              _text(item.code),
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
                            ),
                          ),
                        ),

                        /// 位置
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: Text(
                              _text(item.envGps),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                          ),
                        ),

                        /// 时间
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: Text(
                              _timeText(item),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// 筛选
  Widget _buildFilterItem({required String title, required int index}) {
    final bool selected = selectedType == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF3D6DCC) : const Color(0xFFF4F6FA),

          borderRadius: BorderRadius.circular(10),

          border: Border.all(color: selected ? const Color(0xFF3D6DCC) : const Color(0xFFE5E7EB)),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF666666),
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDotItem({required Color color, required String label, required int index}) {
    final bool selected = selectedType == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : const Color(0xFFF4F6FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? color : const Color(0xFFE5E7EB), width: selected ? 2 : 1),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    color: selected ? color : const Color(0xFF666666),
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 顶部统计
  Widget _buildTopItem({required Color color, required int count, required String title}) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Text(
            '$count',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  /// 类型颜色
  Color _typeColor(AbnormalItemModel item) {
    if (_isHigh(item)) {
      return Colors.red;
    }

    if (_isLow(item)) {
      return const Color(0xFF8BC34A);
    }

    if (_isLose(item)) {
      return const Color(0xFFE6B31E);
    }

    return Colors.grey;
  }

  /// 时间格式
  String _timeText(AbnormalItemModel item) {
    final time = item.updateTime;

    if (time == null) {
      final raw = item.updateTimeStr?.trim();
      return raw == null || raw.isEmpty ? '--' : raw;
    }

    String two(int v) => v.toString().padLeft(2, '0');

    return '${two(time.month)}-${two(time.day)} '
        '${two(time.hour)}:${two(time.minute)}';
  }

  /// 空值处理
  String _text(dynamic value) {
    if (value == null) return '--';

    final str = value.toString().trim();

    if (str.isEmpty || str == 'null') {
      return '--';
    }

    return str;
  }

  @override
  bool get wantKeepAlive => true;
}
