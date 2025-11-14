// FILE: lib/modules/items/models/item_model.dart

class Item {
  final String? id;
  final String name;
  final String? sku;
  final String? category;
  final double? mrp;

  Item({this.id, required this.name, this.sku, this.category, this.mrp});

  Item copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    double? mrp,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      mrp: mrp ?? this.mrp,
    );
  }

  // For API / DB support
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id']?.toString(),
      name: json['name'] ?? "",
      sku: json['sku'],
      category: json['category'],
      mrp: json['mrp'] != null ? double.tryParse(json['mrp'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "sku": sku,
      "category": category,
      "mrp": mrp,
    };
  }
}
