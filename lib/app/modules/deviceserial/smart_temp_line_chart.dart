import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/smart_ear_tag_model.dart';

import '../../models/smart_weight_model.dart';

class SmartTempLineChart extends StatelessWidget {
  /// 数据记录
  final List<WeightRecord> records;

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

    /// Y轴上下留白
    double minY = minValue - 2;
    double maxY = maxValue + 2;

    /// 防止最大最小一样
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
            /// 单点时给左右留空间
            minX: -0.5,
            maxX: isSinglePoint ? 0.5 : spots.length - 0.5,

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

                /// 单点不使用曲线
                isCurved: spots.length > 1,

                barWidth: 3,

                color: Colors.redAccent,

                isStrokeCapRound: true,

                /// 点
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

                /// 渐变区域
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

                    /// 单点处理
                    if (isSinglePoint) {
                      /// 只显示中间这个
                      if (value != 0) {
                        return const SizedBox.shrink();
                      }

                      index = 0;
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
                          /// 日期
                          Text(
                            '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 9),
                          ),

                          // if (unit != '℃')
                          //   Text('${date.year}', style: const TextStyle(fontSize: 9)),

                          /// 有时间才显示时间
                          if (!(date.hour == 0 && date.minute == 0))
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
                    /// 不显示首尾
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
    /// 单点
    if (records.length == 1) {
      return [FlSpot(0, records.first.value.toDouble())];
    }

    return List.generate(records.length, (index) {
      return FlSpot(index.toDouble(), records[index].value.toDouble());
    });
  }

  /// X轴间隔
  double _calcInterval() {
    if (records.length <= 1) {
      return 1;
    }

    if (records.length <= 6) {
      return 1;
    }

    if (records.length <= 12) {
      return 2;
    }

    return (records.length / 6).ceilToDouble();
  }
}
