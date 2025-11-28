// FILE: lib/modules/items/presentation/sections/composition_section.dart

import 'package:flutter/material.dart';

import '../../models/item_composition_model.dart';
import 'package:zerpai_erp/shared/widgets/inputs/dropdown_input.dart';

class CompositionSection extends StatefulWidget {
  final Function(List<ItemComposition>) onChanged;

  const CompositionSection({super.key, required this.onChanged});

  @override
  State<CompositionSection> createState() => _CompositionSectionState();
}

class _CompositionSectionState extends State<CompositionSection> {
  // Row models
  final List<ItemComposition> _rows = [ItemComposition()];

  // Controllers for Strength column so we can match height and keep values
  final List<TextEditingController> _strengthCtrls = [TextEditingController()];

  int? _hoveredIndex;

  // New: track active-ingredients toggle
  bool _trackActiveIngredients = true;

  // New: extra dropdown values
  String? _selectedBuyingRule;
  String? _selectedScheduleOfDrug;

  // ---------- LIFECYCLE ----------

  @override
  void dispose() {
    for (final c in _strengthCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  // ---------- HELPERS ----------

  void _syncAndNotify() {
    widget.onChanged(List<ItemComposition>.from(_rows));
  }

  bool get _hasAnyScheduleSelected {
    return _rows.any((r) => (r.schedule ?? '').trim().isNotEmpty);
  }

  /// Must be called *inside* setState blocks so it doesn’t trigger another setState.
  void _updateScheduleVisibilityInsideSetState() {
    if (!_hasAnyScheduleSelected && _selectedScheduleOfDrug != null) {
      _selectedScheduleOfDrug = null;
    }
  }

  void _updateRow(int index, ItemComposition updated) {
    setState(() {
      _rows[index] = updated;
      _syncAndNotify();
      _updateScheduleVisibilityInsideSetState();
    });
  }

  void _addRow() {
    setState(() {
      _rows.add(ItemComposition());
      _strengthCtrls.add(TextEditingController());
      _syncAndNotify();
      _updateScheduleVisibilityInsideSetState();
    });
  }

  void _removeRow(int index) {
    if (index == 0) return; // first row non-removable
    setState(() {
      _rows.removeAt(index);
      _strengthCtrls.removeAt(index);
      _syncAndNotify();
      _updateScheduleVisibilityInsideSetState();
    });
  }

  // Helper to update/clear individual fields without touching the model file.
  ItemComposition _rowWith({
    required ItemComposition row,
    String? content,
    bool clearContent = false,
    String? strength,
    bool clearStrength = false,
    String? unit,
    bool clearUnit = false,
    String? schedule,
    bool clearSchedule = false,
  }) {
    return ItemComposition(
      content: clearContent ? null : (content ?? row.content),
      strength: clearStrength ? null : (strength ?? row.strength),
      unit: clearUnit ? null : (unit ?? row.unit),
      schedule: clearSchedule ? null : (schedule ?? row.schedule),
    );
  }

  // ---------- EXTRA ROWS (below table) ----------

  // Schedule Of Drugs row – narrower text field
  Widget _buildScheduleOfDrugsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 140,
          child: Text(
            'Schedule Of Drugs',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // ⬇ fixed-style width like other fields
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420, // tune this if you want a bit wider/narrower
            ),
            child: FormDropdown<String>(
              value: _selectedScheduleOfDrug,
              items: const ['Schedule H', 'Schedule H1', 'Schedule X'],
              hint: 'Select schedule of drug',
              onChanged: (v) {
                setState(() => _selectedScheduleOfDrug = v);
              },
              allowClear: true,
              showSettings: true,
              settingsLabel: 'Manage Schedule of Drug',
            ),
          ),
        ),
      ],
    );
  }

  // Buying Rules row – same width as above
  Widget _buildBuyingRulesRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 140,
          child: Text(
            'Buying Rules',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(width: 16),

        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: FormDropdown<String>(
              value: _selectedBuyingRule,
              items: const [
                'Standard Purchase',
                'Doctor Prescription Only',
                'High Value Approval',
              ],
              hint: 'Select buying rule',
              onChanged: (v) {
                setState(() => _selectedBuyingRule = v);
              },
              allowClear: true,
              showSettings: true,
              settingsLabel: 'Manage Buying Rules...',
            ),
          ),
        ),
      ],
    );
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TRACK ACTIVE INGREDIENTS – checkbox
        Row(
          children: [
            Checkbox(
              value: _trackActiveIngredients,
              onChanged: (v) {
                setState(() {
                  _trackActiveIngredients = v ?? false;
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            ),
            const SizedBox(width: 4),
            const Text(
              'Track Active Ingredients',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // When tracking is ON → show the composition card (existing design)
        if (_trackActiveIngredients)
          Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          "Contents",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Strength",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Unit",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Schedule of content",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      SizedBox(width: 32), // space for remove icon
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Data rows
                  Column(
                    children: List.generate(_rows.length, (i) {
                      final row = _rows[i];
                      final strengthCtrl = _strengthCtrls[i];

                      // Keep controller text in sync with model
                      if (strengthCtrl.text != (row.strength ?? '')) {
                        strengthCtrl.text = row.strength ?? '';
                        strengthCtrl.selection = TextSelection.collapsed(
                          offset: strengthCtrl.text.length,
                        );
                      }

                      return MouseRegion(
                        onEnter: (_) => setState(() => _hoveredIndex = i),
                        onExit: (_) => setState(() => _hoveredIndex = null),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Contents
                              Expanded(
                                child: FormDropdown<String>(
                                  value: row.content,
                                  items: const [
                                    'Paracetamol',
                                    'Ibuprofen',
                                    'Amoxicillin',
                                  ],
                                  hint: 'Select content',
                                  onChanged: (v) => _updateRow(
                                    i,
                                    _rowWith(
                                      row: row,
                                      content: v,
                                      clearContent: v == null,
                                    ),
                                  ),

                                  allowClear: true,
                                  showSettings: true,
                                  settingsLabel: 'Manage Content',
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Strength (text field) – height matched to dropdown
                              Expanded(
                                child: FormDropdown<String>(
                                  value: row.strength,
                                  items: const ['50', '100', '5000'],
                                  hint: 'Select strength',
                                  onChanged: (v) => _updateRow(
                                    i,
                                    _rowWith(
                                      row: row,
                                      strength: v,
                                      clearStrength: v == null,
                                    ),
                                  ),

                                  allowClear: true,
                                  showSettings: true,
                                  settingsLabel: 'Manage Strength',
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Unit
                              Expanded(
                                child: FormDropdown<String>(
                                  value: row.unit,
                                  items: const ['mg', 'ml', 'mcg'],
                                  hint: 'Select unit',
                                  onChanged: (v) => _updateRow(
                                    i,
                                    _rowWith(
                                      row: row,
                                      unit: v,
                                      clearUnit: v == null,
                                    ),
                                  ),

                                  allowClear: true,
                                  showSettings: true,
                                  settingsLabel: 'Manage Unit',
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Schedule of content
                              Expanded(
                                child: FormDropdown<String>(
                                  value: row.schedule,
                                  items: const ['H', 'H1', 'Narcotic'],
                                  hint: 'Select schedule',
                                  onChanged: (v) => _updateRow(
                                    i,
                                    _rowWith(
                                      row: row,
                                      schedule: v,
                                      clearSchedule: v == null,
                                    ),
                                  ),

                                  allowClear: true,
                                  showSettings: true,
                                  settingsLabel: 'Manage Schedule of Content',
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Remove icon – only for rows after first, and only on hover
                              if (i > 0)
                                AnimatedOpacity(
                                  opacity: _hoveredIndex == i ? 1 : 0,
                                  duration: const Duration(milliseconds: 150),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Color(0xFFEF4444),
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 24,
                                      minHeight: 24,
                                    ),
                                    splashRadius: 16,
                                    onPressed: () => _removeRow(i),
                                  ),
                                )
                              else
                                const SizedBox(width: 24),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 8),

                  // Add new
                  Center(
                    child: TextButton.icon(
                      onPressed: _addRow,
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Color(0xFF2563EB),
                      ),
                      label: const Text(
                        "Add New",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // When tracking is ON and any schedule is chosen → Schedule Of Drugs
        if (_trackActiveIngredients && _hasAnyScheduleSelected) ...[
          const SizedBox(height: 16),
          _buildScheduleOfDrugsRow(),
        ],

        const SizedBox(height: 16),

        // Buying Rules should appear always (checked or unchecked)
        _buildBuyingRulesRow(),
      ],
    );
  }
}
