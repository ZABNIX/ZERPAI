// PATH: lib/modules/items/models/item_model.dart

class ItemModel {
  final String id;
  final String name;
  final String sku;
  final String category;
  final double mrp;
  final double ptr;
  final bool isActive;

  const ItemModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.mrp,
    required this.ptr,
    this.isActive = true,
  });

  /// Convert model to Map (later used for Firebase/JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'category': category,
      'mrp': mrp,
      'ptr': ptr,
      'isActive': isActive,
    };
  }

  /// Convert Map to model
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      name: map['name'],
      sku: map['sku'],
      category: map['category'],
      mrp: (map['mrp'] ?? 0).toDouble(),
      ptr: (map['ptr'] ?? 0).toDouble(),
      isActive: map['isActive'] ?? true,
    );
  }

  /// Copy with updated values
  ItemModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    double? mrp,
    double? ptr,
    bool? isActive,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      mrp: mrp ?? this.mrp,
      ptr: ptr ?? this.ptr,
      isActive: isActive ?? this.isActive,
    );
  }
}
