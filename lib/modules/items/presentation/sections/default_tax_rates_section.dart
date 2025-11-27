// FILE: lib/modules/items/presentation/sections/default_tax_rates_section.dart

import 'package:flutter/material.dart';
import 'package:zerpai_erp/shared/widgets/inputs/dropdown_input.dart';

class DefaultTaxRatesSection extends StatefulWidget {
  final String? intraStateRate;
  final String? interStateRate;

  /// Parent gets called whenever either value changes
  final void Function(String? intra, String? inter) onChanged;

  const DefaultTaxRatesSection({
    super.key,
    required this.intraStateRate,
    required this.interStateRate,
    required this.onChanged,
  });

  @override
  State<DefaultTaxRatesSection> createState() => _DefaultTaxRatesSectionState();
}

class _DefaultTaxRatesSectionState extends State<DefaultTaxRatesSection> {
  bool _isEditing = false;

  String? _intraRate;
  String? _interRate;

  static const _taxOptions = <String>[
    'GST0 [0%]',
    'GST5 [5%]',
    'GST12 [12%]',
    'GST18 [18%]',
    'GST28 [28%]',
    'IGST0 [0%]',
    'IGST5 [5%]',
    'IGST12 [12%]',
    'IGST18 [18%]',
    'IGST28 [28%]',
  ];

  @override
  void initState() {
    super.initState();
    _intraRate = widget.intraStateRate;
    _interRate = widget.interStateRate;
  }

  @override
  void didUpdateWidget(covariant DefaultTaxRatesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.intraStateRate != widget.intraStateRate ||
        oldWidget.interStateRate != widget.interStateRate) {
      _intraRate = widget.intraStateRate;
      _interRate = widget.interStateRate;
    }
  }

  void _notifyParent() {
    widget.onChanged(_intraRate, _interRate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Header row (title + edit icon) ----------
            // ---------- Header row (title + edit icon) ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Default Tax Rates',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 6),
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    padding: EdgeInsets.zero,
                    splashRadius: 16,
                    onPressed: () {
                      setState(() => _isEditing = true);
                    },
                  ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            const SizedBox(height: 12),

            // ---------- Intra-state row ----------
            _buildRow(
              label: 'Intra-state Tax',
              value: _intraRate,
              isEditing: _isEditing,
              onChanged: (v) {
                setState(() => _intraRate = v);
                _notifyParent();
              },
            ),

            const SizedBox(height: 12),

            // ---------- Inter-state row ----------
            _buildRow(
              label: 'Inter-state Tax',
              value: _interRate,
              isEditing: _isEditing,
              onChanged: (v) {
                setState(() => _interRate = v);
                _notifyParent();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required String label,
    required String? value,
    required bool isEditing,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left label
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
          ),
        ),
        const SizedBox(width: 24),

        // Right side -> either text or dropdown
        if (!isEditing)
          Text(
            value ?? '-',
            style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
          )
        else
          SizedBox(
            width: 260, // compact width like your latest screenshot
            child: FormDropdown<String>(
              value: value,
              items: _taxOptions,
              hint: 'Select tax rate',
              onChanged: onChanged,
              allowClear: false,
            ),
          ),
      ],
    );
  }
}
