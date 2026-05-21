import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/smart_ear_tag_model.dart';

class SmartTempLineChart extends StatelessWidget {
  /// 数据记录
  final List<TempRecord> records;

  /// 单位（如 ℃ / kg）
  final String unit;

  /// 动画时长
  final Duration animationDuration;

  const SmartTempLineChart({
    super.key,
    required this.records,
    required this.unit,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Center(child: Text('暂无数据'));
    }

    final spots = _buildSpots();

    /// 是否只有一个点
    final bool isSinglePoint = spots.length == 1;

    final minValue = records.map((e) => e.value.toDouble()).reduce((a, b) => a < b ? a : b);

    final maxValue = records.map((e) => e.value.toDouble()).reduce((a, b) => a > b ? a : b);

    /// 避免只有一个值导致上下重叠
    double minY = minValue - 2;
    double maxY = maxValue + 2;

    /// 如果最大最小一样，再额外撑开
    if (minY == maxY) {
      minY -= 1;
      maxY += 1;
    }

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 280,
        child: LineChart(
          duration: animationDuration,
          LineChartData(
            /// 单点时必须拉开 X 轴范围
            minX: isSinglePoint ? 0 : -0.5,
            maxX: isSinglePoint ? 1 : spots.length - 0.5,

            minY: minY,
            maxY: maxY,

            lineTouchData: const LineTouchData(handleBuiltInTouches: true),

            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: ((maxY - minY) / 5).clamp(1, 999),
              getDrawingHorizontalLine: (value) {
                return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
              },
              getDrawingVerticalLine: (value) {
                return FlLine(color: Colors.grey.shade100, strokeWidth: 1);
              },
            ),

            borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),

            lineBarsData: [
              LineChartBarData(
                spots: spots,

                /// 单个点不要曲线
                isCurved: spots.length > 1,

                barWidth: 3,

                color: Colors.redAccent,

                isStrokeCapRound: true,

                /// 单个点一定要显示
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.redAccent,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),

                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.redAccent.withOpacity(0.25),
                      Colors.redAccent.withOpacity(0.03),
                    ],
                  ),
                ),
              ),
            ],

            titlesData: FlTitlesData(
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

              /// X轴
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  interval: _calcInterval(),
                  getTitlesWidget: (value, meta) {
                    int index;

                    /// 单点特殊处理
                    if (isSinglePoint) {
                      index = 0;

                      /// 只在中间显示一次
                      if (value != 0.5) {
                        return const SizedBox.shrink();
                      }
                    } else {
                      index = value.round();

                      if (index < 0 || index >= records.length) {
                        return const SizedBox.shrink();
                      }
                    }

                    final date = records[index].date;

                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 9),
                          ),

                          /// 温度才显示时间
                          if (unit == '℃')
                            Text(
                              '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 9),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// Y轴
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 46,
                  interval: ((maxY - minY) / 5).clamp(1, 999),

                  getTitlesWidget: (value, meta) {
                    /// 不显示首尾，避免挤压
                    if (value == meta.min || value == meta.max) {
                      return const SizedBox.shrink();
                    }

                    return Text(
                      '${value.toStringAsFixed(0)}$unit',
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建折线点
  List<FlSpot> _buildSpots() {
    /// 单点特殊处理
    if (records.length == 1) {
      return [FlSpot(0.5, records.first.value.toDouble())];
    }

    return List.generate(records.length, (index) {
      return FlSpot(index.toDouble(), records[index].value.toDouble());
    });
  }

  /// X轴间隔
  double _calcInterval() {
    if (records.length <= 1) return 1;
    if (records.length <= 6) return 1;
    if (records.length <= 12) return 2;

    return (records.length / 6).ceilToDouble();
  }
}
