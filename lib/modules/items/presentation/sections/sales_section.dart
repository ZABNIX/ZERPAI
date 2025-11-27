// FILE: lib/modules/items/presentation/sections/sales_section.dart

import 'package:flutter/material.dart';

typedef ZohoFieldBuilder =
    Widget Function({
      required String label,
      bool required,
      String? helper,
      required Widget child,
    });

typedef ZohoTextFieldBuilder =
    Widget Function({
      required TextEditingController controller,
      String? hint,
      TextInputType keyboardType,
    });

typedef ZohoDropdownBuilder =
    Widget Function<T>({
      required T? value,
      required List<T> items,
      String? hint,
      required ValueChanged<T?> onChanged,
    });

class SalesSection extends StatelessWidget {
  final TextEditingController sellingPriceCtrl;
  final TextEditingController mrpCtrl;
  final TextEditingController ptrCtrl;
  final TextEditingController descriptionCtrl;

  final String currency;
  final ValueChanged<String?> onCurrencyChange;

  final String? accountValue;
  final ValueChanged<String?> onAccountChanged;

  final ZohoFieldBuilder zohoField;
  final ZohoTextFieldBuilder zohoTextField;
  final ZohoDropdownBuilder zohoDropdown;

  const SalesSection({
    super.key,
    required this.sellingPriceCtrl,
    required this.mrpCtrl,
    required this.ptrCtrl,
    required this.descriptionCtrl,
    required this.currency,
    required this.onCurrencyChange,
    required this.accountValue,
    required this.onAccountChanged,
    required this.zohoField,
    required this.zohoTextField,
    required this.zohoDropdown,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 640, // same feel as Purchase section
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Information',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),

            // Selling Price
            zohoField(
              label: 'Selling Price',
              required: true,
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: zohoDropdown<String>(
                      value: currency,
                      items: const ['INR', 'USD', 'AED'],
                      onChanged: onCurrencyChange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: zohoTextField(
                      controller: sellingPriceCtrl,
                      hint: 'Enter price',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // MRP
            zohoField(
              label: 'Mrp',
              child: zohoTextField(
                controller: mrpCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // PTR
            zohoField(
              label: 'Ptr',
              child: zohoTextField(
                controller: ptrCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Account
            zohoField(
              label: 'Account',
              required: true,
              child: zohoDropdown<String>(
                value: accountValue,
                items: const ['Sales', 'Sales - Retail', 'Sales - Online'],
                onChanged: onAccountChanged,
              ),
            ),
            const SizedBox(height: 12),

            // Description (multi-line, same style/size as Purchase)
            zohoField(
              label: 'Description',
              child: SizedBox(
                height: 96,
                child: TextField(
                  controller: descriptionCtrl,
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: Color(0xFFD1D5DB),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: Color(0xFF2563EB),
                        width: 1,
                      ),
                    ),
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
