import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:zerpai_erp/core/router/app_router.dart';
import 'package:zerpai_erp/core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: ZerpaiApp()));
}

class ZerpaiApp extends StatelessWidget {
  const ZerpaiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
    );
  }
}
