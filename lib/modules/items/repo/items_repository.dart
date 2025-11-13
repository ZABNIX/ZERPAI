// PATH: lib/modules/items/repo/items_repository.dart

import 'package:uuid/uuid.dart';
import '../models/item_model.dart';

class ItemsRepository {
  final _uuid = const Uuid();

  // Temporary local dummy item list (will replace with Firebase later)
  final List<ItemModel> _items = [
    ItemModel(
      id: const Uuid().v4(),
      name: 'Paracetamol 500mg Tablet',
      sku: 'PARA500',
      category: 'Analgesics',
      mrp: 35.0,
      ptr: 21.0,
    ),
    ItemModel(
      id: const Uuid().v4(),
      name: 'Azithromycin 500mg',
      sku: 'AZI500',
      category: 'Antibiotics',
      mrp: 120.0,
      ptr: 80.0,
    ),
  ];

  List<ItemModel> getAllItems() {
    return _items;
  }

  void addItem(ItemModel item) {
    _items.add(item);
  }

  void updateItem(ItemModel item) {
    int index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }
}
