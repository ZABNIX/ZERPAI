import '../models/item_model.dart';

class ItemsState {
  final List<Item> items;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  const ItemsState({
    this.items = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  ItemsState copyWith({
    List<Item>? items,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return ItemsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }
}
