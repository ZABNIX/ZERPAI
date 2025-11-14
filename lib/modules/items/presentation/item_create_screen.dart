// FILE: lib/modules/items/presentation/item_create_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controller + Model
import '../controller/items_controller.dart';
import '../models/item_model.dart';

// Sections
import 'sections/composition_section.dart';
import 'sections/formulation_section.dart';
import 'sections/sales_section.dart';
import 'sections/purchase_section.dart';

// Composition model
import '../models/item_composition_model.dart';

enum ItemTab { composition, formulation, sales, purchase }

class ItemCreateScreen extends ConsumerStatefulWidget {
  const ItemCreateScreen({super.key});

  @override
  ConsumerState<ItemCreateScreen> createState() => _ItemCreateScreenState();
}

class _ItemCreateScreenState extends ConsumerState<ItemCreateScreen> {
  ItemTab selectedTab = ItemTab.composition;

  // Form controllers
  final nameCtrl = TextEditingController();
  final skuCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final mrpCtrl = TextEditingController();

  // Stores composition rows sent from CompositionSection
  List<ItemComposition> compositionRows = [];

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsControllerProvider);
    final itemsController = ref.read(itemsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Item"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),

      backgroundColor: const Color(0xfff5f7fb),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildBasicDetailsCard(),
            const SizedBox(height: 16),
            _buildTabBar(),
            const SizedBox(height: 16),
            _buildTabContent(),
            const SizedBox(height: 30),

            // SAVE BUTTON
            ElevatedButton(
              onPressed: itemsState.isSaving
                  ? null
                  : () async {
                      final item = Item(
                        name: nameCtrl.text.trim(),
                        sku: skuCtrl.text.trim(),
                        category: categoryCtrl.text.trim(),
                        mrp: double.tryParse(mrpCtrl.text),
                      );

                      // In future: attach compositionRows to item request

                      await itemsController.createItem(item);

                      if (mounted) Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              child: itemsState.isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Save Item",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BASIC DETAILS FORM ----------------
  Widget _buildBasicDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Basic Information",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          const SizedBox(height: 16),

          _textField("Item Name", nameCtrl),
          const SizedBox(height: 12),

          _textField("SKU", skuCtrl),
          const SizedBox(height: 12),

          _textField("Category", categoryCtrl),
          const SizedBox(height: 12),

          _textField("MRP", mrpCtrl, keyboard: TextInputType.number),
        ],
      ),
    );
  }

  // ---------------- TOP TAB BAR ----------------
  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: ItemTab.values.map((tab) {
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: selectedTab == tab
                      ? Colors.blueAccent
                      : Colors.transparent,
                ),
                alignment: Alignment.center,
                child: Text(
                  tab.name[0].toUpperCase() + tab.name.substring(1),
                  style: TextStyle(
                    color: selectedTab == tab ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------- TAB CONTENT ----------------
  Widget _buildTabContent() {
    switch (selectedTab) {
      case ItemTab.composition:
        return CompositionSection(
          onChanged: (rows) {
            setState(() {
              compositionRows = rows;
            });
          },
        );

      case ItemTab.formulation:
        return const FormulationSection();

      case ItemTab.sales:
        return const SalesSection();

      case ItemTab.purchase:
        return const PurchaseSection();
    }
  }

  // ---------------- REUSABLE TEXT FIELD ----------------
  Widget _textField(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
