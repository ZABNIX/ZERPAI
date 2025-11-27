// FILE: lib/modules/items/presentation/sections/formulation_extra_details.dart
import 'package:flutter/material.dart';
import 'package:zerpai_erp/shared/widgets/inputs/dropdown_input.dart';

class FormulationExtraDetails extends StatelessWidget {
  final TextEditingController dimXCtrl;
  final TextEditingController dimYCtrl;
  final TextEditingController dimZCtrl;

  final String dimUnit;
  final ValueChanged<String?> onDimUnitChange;

  final TextEditingController weightCtrl;
  final String weightUnit;
  final ValueChanged<String?> onWeightUnitChange;

  final String? manufacturer;
  final ValueChanged<String?> onManufacturerChange;

  final String? brand;
  final ValueChanged<String?> onBrandChange;

  final TextEditingController upcCtrl;
  final TextEditingController mpnCtrl;
  final TextEditingController eanCtrl;
  final TextEditingController isbnCtrl;

  final Widget Function({
    required String label,
    bool required,
    String? helper,
    required Widget child,
  })
  zohoField;

  final Widget Function({
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType,
  })
  zohoTextField;

  /// Generic dropdown factory (used for simple dropdowns)
  final Widget Function<T>({
    required T? value,
    required List<T> items,
    String? hint,
    required ValueChanged<T?> onChanged,
  })
  zohoDropdown;

  const FormulationExtraDetails({
    super.key,
    required this.dimXCtrl,
    required this.dimYCtrl,
    required this.dimZCtrl,
    required this.dimUnit,
    required this.onDimUnitChange,
    required this.weightCtrl,
    required this.weightUnit,
    required this.onWeightUnitChange,
    required this.manufacturer,
    required this.onManufacturerChange,
    required this.brand,
    required this.onBrandChange,
    required this.upcCtrl,
    required this.mpnCtrl,
    required this.eanCtrl,
    required this.isbnCtrl,
    required this.zohoField,
    required this.zohoTextField,
    required this.zohoDropdown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- Dimensions + Weight ----------------
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: zohoField(
                      label: 'Dimensions',
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _colBox(138, dimXCtrl, 'Length'),
                          const SizedBox(width: 12),
                          _colBox(135, dimYCtrl, 'Width'),
                          const SizedBox(width: 12),
                          _colBox(135, dimZCtrl, 'Height'),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 70,
                            child: zohoDropdown<String>(
                              value: dimUnit,
                              items: const ['cm', 'mm', 'in'],
                              onChanged: onDimUnitChange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 24),

                  Expanded(
                    flex: 1,
                    child: zohoField(
                      label: 'Weight',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 138,
                                child: zohoTextField(controller: weightCtrl),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 70,
                                child: zohoDropdown<String>(
                                  value: weightUnit,
                                  items: const ['kg', 'g', 'lb'],
                                  onChanged: onWeightUnitChange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Weight',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------------- Manufacturer / Brand ----------------
              Row(
                children: [
                  Expanded(
                    child: zohoField(
                      label: 'Manufacturer',
                      child: FormDropdown<String>(
                        value: manufacturer,
                        items: const ['Cipla', 'Sun Pharma', "Dr. Reddy's"],
                        hint: 'Select or Add Manufacturer',
                        onChanged: onManufacturerChange,
                        showSettings: true,
                        settingsLabel: 'Manage Manufacturers...',
                        allowClear: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: zohoField(
                      label: 'Brand',
                      child: FormDropdown<String>(
                        value: brand,
                        items: const ['Brand A', 'Brand B'],
                        hint: 'Select or Add Brand',
                        onChanged: onBrandChange,
                        showSettings: true,
                        settingsLabel: 'Manage Brands...',
                        allowClear: true,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------------- UPC / MPN ----------------
              Row(
                children: [
                  Expanded(
                    child: zohoField(
                      label: 'UPC',
                      child: zohoTextField(controller: upcCtrl),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: zohoField(
                      label: 'MPN',
                      child: zohoTextField(controller: mpnCtrl),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ---------------- EAN / ISBN ----------------
              Row(
                children: [
                  Expanded(
                    child: zohoField(
                      label: 'EAN',
                      child: zohoTextField(controller: eanCtrl),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: zohoField(
                      label: 'ISBN',
                      child: zohoTextField(controller: isbnCtrl),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _colBox(double width, TextEditingController c, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: zohoTextField(controller: c),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
      ],
    );
  }
}
