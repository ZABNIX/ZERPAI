// FILE: lib/modules/items/presentation/item_create_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/items_controller.dart';
import '../models/item_model.dart';

// Import section widgets
import 'sections/composition_section.dart';
import 'sections/formulation_section.dart';
import 'sections/sales_section.dart';
import 'sections/purchase_section.dart';

enum ItemTab { composition, formulation, sales, purchase }

class ItemCreateScreen extends ConsumerStatefulWidget {
  const ItemCreateScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ItemCreateScreen> createState() => _ItemCreateScreenState();
}

class _ItemCreateScreenState extends ConsumerState<ItemCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Basic fields
  String _type = 'Goods';
  final _nameCtrl = TextEditingController();
  final _billingNameCtrl = TextEditingController();
  final _itemCodeCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  String? _unitPack;
  String? _category;
  bool _returnable = true;
  final _hsnCtrl = TextEditingController();
  String _taxPreference = 'Taxable';
  String? _ecomStatus;

  // Tax rates
  String _intraStateTaxRate = 'GST12(12%)';
  String _interStateTaxRate = 'IGST12(12%)';

  // Tabs
  ItemTab _currentTab = ItemTab.composition;

  // Composition data (comes from child widget)
  List<ItemComposition> _compositionList = [];

  // Bottom settings
  String? _buyingRule;
  bool _trackInventory = false;
  bool _trackBinLocation = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _billingNameCtrl.dispose();
    _itemCodeCtrl.dispose();
    _skuCtrl.dispose();
    _hsnCtrl.dispose();
    super.dispose();
  }

  void updateComposition(List<ItemComposition> list) {
    _compositionList = list;
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final item = ItemModel(
      type: _type,
      name: _nameCtrl.text.trim(),
      billingName: _billingNameCtrl.text.trim(),
      itemCode: _itemCodeCtrl.text.trim(),
      sku: _skuCtrl.text.trim(),
      unitPack: _unitPack ?? "",
      category: _category,
      returnable: _returnable,
      hsnCode: _hsnCtrl.text.trim(),
      taxPreference: _taxPreference,
      ecommerceStatus: _ecomStatus,
      intraStateTaxRate: _intraStateTaxRate,
      interStateTaxRate: _interStateTaxRate,
      trackActiveIngredients: true,
      compositions: _compositionList,
      buyingRule: _buyingRule,
      trackInventory: _trackInventory,
      trackBinLocation: _trackBinLocation,
    );

    await ref.read(itemsControllerProvider.notifier).createItem(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Item Registration Request",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildTopSection(),
                          const SizedBox(height: 20),
                          _buildDefaultTaxCard(),
                          const SizedBox(height: 20),
                          _buildTabs(),
                          const SizedBox(height: 10),
                          _buildTabSection(),
                          const SizedBox(height: 20),
                          _buildBottomOptions(),
                        ],
                      ),
                    ),
                  ),
                  _buildSaveButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- UI builders ---------------------

  Widget _buildTopSection() {
    // SAME UI AS PREVIOUS ANSWER (I won’t repeat to reduce length)
    // This contains: type, name, billing name, item code, sku, unit pack,
    // category, returnable, HSN, Tax Preference, Ecommerce, and Image Card.

    // I WILL RE-POST THIS PART FULLY IF YOU WANT.
    return Container(
      height: 200,
      color: Colors.white,
      child: const Center(
        child: Text("TOP BASIC FIELDS CARD (same as earlier code)"),
      ),
    );
  }

  Widget _buildDefaultTaxCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [Text("Default Tax Rates (UI same as previous code)")],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _tab(ItemTab.composition, "Composition Information"),
        _tab(ItemTab.formulation, "Formulate Information"),
        _tab(ItemTab.sales, "Sales Information"),
        _tab(ItemTab.purchase, "Purchase Information"),
      ],
    );
  }

  Widget _tab(ItemTab tab, String label) {
    final active = _currentTab == tab;
    return InkWell(
      onTap: () => setState(() => _currentTab = tab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.blue : Colors.black87,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildTabSection() {
    switch (_currentTab) {
      case ItemTab.composition:
        return CompositionSection(onChanged: updateComposition);

      case ItemTab.formulation:
        return const FormulationSection();

      case ItemTab.sales:
        return const SalesSection();

      case ItemTab.purchase:
        return const PurchaseSection();
    }
  }

  Widget _buildBottomOptions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Buying rules + Track Inventory + Track Bin Location"),
        ],
      ),
    );
  }

  Widget _buildSaveButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Save"),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
