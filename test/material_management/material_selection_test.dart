import 'package:flutter_test/flutter_test.dart';
import 'package:intellectual_breed/app/models/material_item_model.dart';
import 'package:intellectual_breed/app/modules/material_management/material_category_helper.dart';

void main() {
  group('material unit parsing', () {
    test('does not treat a non-numeric unit identifier as a display name', () {
      const unitId = 'f0603dc4-e7e1-4819-acad-e116af16d723';
      final material = MaterialItemModel.fromJson({'unit': unitId});

      expect(material.unit, isNull);
      expect(material.unitName, isNull);
    });

    test('continues to parse the numeric unit value used elsewhere', () {
      final material = MaterialItemModel.fromJson({'unit': 3});

      expect(material.unit, 3);
    });
  });

  group('medical material categories', () {
    test('selects only the combined veterinary medicine vaccine category', () {
      final result = medicalMaterialCategoryValues([
        {'key': '饲料原料', 'value': 1},
        {'key': '兽药疫苗', 'value': 5},
        {'key': '其他', 'value': 6},
      ]);

      expect(result, {'5'});
    });

    test('supports separate veterinary medicine and vaccine categories', () {
      final result = medicalMaterialCategoryValues([
        {'label': '饲料原料', 'value': 1},
        {'label': '兽药', 'value': 3},
        {'label': '疫苗', 'value': 4},
      ]);

      expect(result, {'3', '4'});
    });
  });
}
