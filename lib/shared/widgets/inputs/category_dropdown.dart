// FILE: lib/shared/widgets/inputs/category_dropdown.dart
import 'package:flutter/material.dart';

import 'dropdown_input.dart';

/// Parent + children data used by the category dropdown.
class CategoryGroup {
  final String parent;
  final List<String> children;

  const CategoryGroup({
    required this.parent,
    required this.children,
  });
}

/// Dropdown that shows a two-level category tree (non-selectable parents).
class CategoryDropdown extends StatelessWidget {
  final List<CategoryGroup> groups;
  final String? value;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onManageCategoriesTap;

  const CategoryDropdown({
    super.key,
    required this.groups,
    required this.value,
    required this.onChanged,
    this.onManageCategoriesTap,
  });

  List<_CategoryOption> _buildOptions() {
    final List<_CategoryOption> options = [];

    for (final group in groups) {
      options.add(
        _CategoryOption(
          label: group.parent,
          isGroupHeader: true,
        ),
      );

      for (final child in group.children) {
        options.add(
          _CategoryOption(
            label: child,
            value: child,
            parent: group.parent,
          ),
        );
      }
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    final options = _buildOptions();

    _CategoryOption? selected;
    for (final opt in options) {
      if (opt.value != null && opt.value == value) {
        selected = opt;
        break;
      }
    }

    return FormDropdown<_CategoryOption>(
      value: selected,
      items: options,
      hint: 'Select Category',
      onChanged: (opt) => onChanged(opt?.value),
      showSettings: onManageCategoriesTap != null,
      settingsLabel: 'Manage Categories...',
      onSettingsTap: onManageCategoriesTap,
      allowClear: true,
      itemBuilder: (opt, isSelected, isHovered) => _CategoryDropdownRow(
        option: opt,
        isSelected: isSelected,
      ),
      isItemEnabled: (opt) => !opt.isGroupHeader,
    );
  }
}

class _CategoryOption {
  final String label;
  final String? value;
  final String? parent;
  final bool isGroupHeader;

  const _CategoryOption({
    required this.label,
    this.value,
    this.parent,
    this.isGroupHeader = false,
  });

  @override
  String toString() {
    if (isGroupHeader) return label;
    if (parent != null && parent!.isNotEmpty) {
      return '$parent > $label';
    }
    return label;
  }
}

class _CategoryDropdownRow extends StatelessWidget {
  final _CategoryOption option;
  final bool isSelected;

  const _CategoryDropdownRow({
    required this.option,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (option.isGroupHeader) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        color: const Color(0xFFF3F4F6),
        alignment: Alignment.centerLeft,
        child: Text(
          option.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
      );
    }

    final Color textColor =
        isSelected ? Colors.white : const Color(0xFF111827);
    final Color subTextColor =
        isSelected ? Colors.white70 : const Color(0xFF6B7280);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              option.label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
          if (option.parent != null) ...[
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                option.parent!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: subTextColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
