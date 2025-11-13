import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zerpai_erp/modules/items/repo/items_repository.dart';

// Fix import using relative path (same folder)
import 'item_repository.dart';

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return MockItemRepository(); // Development mode

  // When backend ready:
  // final dio = Dio(BaseOptions(baseUrl: "https://your-api.com"));
  // return ApiItemRepository(dio);
});
