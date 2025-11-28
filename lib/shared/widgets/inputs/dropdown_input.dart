// FILE: lib/shared/widgets/inputs/dropdown_input.dart
import 'package:flutter/material.dart';

/// Zoho-style dropdown with:
/// - Custom popup
/// - Search bar
/// - Optional bottom settings row
/// - Optional clear (X) icon inside the field
/// - Optional custom row builder + non-selectable items
class FormDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String? hint;
  final ValueChanged<T?> onChanged;

  /// Show "settings" row at bottom of dropdown (e.g. "Manage Units...")
  final bool showSettings;
  final String settingsLabel;
  final VoidCallback? onSettingsTap;

  /// Show red X inside the field when there is a value
  /// (use this for NON-mandatory fields only).
  final bool allowClear;

  /// Optional custom row builder for items (used by Category tree).
  /// If null, a simple Text(item.toString()) is used.
  final Widget Function(T item, bool isSelected, bool isHovered)? itemBuilder;

  /// Optional per-item enable/disable. Disabled items:
  /// - are not clickable
  /// - do not get hover / selected background
  final bool Function(T item)? isItemEnabled;

  const FormDropdown({
    super.key,
    required this.value,
    required this.items,
    this.hint,
    required this.onChanged,
    this.showSettings = false,
    this.settingsLabel = 'Configure...',
    this.onSettingsTap,
    this.allowClear = false,
    this.itemBuilder,
    this.isItemEnabled,
  });

  @override
  State<FormDropdown<T>> createState() => _FormDropdownState<T>();
}

class _FormDropdownState<T> extends State<FormDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  late List<T> _filteredItems;

  // Hover tracking
  int? _hoveredIndex;

  static const double _fieldHeight = 44.0;

  @override
  void initState() {
    super.initState();
    _filteredItems = List<T>.from(widget.items);
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant FormDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _filteredItems = List<T>.from(widget.items);
      _filterItems(_searchCtrl.text);
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterItems(_searchCtrl.text);
  }

  void _filterItems(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filteredItems = List<T>.from(widget.items);
      } else {
        _filteredItems = widget.items
            .where((e) => e.toString().toLowerCase().contains(q))
            .toList();
      }
    });
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    _overlayEntry = OverlayEntry(builder: (context) => _buildDropdownOverlay());
    overlay.insert(_overlayEntry!);
    setState(() => _isOpen = true);

    Future.delayed(const Duration(milliseconds: 30), () {
      if (mounted) {
        _searchFocus.requestFocus();
      }
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_isOpen) {
      setState(() => _isOpen = false);
    }
    _hoveredIndex = null;
  }

  void _handleItemTap(T value) {
    widget.onChanged(value);
    _removeOverlay();
  }

  void _handleClear() {
    if (!widget.allowClear) return;
    widget.onChanged(null);
    _searchCtrl.clear();
    _filterItems('');
  }

  Widget _buildDropdownOverlay() {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Size size = box.size;

    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeOverlay,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 4),
              child: Material(
                elevation: 4,
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 320,
                    minWidth: 220,
                  ),
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFFD1D5DB),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Search bar
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                          child: TextField(
                            controller: _searchCtrl,
                            focusNode: _searchFocus,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Search',
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 18,
                                color: Color(0xFF9CA3AF),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),

                        const Divider(height: 1, color: Color(0xFFE5E7EB)),

                        // Items list
                        Builder(
                          builder: (context) {
                            const double itemHeight = 36.0;
                            const double minListHeight = 80.0;
                            const double maxListHeight = 220.0;

                            final int itemCount = _filteredItems.length;
                            double listHeight = itemCount * itemHeight;

                            if (listHeight < minListHeight) {
                              listHeight = minListHeight;
                            }
                            if (listHeight > maxListHeight) {
                              listHeight = maxListHeight;
                            }

                            return SizedBox(
                              height: listHeight,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: _filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = _filteredItems[index];
                                  final bool isSelected = item == widget.value;
                                  final bool isHovered = _hoveredIndex == index;
                                  final bool enabled =
                                      widget.isItemEnabled?.call(item) ?? true;

                                  Color bgColor;
                                  Color textColor;

                                  if (isSelected && enabled) {
                                    bgColor = const Color(0xFF1B8EF1);
                                    textColor = Colors.white;
                                  } else if (isHovered && enabled) {
                                    bgColor = const Color(0xFFE5F1FF);
                                    textColor = const Color(0xFF111827);
                                  } else {
                                    bgColor = Colors.transparent;
                                    textColor = const Color(0xFF374151);
                                  }

                                  final Widget defaultChild = Text(
                                    item.toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textColor,
                                    ),
                                  );

                                  final Widget content =
                                      widget.itemBuilder != null
                                      ? widget.itemBuilder!(
                                          item,
                                          isSelected,
                                          isHovered,
                                        )
                                      : defaultChild;

                                  return MouseRegion(
                                    onEnter: (_) {
                                      if (!enabled) return;
                                      setState(() => _hoveredIndex = index);
                                    },
                                    onExit: (_) {
                                      if (!enabled) return;
                                      setState(() => _hoveredIndex = null);
                                    },
                                    cursor: enabled
                                        ? SystemMouseCursors.click
                                        : SystemMouseCursors.basic,
                                    child: Material(
                                      color: bgColor,
                                      child: InkWell(
                                        onTap: enabled
                                            ? () => _handleItemTap(item)
                                            : null,
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Container(
                                          height: itemHeight,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: content,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),

                        // Settings row (optional)
                        if (widget.showSettings)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(
                                height: 1,
                                color: Color(0xFFE5E7EB),
                              ),
                              InkWell(
                                onTap: () {
                                  _removeOverlay();
                                  widget.onSettingsTap?.call();
                                },
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.settings_outlined,
                                        size: 16,
                                        color: Color(0xFF2563EB),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        widget.settingsLabel,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF2563EB),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = widget.value != null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        height: _fieldHeight,
        child: GestureDetector(
          onTap: _toggleDropdown,
          behavior: HitTestBehavior.translucent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _isOpen
                    ? const Color(0xFF2563EB)
                    : const Color(0xFFD1D5DB),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                // Text
                Expanded(
                  child: Text(
                    hasValue ? widget.value.toString() : (widget.hint ?? ''),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: hasValue
                          ? const Color(0xFF111827)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),

                // Clear icon (only when allowed + has value)
                if (widget.allowClear && hasValue) ...[
                  GestureDetector(
                    onTap: _handleClear,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 18,
                    color: const Color(0xFFE5E7EB),
                  ),
                ],

                // Arrow icon
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
