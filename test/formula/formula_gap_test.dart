import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellectual_breed/app/models/formula.dart';
import 'package:intellectual_breed/app/widgets/formula_gap_warning.dart';

void main() {
  test('formula gap warning level follows actual gap percent boundaries', () {
    FormulaGapModel gap({double percent = 0, int level = 0}) => FormulaGapModel(
      name: '钙',
      baseValue: 10,
      value: 8,
      gapPercent: percent,
      rawMaterialName: '石粉',
      alertLevel: level,
      remark: '',
    );

    expect(gap(percent: 0.08).warningLevel, 0);
    expect(gap(percent: 0.1).warningLevel, 0);
    expect(gap(percent: 0.12).warningLevel, 1);
    expect(gap(percent: 0.19).warningLevel, 1);
    expect(gap(percent: 0.2).warningLevel, 1);
    expect(gap(percent: 0.201).warningLevel, 2);
    expect(gap(percent: 0.3).warningLevel, 2);
    // Actual ratio wins over a stale API alert level.
    expect(gap(percent: 0.12, level: 2).warningLevel, 1);
  });

  test('formula gap parser accepts legacy percentage responses', () {
    expect(
      FormulaGapModel.fromJson({'gapPercent': 25.6}).displayGapPercent,
      '25.6%',
    );
    expect(FormulaGapModel.fromJson({'gapPercent': '25.6%'}).warningLevel, 2);
    expect(
      FormulaGapModel.fromJson({
        'baseValue': 0.0464,
        'value': 0.0355,
        'alertLevel': 2,
      }).displayGapPercent,
      '23.5%',
    );
  });

  test('formula derives missing list gaps from nutrition values', () {
    final model = FormulaModel.fromJson({
      'baseCa': 0.0464,
      'ca': 0.0355,
      'baseP': 0.0258,
      'p': 0.0311,
    });

    expect(model.warningGaps, hasLength(1));
    expect(model.gapFor('钙(kg/d)')?.hasRedWarning, isTrue);
    expect(model.gapFor('钙(kg/d)')?.displayGapPercent, '23.5%');
    expect(model.gapFor('钙(kg/d)')?.rawMaterialName, '石粉');
  });

  test('formula finds a warning gap by nutrition row title', () {
    final model = FormulaModel.fromJson({
      'gaps': [
        {
          'name': '钙',
          'baseValue': 10,
          'value': 7.5,
          'gapPercent': 0.25,
          'rawMaterialName': '石粉',
          'alertLevel': 2,
          'remark': '',
        },
      ],
    });

    final gap = model.gapFor('钙(kg/d)');
    expect(gap?.hasRedWarning, isTrue);
    expect(gap?.warningMessage, '钙营养成分缺失，缺口为25%，建议增加石粉原料');
  });

  test(
    'formula uses the highest warning level and keeps gap data in payload',
    () {
      final gapMaps = [
        {
          'name': '粗蛋白',
          'baseValue': 10,
          'value': 8.8,
          'gapPercent': 0.12,
          'rawMaterialName': '豆粕',
          'alertLevel': 1,
          'remark': '',
        },
        {
          'name': '钙',
          'baseValue': 10,
          'value': 7.44,
          'gapPercent': 0.256,
          'rawMaterialName': '石粉',
          'alertLevel': 2,
          'remark': '',
        },
      ];
      final model = FormulaModel.fromJson({'gaps': gapMaps});

      expect(model.hasNutritionWarning, isTrue);
      expect(model.hasRedNutritionWarning, isTrue);
      expect(model.warningGaps.length, 2);
      expect(model.gapFor('粗蛋白需要量(kg/d)')?.displayGapPercent, '12%');
      expect(model.gapFor('钙(kg/d)')?.displayGapPercent, '25.6%');
      expect(FormulaModel.fromJson(model.toJson()).warningGaps.length, 2);
    },
  );

  testWidgets('warning card lists all gaps with individual severity colors', (
    tester,
  ) async {
    final gaps = [
      FormulaGapModel.fromJson({
        'name': '粗蛋白',
        'gapPercent': 0.125,
        'rawMaterialName': '豆粕',
      }),
      FormulaGapModel.fromJson({
        'name': '钙',
        'gapPercent': 0.256,
        'rawMaterialName': '石粉',
      }),
    ];

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: FormulaGapWarningCard(gaps: gaps))),
    );

    expect(find.text('粗蛋白营养成分缺失，缺口为12.5%，建议增加豆粕原料'), findsOneWidget);
    expect(find.text('钙营养成分缺失，缺口为25.6%，建议增加石粉原料'), findsOneWidget);
    expect(find.text('共2项营养成分缺失，建议补充后再保存'), findsOneWidget);

    final colors =
        tester
            .widgetList<Container>(find.byType(Container))
            .map((container) => container.decoration)
            .whereType<BoxDecoration>()
            .map((decoration) => decoration.color)
            .toList();
    expect(colors, contains(const Color(0xFFFFF3E0)));
    expect(colors, contains(const Color(0xFFFFE5E5)));
  });
}
