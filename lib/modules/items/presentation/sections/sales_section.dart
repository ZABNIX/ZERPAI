// FILE: lib/modules/items/presentation/sections/sales_section.dart

import 'package:flutter/material.dart';

class SalesSection extends StatelessWidget {
  const SalesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: SizedBox(
        height: 150,
        child: Center(
          child: Text(
            "Sales Information\n(MRP, sale rate, GST, discounts etc.)",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
