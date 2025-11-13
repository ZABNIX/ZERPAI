// FILE: lib/modules/items/presentation/sections/formulation_section.dart

import 'package:flutter/material.dart';

class FormulationSection extends StatelessWidget {
  const FormulationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: SizedBox(
        height: 150,
        child: Center(
          child: Text(
            "Formulate Information\n(Your custom fields can be added here)",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
