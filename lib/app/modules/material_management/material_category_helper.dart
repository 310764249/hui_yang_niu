Set<String> medicalMaterialCategoryValues(List categories) {
  final maps = categories.whereType<Map>();
  final combined = maps.where(
    (item) => _categoryNames(
      item,
    ).any((name) => name.contains('兽药') && name.contains('疫苗')),
  );
  final medicalCategories =
      combined.isNotEmpty
          ? combined
          : maps.where(
            (item) => _categoryNames(
              item,
            ).any((name) => name == '兽药' || name == '疫苗'),
          );

  return medicalCategories
      .map((item) => normalizedMaterialCategoryValue(item['value']))
      .whereType<String>()
      .toSet();
}

String? normalizedMaterialCategoryValue(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toInt().toString();
  final text = value.toString().trim();
  return num.tryParse(text)?.toInt().toString() ?? text;
}

Iterable<String> _categoryNames(Map item) sync* {
  for (final value in [item['key'], item['label'], item['name']]) {
    final name = value?.toString().replaceAll(RegExp(r'\s+'), '') ?? '';
    if (name.isNotEmpty) yield name;
  }
}
