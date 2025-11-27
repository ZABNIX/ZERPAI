// FILE: lib/shared/widgets/inputs/custom_text_field.dart
import 'package:flutter/material.dart';

/// Zoho-style text field:
/// - Default height = 44 (matches FormDropdown)
/// - Same border radius / color as dropdown
/// - Blue border when focused
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  /// If null => 44px (same as dropdown)
  final double? height;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.onChanged,
    this.height,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;

  static const double _defaultHeight = 44.0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double fieldHeight = widget.height ?? _defaultHeight;
    final bool isMultiline = widget.maxLines > 1 || fieldHeight > 60;

    final borderColor = _focusNode.hasFocus
        ? const Color(0xFF2563EB) // blue when focused
        : const Color(0xFFD1D5DB); // grey default

    return SizedBox(
      height: fieldHeight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: isMultiline ? Alignment.topLeft : Alignment.centerLeft,
        child: TextField(
          focusNode: _focusNode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: isMultiline ? widget.maxLines : 1,
          readOnly: widget.readOnly,
          onChanged: widget.onChanged,
          style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none, // border handled by container
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
            // no extra padding, container height controls size
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
