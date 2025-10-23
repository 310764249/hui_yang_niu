class FeedPreparationModel {
  final String formulaId;
  final String formulaName;
  final int feedType;
  final double totalWeight;
  final List<RawMaterial> rawMaterials;

  FeedPreparationModel({
    required this.formulaId,
    required this.formulaName,
    required this.feedType,
    required this.totalWeight,
    required this.rawMaterials,
  });

  factory FeedPreparationModel.fromJson(Map<String, dynamic> json) {
    return FeedPreparationModel(
      formulaId: json['formulaId'] ?? '',
      formulaName: json['formulaName'] ?? '',
      feedType: json['feedType'] ?? 0,
      totalWeight: (json['totalWeight'] ?? 0).toDouble(),
      rawMaterials:
          (json['rawMaterials'] as List<dynamic>? ?? [])
              .map((e) => RawMaterial.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formulaId': formulaId,
      'formulaName': formulaName,
      'feedType': feedType,
      'totalWeight': totalWeight,
      'rawMaterials': rawMaterials.map((e) => e.toJson()).toList(),
    };
  }
}

class RawMaterial {
  final String id;
  final String name;
  final double weight;
  final double price;

  RawMaterial({required this.id, required this.name, required this.weight, required this.price});

  factory RawMaterial.fromJson(Map<String, dynamic> json) {
    return RawMaterial(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      weight: (json['weight'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'weight': weight, 'price': price};
  }
}
