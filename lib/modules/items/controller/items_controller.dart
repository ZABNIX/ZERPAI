import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerpai_erp/modules/items/repo/items_repository.dart';
import '../repo/item_repository_provider.dart';
import '../models/item_model.dart';
import 'items_state.dart';

class ItemsController extends StateNotifier<ItemsState> {
  final ItemRepository repo;

  ItemsController(this.repo) : super(const ItemsState()) {
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      state = state.copyWith(isLoading: true);
      final items = await repo.getItems();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: "Failed to load items");
    }
  }

  Future<void> createItem(Item item) async {
    try {
      state = state.copyWith(isSaving: true);
      await repo.createItem(item);
      await loadItems();
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(error: "Failed to save item", isSaving: false);
    }
  }

  Future<void> deleteItem(String id) async {
    await repo.deleteItem(id);
    await loadItems();
  }
}

final itemsControllerProvider =
    StateNotifierProvider<ItemsController, ItemsState>((ref) {
      final repository = ref.watch(itemRepositoryProvider);
      return ItemsController(repository);
    });
