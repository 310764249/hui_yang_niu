import 'package:flutter/material.dart';

import '../models/formula.dart';
import '../services/colors.dart';

class FormulaGapWarningIcon extends StatelessWidget {
  const FormulaGapWarningIcon({super.key, required this.gap, this.size = 18});

  final FormulaGapModel gap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: gap.warningMessage,
      child: Icon(
        Icons.error,
        size: size,
        color: gap.hasRedWarning ? SaienteColors.redFF3D3D : Colors.orange,
      ),
    );
  }
}

class FormulaGapWarningCard extends StatelessWidget {
  const FormulaGapWarningCard({super.key, required this.gaps, this.margin});

  final List<FormulaGapModel> gaps;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final warningGaps = gaps.where((gap) => gap.hasWarning).toList();
    if (warningGaps.isEmpty) return const SizedBox.shrink();

    final isRed = warningGaps.any((gap) => gap.hasRedWarning);
    final color = isRed ? SaienteColors.redFF3D3D : Colors.orange;

    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isRed ? const Color(0xFFFFE5E5) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '共${warningGaps.length}项营养成分缺失，建议补充后再保存',
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          for (final gap in warningGaps)
            Text(
              gap.warningMessage,
              style: TextStyle(color: color, fontSize: 14, height: 1.35),
            ),
        ],
      ),
    );
  }
}
