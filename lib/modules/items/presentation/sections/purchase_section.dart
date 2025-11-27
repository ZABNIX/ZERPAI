// FILE: lib/modules/items/presentation/sections/purchase_section.dart

import 'package:flutter/material.dart';

class PurchaseSection extends StatelessWidget {
  final TextEditingController costPriceCtrl;
  final TextEditingController descriptionCtrl;

  final String currency;
  final ValueChanged<String?> onCurrencyChange;

  final String? accountValue;
  final ValueChanged<String?> onAccountChanged;

  final String? preferredVendor;
  final ValueChanged<String?> onVendorChanged;

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

  final Widget Function<T>({
    required T? value,
    required List<T> items,
    String? hint,
    required ValueChanged<T?> onChanged,
  })
  zohoDropdown;

  const PurchaseSection({
    super.key,
    required this.costPriceCtrl,
    required this.currency,
    required this.onCurrencyChange,
    required this.accountValue,
    required this.onAccountChanged,
    required this.preferredVendor,
    required this.onVendorChanged,
    required this.descriptionCtrl,
    required this.zohoField,
    required this.zohoTextField,
    required this.zohoDropdown,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Purchase Information",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // Cost Price
            // inside PurchaseSection.build(...)
            zohoField(
              label: 'Cost Price',
              required: true,
              child: Row(
                children: [
                  // currency dropdown – same as before
                  SizedBox(
                    width: 80,
                    child: zohoDropdown<String>(
                      value: currency,
                      items: const ['INR', 'USD', 'EUR'], // or whatever you use
                      onChanged: onCurrencyChange,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 👇 Cost price text field – forced to 44px height
                  Expanded(
                    child: zohoTextField(
                      controller: costPriceCtrl,
                      hint: 'Enter cost price',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      maxLines: 1,
                      height: 44, // 🔥 same as dropdown
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Account
            zohoField(
              label: "Account",
              required: true,
              child: zohoDropdown<String>(
                value: accountValue,
                items: const ["Cost Of Goods Sold", "Purchase"],
                hint: "Select account",
                onChanged: onAccountChanged,
              ),
            ),

            const SizedBox(height: 16),

            // Preferred Vendor
            zohoField(
              label: "Preferred Vendor",
              child: zohoDropdown<String>(
                value: preferredVendor,
                items: const ["Vendor A", "Vendor B", "Vendor C"],
                hint: "Select vendor",
                onChanged: onVendorChanged,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            zohoField(
              label: "Description",
              child: zohoTextField(
                controller: descriptionCtrl,
                hint: "Enter description",
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                height: 96,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
