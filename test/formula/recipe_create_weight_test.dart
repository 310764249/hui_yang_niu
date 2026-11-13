import 'package:flutter_test/flutter_test.dart';
import 'package:intellectual_breed/app/modules/recipe_create/controllers/recipe_create_controller.dart';

void main() {
  test('fattening cow supports legacy and current weight dictionary values', () {
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
}
