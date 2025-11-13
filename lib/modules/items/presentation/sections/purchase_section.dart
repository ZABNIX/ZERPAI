// FILE: lib/modules/items/presentation/sections/purchase_section.dart

import 'package:flutter/material.dart';

class PurchaseSection extends StatelessWidget {
  const PurchaseSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: SizedBox(
        height: 150,
        child: Center(
          child: Text(
            "Purchase Information\n(Purchase rate, supplier, MOQ etc.)",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
