// FILE: lib/shared/widgets/shared_field_layout.dart

import 'package:flutter/material.dart';
import 'package:zerpai_erp/shared/theme/app_text_styles.dart';

/// Shared layout wrapper for every field in forms.
/// Handles:
///  • Proper label alignment
///  • Required (*) indicator
///  • Helper text
///  • Left label column (160px)
///  • Right input field area
class SharedFieldLayout extends StatelessWidget {
  final String label;
  final bool required;
  final String? helper;
  final Widget child;

  const SharedFieldLayout({
    super.key,
    required this.label,
    this.required = false,
    this.helper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- LEFT LABEL ----------------
            SizedBox(
              width: 160,
              child: Text(
                required ? "$label *" : label,
                style: required
                    ? AppTextStyles.labelRequired
                    : AppTextStyles.label,
              ),
            ),

            const SizedBox(width: 12),

            // ---------------- RIGHT FIELD ----------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child,

                  if (helper != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(helper!, style: AppTextStyles.helper),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
