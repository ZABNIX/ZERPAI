// PATH: lib/modules/items/controller/items_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';
import '../repo/items_repository.dart';

final itemsRepositoryProvider = Provider<ItemsRepository>((ref) {
  return ItemsRepository();
});

final itemsControllerProvider =
    StateNotifierProvider<ItemsController, List<ItemModel>>((ref) {
      final repo = ref.read(itemsRepositoryProvider);
      return ItemsController(repo);
    });

class ItemsController extends StateNotifier<List<ItemModel>> {
  final ItemsRepository _repository;

  ItemsController(this._repository) : super([]) {
    loadItems();
  }

  void loadItems() {
    state = _repository.getAllItems();
  }

  void addItem(ItemModel item) {
    _repository.addItem(item);
    loadItems();
  }

  void updateItem(ItemModel updated) {
    _repository.updateItem(updated);
    loadItems();
  }

  void deleteItem(String id) {
    _repository.deleteItem(id);
    loadItems();
  }
}
