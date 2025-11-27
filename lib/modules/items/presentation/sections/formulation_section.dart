// FILE: lib/modules/items/presentation/sections/formulation_section.dart
import 'package:flutter/material.dart';

class FormulationSection extends StatelessWidget {
  const FormulationSection({
    super.key,
    // inputs
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
    required this.eanCtrl,
    required this.mpnCtrl,
    required this.isbnCtrl,
    // injected zoho-style helpers
    required this.zohoField,
    required this.zohoTextField,
    required this.zohoDropdown,
  });

  // ---------------- FORM FIELDS ----------------
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
  final TextEditingController eanCtrl;
  final TextEditingController mpnCtrl;
  final TextEditingController isbnCtrl;

  // ---------------- INJECTED WIDGET BUILDERS ----------------
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
    int maxLines,
    double height,
  })
  zohoTextField;

  /// NOTE: extended to support settings + clear.
  final Widget Function<T>({
    required T? value,
    required List<T> items,
    String? hint,
    required ValueChanged<T?> onChanged,
    bool? showSettings,
    String? settingsLabel,
    VoidCallback? onSettingsTap,
    bool? allowClear,
  })
  zohoDropdown;

  // ---------------- DIALOG HELPERS ----------------
  void _openManufacturerSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Manage Manufacturers'),
        content: const Text(
          'Later this can open your Manufacturers master screen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openBrandSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Manage Brands'),
        content: const Text('Later this can open your Brands master screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Formulation Information",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 20),

            // ------------------- DIMENSIONS + WEIGHT -------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: zohoField(
                    label: "Dimensions\n(length x width x height)",
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: zohoTextField(
                            controller: dimXCtrl,
                            hint: "",
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            height: 44,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 60,
                          child: zohoTextField(
                            controller: dimYCtrl,
                            hint: "",
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            height: 44,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 60,
                          child: zohoTextField(
                            controller: dimZCtrl,
                            hint: "",
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            height: 44,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 80,
                          child: zohoDropdown<String>(
                            value: dimUnit,
                            items: const ["cm", "mm", "m"],
                            onChanged: onDimUnitChange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: zohoField(
                    label: "Weight",
                    child: Row(
                      children: [
                        Expanded(
                          child: zohoTextField(
                            controller: weightCtrl,
                            hint: "Enter...",
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            height: 44,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 80,
                          child: zohoDropdown<String>(
                            value: weightUnit,
                            items: const ["kg", "g", "mg"],
                            onChanged: onWeightUnitChange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ------------------- MANUFACTURER + BRAND -------------------
            Row(
              children: [
                Expanded(
                  child: zohoField(
                    label: "Manufacturer",
                    child: zohoDropdown<String>(
                      value: manufacturer,
                      hint: "Select or Add Manufacturer",
                      items: const ["Cipla", "Sun Pharma", "Dr. Reddys"],
                      onChanged: onManufacturerChange,
                      allowClear: true, // ✅ X icon
                      showSettings: true, // ✅ gear row
                      settingsLabel: "Manage Manufacturers...",
                      onSettingsTap: () => _openManufacturerSettings(context),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: zohoField(
                    label: "Brand",
                    required: true,
                    child: zohoDropdown<String>(
                      value: brand,
                      hint: "Select or Add Brand",
                      items: const ["Brand A", "Brand B"],
                      onChanged: onBrandChange,
                      showSettings: true, // ✅ gear row
                      settingsLabel: "Manage Brands...",
                      onSettingsTap: () => _openBrandSettings(context),
                      // no allowClear here (required field)
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ------------------- MPN + UPC -------------------
            Row(
              children: [
                Expanded(
                  child: zohoField(
                    label: "MPN",
                    child: zohoTextField(
                      controller: mpnCtrl,
                      hint: "Enter MPN",
                      height: 44,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: zohoField(
                    label: "UPC",
                    child: zohoTextField(
                      controller: upcCtrl,
                      hint: "Enter UPC",
                      height: 44,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ------------------- ISBN + EAN -------------------
            Row(
              children: [
                Expanded(
                  child: zohoField(
                    label: "ISBN",
                    child: zohoTextField(
                      controller: isbnCtrl,
                      hint: "Enter ISBN",
                      height: 44,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: zohoField(
                    label: "EAN",
                    child: zohoTextField(
                      controller: eanCtrl,
                      hint: "Enter EAN",
                      height: 44,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
