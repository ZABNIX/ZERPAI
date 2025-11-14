import 'package:go_router/go_router.dart';
import '../../modules/items/presentation/items_list_screen.dart';
import '../../modules/items/presentation/item_create_screen.dart';

final appRouter = GoRouter(
  initialLocation: "/items",
  routes: [
    GoRoute(path: "/items", builder: (context, _) => const ItemListScreen()),
    GoRoute(
      path: "/items/create",
      builder: (context, _) => const ItemCreateScreen(),
    ),
  ],
);
