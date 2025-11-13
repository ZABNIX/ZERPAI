import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item_model.dart';

class ItemsState {
  final bool isSaving;
  final String? errorMessage;

  const ItemsState({this.isSaving = false, this.errorMessage});

  ItemsState copyWith({bool? isSaving, String? errorMessage}) {
    return ItemsState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
    );
  }
}

class ItemsController extends StateNotifier<ItemsState> {
  ItemsController() : super(const ItemsState());

  Future<void> createItem(ItemModel item) async {
    try {
      state = state.copyWith(isSaving: true, errorMessage: null);

      // TODO: Replace this with your real API/service call
      await Future.delayed(const Duration(seconds: 1));

      // If success:
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save item: $e',
      );
    }
  }
}

final itemsControllerProvider =
    StateNotifierProvider<ItemsController, ItemsState>(
      (ref) => ItemsController(),
    );
