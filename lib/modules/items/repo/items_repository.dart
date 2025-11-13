// FILE: lib/modules/items/repo/items_repository.dart

import 'package:zerpai_erp/modules/items/models/item_model.dart';

/// Base repository interface
abstract class ItemRepository {
  Future<List<Item>> getItems();
  Future<Item?> getItemById(String id);
  Future<Item> createItem(Item item);
  Future<Item> updateItem(Item item);
  Future<void> deleteItem(String id);
}

class Item {
  get id => null;

  copyWith({required String id}) {}
}

/// Mock implementation for development (no backend needed)
class MockItemRepository implements ItemRepository {
  final List<Item> _items = [];
  int _idCounter = 1;

  @override
  Future<List<Item>> getItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_items);
  }

  @override
  Future<Item?> getItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Item> createItem(Item item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newItem = item.copyWith(id: _idCounter.toString());
    _items.add(newItem);
    _idCounter++;
    return newItem;
  }

  @override
  Future<Item> updateItem(Item item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
      return item;
    }
    throw Exception("Item not found");
  }

  @override
  Future<void> deleteItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _items.removeWhere((item) => item.id == id);
  }
}
