import 'package:flutter_test/flutter_test.dart';
import 'package:intellectual_breed/app/models/raw_material.dart';
import 'package:intellectual_breed/app/modules/recipe_create/controllers/recipe_create_controller.dart';

RawMaterial rawMaterial({
  required String name,
  required int type,
  required int individualType,
}) {
  return RawMaterial.fromJson({
    'id': name,
    'name': name,
    'type': type,
    'category': 2,
    'individualType': individualType,
  });
}

void main() {
  test('fattening cow supports legacy and current weight dictionary values',
      () {
    final controller = RecipeCreateController();
    controller.gtzlList.value = [
      {'label': '200kg', 'value': 200},
      {'label': '300kg', 'value': '300'},
      {'label': '480kg', 'value': 480},
    ];

    controller.gtzlSelIndex = 1;
    expect(controller.selectedWeightType, 300);
    expect(controller.dailyGainOptionsForSelectedWeight(), [
      0.0,
      0.6,
      0.8,
      1.0,
      1.2,
      1.4,
    ]);

    controller.gtzlSelIndex = 2;
    expect(controller.dailyGainOptionsForSelectedWeight(), [
      0.0,
      1.0,
      1.2,
      1.4,
      1.6,
      1.8,
    ]);
  });

  test('weight value falls back to the numeric part of its label', () {
    final controller = RecipeCreateController();
    controller.gtzlList.value = [
      {'label': '350kg', 'value': null},
    ];
    controller.gtzlSelIndex = 0;

    expect(controller.selectedWeightType, 350);
    expect(controller.dailyGainOptionsForSelectedWeight(), isNotEmpty);
  });

  test('additives are filtered after raw materials arrive', () {
    final controller = RecipeCreateController();
    controller.tjjListTotal = [
      rawMaterial(name: '母牛添加剂', type: 4, individualType: 2),
      rawMaterial(name: '公牛添加剂', type: 4, individualType: 1),
      rawMaterial(name: '通用添加剂', type: 4, individualType: 0),
    ];

    controller.gtlxValue.value = 1;
    controller.updateYhlList();
    expect(controller.tjjNameList, ['母牛添加剂', '通用添加剂']);

    controller.updateTjjSelectedItems([0]);
    expect(controller.tjjSelectedDisplayNames.value, '母牛添加剂');

    controller.gtlxValue.value = 4;
    controller.updateYhlList();
    expect(controller.tjjNameList, ['公牛添加剂', '通用添加剂']);
    expect(controller.tjjSelectedObjList, isEmpty);
    expect(controller.tjjSelectedDisplayNames.value, isEmpty);
  });

  test('additives use backend target codes when available', () {
    final controller = RecipeCreateController();
    controller.tjjListTotal = [
      rawMaterial(name: '妊娠添加剂', type: 4, individualType: 1),
      rawMaterial(name: '哺乳添加剂', type: 4, individualType: 3),
      rawMaterial(name: '育肥添加剂', type: 4, individualType: 4),
    ];

    controller.gtlxValue.value = 3;
    controller.updateYhlList();
    expect(controller.tjjNameList, ['哺乳添加剂']);

    controller.gtlxValue.value = 4;
    controller.updateYhlList();
    expect(controller.tjjNameList, ['育肥添加剂']);
  });
}
