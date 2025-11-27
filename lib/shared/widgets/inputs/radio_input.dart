import 'package:flutter/material.dart';
import '../../theme/text_styles.dart';

class FormRadio extends StatelessWidget {
  final String label;
  final bool value;
  final bool groupValue;
  final ValueChanged<bool?> onChanged;

  const FormRadio({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<bool>(value: value, groupValue: groupValue, onChanged: onChanged),
        Text(label, style: AppTextStyles.input),
      ],
    );
  }
}
