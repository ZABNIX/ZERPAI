import 'package:flutter/material.dart';
import 'modules/items/presentation/item_create_screen.dart';

class ZerpaiApp extends StatelessWidget {
  const ZerpaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Zerpai ERP",

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        fontFamily: "Inter",
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
        useMaterial3: false,
      ),

      home: const ItemCreateScreen(),
    );
  }
}
