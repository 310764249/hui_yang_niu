import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/smart_ear_tag_model.dart';

class SmartTempLineChart extends StatelessWidget {
  /// 温度记录
  final List<TempRecord> records;

  /// Y 轴单位（必传，如 ℃）
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
    final minY = records.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final maxY = records.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(26),
        height: 260,
        child: LineChart(
          LineChartData(
            /// ✅ 关键：左右各留半格，防止最后一列被挤压
            minX: -0.5,
            maxX: spots.length - 0.5,

            minY: minY.toDouble() - 2,
            maxY: maxY.toDouble() + 2,

            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [Colors.redAccent.withOpacity(0.3), Colors.redAccent.withOpacity(0.05)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],

            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),

            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

              /// X 轴：日期 + 时间（换行）
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: _calcInterval(),
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    final index = value.round();
                    if (index < 0 || index >= records.length) {
                      return const SizedBox.shrink();
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

              /// Y 轴：数值 + 单位
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()}$unit', style: const TextStyle(fontSize: 10));
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
    return List.generate(
      records.length,
      (index) => FlSpot(index.toDouble(), records[index].value.toDouble()),
    );
  }

  /// 根据数据量自动计算 X 轴间隔
  double _calcInterval() {
    if (records.length <= 6) return 1;
    if (records.length <= 12) return 2;
    return (records.length / 6).ceilToDouble();
  }
}
