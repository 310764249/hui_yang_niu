class CommonData {
  CommonData({
    required this.id,
    required this.name,
    this.value,
    this.image,
    this.unit,
    this.isSelected,
  });
  late final int id;
  late final String name;
  late final String? value;
  late final String? image;
  late final String? unit; // 单位
  bool? isSelected = false; // 是否选中

  CommonData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    image = json['image'];
    unit = json['unit'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    data['image'] = image;
    data['unit'] = unit;
    data['isSelected'] = isSelected;
    return data;
  }
}
