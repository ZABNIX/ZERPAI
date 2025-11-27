import '../models/item_model.dart';

abstract class ItemRepository {
  Future<List<Item>> getItems();
  Future<Item?> getItemById(String id);
  Future<Item> createItem(Item item);
  Future<Item> updateItem(Item item);
  Future<void> deleteItem(String id);
}

// Mock repo for development
class MockItemRepository implements ItemRepository {
  final List<Item> _items = [];
  int _nextId = 1;

  @override
  Future<List<Item>> getItems() async {
    return List.from(_items);
  }

  @override
  Future<Item?> getItemById(String id) async {
    try {
      return _items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Item> createItem(Item item) async {
    final newItem = item.copyWith(id: _nextId.toString());
    _nextId++;
    _items.add(newItem);
    return newItem;
  }

  @override
  Future<Item> updateItem(Item item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index == -1) {
      throw StateError('Item with id ${item.id} not found');
    }
    _items[index] = item;
    return item;
  }

  @override
  Future<void> deleteItem(String id) async {
    _items.removeWhere((i) => i.id == id);
  }
}
