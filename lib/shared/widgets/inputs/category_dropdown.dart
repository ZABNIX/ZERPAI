// FILE: lib/shared/widgets/inputs/category_dropdown.dart

import 'package:flutter/material.dart';

/// Parent–child model for categories used in the dropdown.
class CategoryGroup {
  final String parent;
  final List<String> children;

  const CategoryGroup({required this.parent, required this.children});
}

/// Simple grouped category dropdown:
/// - shows current value in a field
/// - opens a dialog with parent–child list + search
/// - calls onChanged when a child is selected
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

  bool get _hasValue => value != null && value!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: InkWell(
        onTap: () => _openDialog(context),
        borderRadius: BorderRadius.circular(4),
        child: InputDecorator(
          isFocused: false,
          isEmpty: !_hasValue,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF2563EB)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _hasValue ? value! : 'Select Category',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: _hasValue
                        ? const Color(0xFF111827)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
              if (_hasValue)
                GestureDetector(
                  onTap: () => onChanged(null),
                  behavior: HitTestBehavior.translucent,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Color(0xFF6B7280),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _CategorySelectDialog(
        groups: groups,
        initialValue: value,
        onManageCategoriesTap: onManageCategoriesTap,
      ),
    );

    if (result != null) {
      onChanged(result);
    }
  }
}

class _CategorySelectDialog extends StatefulWidget {
  final List<CategoryGroup> groups;
  final String? initialValue;
  final VoidCallback? onManageCategoriesTap;

  const _CategorySelectDialog({
    required this.groups,
    required this.initialValue,
    required this.onManageCategoriesTap,
  });

  @override
  State<_CategorySelectDialog> createState() => _CategorySelectDialogState();
}

class _CategorySelectDialogState extends State<_CategorySelectDialog> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.toLowerCase().trim();

    final filteredGroups = widget.groups
        .map((g) {
          if (query.isEmpty) return g;
          final children = g.children
              .where(
                (c) =>
                    c.toLowerCase().contains(query) ||
                    g.parent.toLowerCase().contains(query),
              )
              .toList();
          return CategoryGroup(parent: g.parent, children: children);
        })
        .where((g) => g.children.isNotEmpty)
        .toList();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 520),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
              child: Row(
                children: [
                  const Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    splashRadius: 18,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: SizedBox(
                height: 36,
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),

            // List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                itemCount: filteredGroups.length,
                itemBuilder: (ctx, index) {
                  final group = filteredGroups[index];
                  return _buildGroup(group);
                },
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE5E7EB)),

            // Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (widget.onManageCategoriesTap != null) {
                        widget.onManageCategoriesTap!();
                      }
                    },
                    icon: const Icon(
                      Icons.settings_outlined,
                      size: 18,
                      color: Color(0xFF2563EB),
                    ),
                    label: const Text(
                      'Manage Categories',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroup(CategoryGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parent
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            group.parent,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
        ),
        // Children
        ...group.children.map(
          (c) => InkWell(
            onTap: () => Navigator.of(context).pop(c),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
              child: Row(
                children: [
                  const Text('• ', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: Text(
                      c,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
