// PATH: lib/core/router/app_router.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../modules/items/presentation/items_list_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/items',
    routes: [
      GoRoute(
        path: '/items',
        name: 'items-list',
        builder: (context, state) => const ItemsListScreen(),
      ),
    ],
  );
});
