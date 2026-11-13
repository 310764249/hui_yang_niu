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

    return Padding(
      padding: margin ?? EdgeInsets.zero,
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
          const SizedBox(height: 8),
          for (final gap in warningGaps) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color:
                    gap.hasRedWarning
                        ? const Color(0xFFFFE5E5)
                        : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                gap.warningMessage,
                style: TextStyle(
                  color:
                      gap.hasRedWarning
                          ? SaienteColors.redFF3D3D
                          : Colors.orange,
                  fontSize: 14,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
