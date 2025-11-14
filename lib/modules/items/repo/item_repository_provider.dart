import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'items_repository.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return MockItemRepository(); // Development mode
});
