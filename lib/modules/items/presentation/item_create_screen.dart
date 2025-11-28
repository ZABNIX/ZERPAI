// FILE: lib/modules/items/presentation/item_create_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Controller + Models
import 'package:zerpai_erp/modules/items/controller/items_controller.dart';
import 'package:zerpai_erp/modules/items/models/item_model.dart';
import 'package:zerpai_erp/modules/items/models/item_composition_model.dart';

// Shared Inputs
import 'package:zerpai_erp/shared/widgets/inputs/shared_field_layout.dart';
import 'package:zerpai_erp/shared/widgets/inputs/custom_text_field.dart';
import 'package:zerpai_erp/shared/widgets/inputs/dropdown_input.dart';
import 'package:zerpai_erp/shared/widgets/inputs/radio_input.dart';
import 'package:zerpai_erp/shared/widgets/inputs/category_dropdown.dart';

import 'package:zerpai_erp/shared/widgets/z_button.dart';
import 'package:zerpai_erp/shared/widgets/zoho_layout.dart';

// Sections
import 'sections/composition_section.dart';
import 'sections/formulation_section.dart';
import 'sections/sales_section.dart';
import 'sections/purchase_section.dart';
import 'sections/default_tax_rates_section.dart';

enum ItemTab { composition, formulation, sales, purchase }

// NEW: inventory tracking options (Goods Only)
enum InventoryTrackingMode { none, batches }

class ItemCreateScreen extends ConsumerStatefulWidget {
  const ItemCreateScreen({super.key});

  @override
  ConsumerState<ItemCreateScreen> createState() => _ItemCreateScreenState();
}

class _ItemCreateScreenState extends ConsumerState<ItemCreateScreen> {
  ItemTab selectedTab = ItemTab.composition;

  // ---------- UNIT CONFIG DIALOG ----------

  void _openUnitConfigDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        final List<_UnitRow> rows = [
          _UnitRow('box', 'BOX'),
          _UnitRow('cm', 'CMS'),
          _UnitRow('dz', 'DOZ'),
          _UnitRow('ft', 'FTS'),
          _UnitRow('g', 'GMS'),
          _UnitRow('in', 'INC'),
          _UnitRow('kg', 'KGS'),
          _UnitRow('km', 'KME'),
        ];

        const uqcOptions = <String>[
          'BOX',
          'CMS',
          'DOZ',
          'FTS',
          'GMS',
          'INC',
          'KGS',
          'KME',
        ];

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 80,
            vertical: 40,
          ),
          child: StatefulBuilder(
            builder: (ctx, setDialogState) {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 760,
                  maxHeight: 520,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ----- Title bar -----
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 18, 16, 12),
                      child: Row(
                        children: [
                          const Text(
                            'Configure Units',
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
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),

                    // ----- Header row -----
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Unit*',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Unique Quantity Code (UQC)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                          SizedBox(width: 32),
                        ],
                      ),
                    ),

                    // ----- Scrollable rows -----
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: rows.length,
                        itemBuilder: (context, index) {
                          final row = rows[index];

                          return MouseRegion(
                            onEnter: (_) =>
                                setDialogState(() => row.isHovered = true),
                            onExit: (_) =>
                                setDialogState(() => row.isHovered = false),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  // Unit text field
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: CustomTextField(
                                        controller: row.unitCtrl,
                                        height: 36,
                                        hintText: '',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // UQC dropdown
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: FormDropdown<String>(
                                        value: row.uqcValue,
                                        items: uqcOptions,
                                        hint: 'Select UQC',
                                        onChanged: (v) {
                                          setDialogState(() {
                                            row.uqcValue = v;
                                          });
                                        },
                                        allowClear: true,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Delete icon on hover
                                  AnimatedOpacity(
                                    opacity: row.isHovered ? 1 : 0,
                                    duration: const Duration(milliseconds: 120),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Color(0xFFEF4444),
                                      ),
                                      splashRadius: 16,
                                      onPressed: () {
                                        setDialogState(() {
                                          rows.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const Divider(height: 1, color: Color(0xFFE5E7EB)),

                    // ----- Footer -----
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setDialogState(() {
                                rows.add(_UnitRow('', ''));
                              });
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 18,
                              color: Color(0xFF2563EB),
                            ),
                            label: const Text(
                              'Add New',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Save'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ---------------- BASIC INFO ----------------
  bool isGoods = true;

  final nameCtrl = TextEditingController();
  final billingNameCtrl = TextEditingController();
  final itemCodeCtrl = TextEditingController();
  final skuCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  String? unitPack;
  final hsnCtrl = TextEditingController();
  final sacCtrl = TextEditingController(); // SAC for services
  String? taxPreference = 'Taxable';

  bool isReturnable = true;
  bool pushToEcommerce = false;

  // Inventory flags — GOODS ONLY
  bool trackInventory = false;
  bool trackBinLocation = false;

  String? intraStateTax = "GST12 [12%]";
  String? interStateTax = "IGST12 [12%]";

  // ---------------- FORMULATION (Goods only) ----------------
  final dimXCtrl = TextEditingController();
  final dimYCtrl = TextEditingController();
  final dimZCtrl = TextEditingController();
  String dimUnit = 'cm';

  final weightCtrl = TextEditingController();
  String weightUnit = 'kg';

  String? manufacturer;
  String? brand;

  final upcCtrl = TextEditingController();
  final eanCtrl = TextEditingController();
  final mpnCtrl = TextEditingController();
  final isbnCtrl = TextEditingController();

  // ---------------- SALES SECTION ----------------
  final sellingPriceCtrl = TextEditingController();
  final mrpCtrl = TextEditingController();
  final ptrCtrl = TextEditingController();
  final salesDescriptionCtrl = TextEditingController();
  String salesCurrency = 'INR';
  String? salesAccount;

  // ---------------- PURCHASE SECTION ----------------
  final costPriceCtrl = TextEditingController();
  final purchaseDescriptionCtrl = TextEditingController();
  String purchaseCurrency = 'INR';
  String? purchaseAccount;
  String? preferredVendor;

  // ---------------- INVENTORY (Goods ONLY) ----------------
  InventoryTrackingMode trackingMode = InventoryTrackingMode.none;
  String? inventoryAccount;
  String? valuationMethod;
  String? storage;
  String? rack;
  final reorderPointCtrl = TextEditingController();
  String? reorderTerms;

  // ---------------- COMPOSITION (Goods ONLY) ----------------
  List<ItemComposition> _compositionRows = [];

  // ---------------- CATEGORY GROUPS (for parent–child dropdown) --------
  final List<CategoryGroup> _categoryGroups = const [
    CategoryGroup(
      parent: 'MEDICINES',
      children: ['OTHER BRANDS', 'MARKETED BRANDS', 'UNMARKED BRANDS', 'Test'],
    ),
    CategoryGroup(parent: 'Shabin', children: ['deethi']),
    CategoryGroup(parent: 'Test category', children: ['PARENT']),
  ];

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsControllerProvider);
    final itemsController = ref.read(itemsControllerProvider.notifier);

    return ZohoLayout(
      pageTitle: 'New Item',
      enableBodyScroll: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Scrollable form content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderTitle(),
                  const SizedBox(height: 12),

                  _buildTopPanel(),
                  const SizedBox(height: 24),

                  DefaultTaxRatesSection(
                    intraStateRate: intraStateTax,
                    interStateRate: interStateTax,
                    onChanged: (intra, inter) {
                      setState(() {
                        intraStateTax = intra;
                        interStateTax = inter;
                      });
                    },
                  ),

                  const SizedBox(height: 24),
                  _buildTabsCard(),
                  const SizedBox(height: 24),

                  if (isGoods) _buildInventoryFlags(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Sticky bottom bar
          _buildSaveCancel(itemsController, itemsState.isSaving),
        ],
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _buildHeaderTitle() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Text(
        'Item Registration Request',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF111827),
        ),
      ),
    );
  }

  // ---------------- TOP PANEL ----------------

  Widget _buildTopPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 600, child: _buildLeftFields()),
          const SizedBox(width: 40),
          _buildImageUploadBox(),
        ],
      ),
    );
  }

  /// LEFT SIDE – GOODS / SERVICE
  Widget _buildLeftFields() {
    if (isGoods) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeRow(),
          const SizedBox(height: 16),

          SharedFieldLayout(
            label: 'Name',
            required: true,
            child: CustomTextField(controller: nameCtrl),
          ),
          const SizedBox(height: 12),

          SharedFieldLayout(
            label: 'Billing Name',
            child: CustomTextField(controller: billingNameCtrl),
          ),
          const SizedBox(height: 12),

          SharedFieldLayout(
            label: 'Item Code',
            child: CustomTextField(controller: itemCodeCtrl),
          ),
          const SizedBox(height: 12),

          SharedFieldLayout(
            label: 'SKU',
            child: CustomTextField(controller: skuCtrl),
          ),
          const SizedBox(height: 12),

          // UNIT
          SharedFieldLayout(
            label: 'Unit',
            required: true,
            child: FormDropdown<String>(
              value: unitPack,
              items: const ['1 x 10', '1 x 15', 'Bottle', 'Box'],
              hint: "Select Unit",
              onChanged: (v) => setState(() => unitPack = v),
              showSettings: true,
              settingsLabel: 'Manage Units...',
              onSettingsTap: _openUnitConfigDialog,
            ),
          ),

          const SizedBox(height: 12),

          // CATEGORY (parent–child dropdown)
          SharedFieldLayout(
            label: 'Category',
            child: CategoryDropdown(
              groups: _categoryGroups,
              value: categoryCtrl.text.isEmpty ? null : categoryCtrl.text,
              onChanged: (v) => setState(() => categoryCtrl.text = v ?? ''),
              onManageCategoriesTap: _openCategorySettings,
            ),
          ),

          const SizedBox(height: 12),
          _buildReturnableRow(),

          const SizedBox(height: 12),
          _buildHsnRow(),

          const SizedBox(height: 12),
          SharedFieldLayout(
            label: 'Tax Preference',
            required: true,
            child: FormDropdown<String>(
              value: taxPreference,
              items: const ['Taxable', 'Tax Exempt', 'Zero Rated'],
              onChanged: (v) => setState(() => taxPreference = v),
            ),
          ),
        ],
      );
    }

    // SERVICE layout
    return _buildServiceFields();
  }

  // ---------------- SERVICE LAYOUT ----------------

  Widget _buildServiceFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTypeRow(),
        const SizedBox(height: 16),

        SharedFieldLayout(
          label: 'Name',
          required: true,
          child: CustomTextField(controller: nameCtrl),
        ),
        const SizedBox(height: 12),

        SharedFieldLayout(
          label: 'Service Code',
          child: CustomTextField(controller: itemCodeCtrl),
        ),
        const SizedBox(height: 12),

        SharedFieldLayout(
          label: 'Category',
          child: CategoryDropdown(
            groups: _categoryGroups,
            value: categoryCtrl.text.isEmpty ? null : categoryCtrl.text,
            onChanged: (v) => setState(() => categoryCtrl.text = v ?? ''),
            onManageCategoriesTap: _openCategorySettings,
          ),
        ),
        const SizedBox(height: 12),

        // SAC
        SharedFieldLayout(
          label: 'SAC',
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: CustomTextField(
                    controller: sacCtrl,
                    hintText: "Enter SAC",
                    height: 44,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 24,
                height: 44,
                child: Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      // TODO: open SAC search
                    },
                    child: const Icon(
                      Icons.search,
                      size: 18,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        SharedFieldLayout(
          label: 'Tax Preference',
          required: true,
          child: FormDropdown<String>(
            value: taxPreference,
            items: const ['Taxable', 'Tax Exempt'],
            onChanged: (v) => setState(() => taxPreference = v),
          ),
        ),
      ],
    );
  }

  // ---------------- TYPE SWITCH ----------------

  Widget _buildTypeRow() {
    return SharedFieldLayout(
      label: "Type",
      child: Row(
        children: [
          FormRadio(
            label: "Goods",
            value: true,
            groupValue: isGoods,
            onChanged: (_) {
              setState(() {
                isGoods = true;
                selectedTab = ItemTab.composition;
              });
            },
          ),
          const SizedBox(width: 24),
          FormRadio(
            label: "Service",
            value: false,
            groupValue: isGoods,
            onChanged: (_) {
              setState(() {
                isGoods = false;
                selectedTab = ItemTab.sales;
              });
            },
          ),
        ],
      ),
    );
  }

  // ---------------- RETURNABLE + ECOMMERCE ROW ----------------

  Widget _buildReturnableRow() {
    return SharedFieldLayout(
      label: "",
      child: Row(
        children: [
          Checkbox(
            value: isReturnable,
            visualDensity: VisualDensity.compact,
            onChanged: (v) => setState(() => isReturnable = v ?? false),
          ),
          const Text("Returnable Item", style: TextStyle(fontSize: 13)),
          const SizedBox(width: 28),
          Checkbox(
            value: pushToEcommerce,
            visualDensity: VisualDensity.compact,
            onChanged: (v) => setState(() => pushToEcommerce = v ?? false),
          ),
          const Text("Push To Ecommerce", style: TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  // ---------------- HSN CODE ROW ----------------

  Widget _buildHsnRow() {
    const double fieldHeight = 44.0;

    return SharedFieldLayout(
      label: "HSN Code",
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: fieldHeight,
              child: CustomTextField(
                controller: hsnCtrl,
                hintText: "Enter HSN",
                height: fieldHeight,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 24,
            height: fieldHeight,
            child: Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  // TODO: open HSN search
                },
                child: const Icon(
                  Icons.search,
                  size: 18,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- IMAGE UPLOAD BOX ----------------

  Widget _buildImageUploadBox() {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFD),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD4D7E2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: const [
          Icon(Icons.image_outlined, size: 42, color: Color(0xFF9CA3AF)),
          SizedBox(height: 12),
          Text(
            "Drag image(s) here or",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
          ),
          SizedBox(height: 4),
          Text(
            "Browse images",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF1B8EF1),
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "You can add up to 15 images, each not exceeding 5MB and 7000 x 7000 px.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF6B7280),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TABS CARD ----------------

  Widget _buildTabsCard() {
    final tabs = isGoods
        ? [
            _tabHeader("Composition Information", ItemTab.composition),
            _tabHeader("Formulate Information", ItemTab.formulation),
            _tabHeader("Sales Information", ItemTab.sales),
            _tabHeader("Purchase Information", ItemTab.purchase),
          ]
        : [
            _tabHeader("Sales Information", ItemTab.sales),
            _tabHeader("Purchase Information", ItemTab.purchase),
          ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(children: tabs),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: _buildTabBody(),
          ),
        ],
      ),
    );
  }

  Widget _tabHeader(String title, ItemTab tab) {
    if (!isGoods &&
        (tab == ItemTab.composition || tab == ItemTab.formulation)) {
      return const SizedBox();
    }

    final active = selectedTab == tab;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedTab = tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? const Color(0xFF1B8EF1) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: active ? const Color(0xFF111827) : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- TAB BODY ----------------

  Widget _buildTabBody() {
    if (isGoods) {
      switch (selectedTab) {
        case ItemTab.composition:
          return CompositionSection(
            onChanged: (rows) => setState(() => _compositionRows = rows),
          );
        case ItemTab.formulation:
          return FormulationSection(
            dimXCtrl: dimXCtrl,
            dimYCtrl: dimYCtrl,
            dimZCtrl: dimZCtrl,
            dimUnit: dimUnit,
            onDimUnitChange: (v) => setState(() => dimUnit = v ?? 'cm'),
            weightCtrl: weightCtrl,
            weightUnit: weightUnit,
            onWeightUnitChange: (v) => setState(() => weightUnit = v ?? 'kg'),
            manufacturer: manufacturer,
            onManufacturerChange: (v) => setState(() => manufacturer = v),
            brand: brand,
            onBrandChange: (v) => setState(() => brand = v),
            upcCtrl: upcCtrl,
            eanCtrl: eanCtrl,
            mpnCtrl: mpnCtrl,
            isbnCtrl: isbnCtrl,
            zohoField:
                ({
                  required String label,
                  required Widget child,
                  bool required = false,
                  String? helper,
                }) => SharedFieldLayout(
                  label: label,
                  required: required,
                  child: child,
                ),
            zohoTextField:
                ({
                  required TextEditingController controller,
                  String? hint,
                  TextInputType keyboardType = TextInputType.text,
                  int maxLines = 1,
                  double height = 44,
                }) => CustomTextField(
                  controller: controller,
                  hintText: hint,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  height: height,
                ),
            zohoDropdown:
                <T>({
                  required T? value,
                  required List<T> items,
                  String? hint,
                  required ValueChanged<T?> onChanged,
                  bool? showSettings,
                  String? settingsLabel,
                  VoidCallback? onSettingsTap,
                  bool? allowClear,
                }) {
                  return FormDropdown<T>(
                    value: value,
                    items: items,
                    hint: hint,
                    onChanged: onChanged,
                    showSettings: showSettings ?? false,
                    settingsLabel: settingsLabel ?? 'Configure...',
                    onSettingsTap: onSettingsTap,
                    allowClear: allowClear ?? false,
                  );
                },
          );
        case ItemTab.sales:
          break;
        case ItemTab.purchase:
          break;
      }
    }

    // SALES TAB
    if (selectedTab == ItemTab.sales) {
      return SalesSection(
        sellingPriceCtrl: sellingPriceCtrl,
        mrpCtrl: mrpCtrl,
        ptrCtrl: ptrCtrl,
        descriptionCtrl: salesDescriptionCtrl,
        currency: salesCurrency,
        onCurrencyChange: (v) => setState(() => salesCurrency = v ?? 'INR'),
        accountValue: salesAccount,
        onAccountChanged: (v) => setState(() => salesAccount = v),
        zohoField:
            ({
              required String label,
              required Widget child,
              bool required = false,
              String? helper,
            }) => SharedFieldLayout(
              label: label,
              required: required,
              child: child,
            ),
        zohoTextField:
            ({
              required TextEditingController controller,
              String? hint,
              TextInputType keyboardType = TextInputType.text,
              int maxLines = 1,
              double height = 44,
            }) => CustomTextField(
              controller: controller,
              hintText: hint,
              keyboardType: keyboardType,
              maxLines: maxLines,
              height: height,
            ),
        zohoDropdown:
            <T>({
              required T? value,
              required List<T> items,
              String? hint,
              required ValueChanged<T?> onChanged,
              bool? showSettings,
              String? settingsLabel,
              VoidCallback? onSettingsTap,
              bool? allowClear,
            }) {
              return FormDropdown<T>(
                value: value,
                items: items,
                hint: hint,
                onChanged: onChanged,
                showSettings: showSettings ?? false,
                settingsLabel: settingsLabel ?? 'Configure...',
                onSettingsTap: onSettingsTap,
                allowClear: allowClear ?? false,
              );
            },
      );
    }

    // PURCHASE TAB
    return PurchaseSection(
      costPriceCtrl: costPriceCtrl,
      currency: purchaseCurrency,
      onCurrencyChange: (v) => setState(() => purchaseCurrency = v ?? 'INR'),
      accountValue: purchaseAccount,
      onAccountChanged: (v) => setState(() => purchaseAccount = v),
      preferredVendor: preferredVendor,
      onVendorChanged: (v) => setState(() => preferredVendor = v),
      descriptionCtrl: purchaseDescriptionCtrl,
      zohoField:
          ({
            required String label,
            required Widget child,
            bool required = false,
            String? helper,
          }) =>
              SharedFieldLayout(label: label, required: required, child: child),
      zohoTextField:
          ({
            required TextEditingController controller,
            String? hint,
            TextInputType keyboardType = TextInputType.text,
            int maxLines = 1,
            double height = 96,
          }) => CustomTextField(
            controller: controller,
            hintText: hint,
            keyboardType: keyboardType,
            maxLines: maxLines,
            height: height,
          ),
      zohoDropdown:
          <T>({
            required T? value,
            required List<T> items,
            String? hint,
            required ValueChanged<T?> onChanged,
            bool? showSettings,
            String? settingsLabel,
            VoidCallback? onSettingsTap,
            bool? allowClear,
          }) {
            return FormDropdown<T>(
              value: value,
              items: items,
              hint: hint,
              onChanged: onChanged,
              showSettings: showSettings ?? false,
              settingsLabel: settingsLabel ?? 'Configure...',
              onSettingsTap: onSettingsTap,
              allowClear: allowClear ?? false,
            );
          },
    );
  }

  // ---------------- INVENTORY (GOODS ONLY) ----------------

  Widget _buildInventoryFlags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inventory Settings',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Checkbox(
              value: trackInventory,
              visualDensity: VisualDensity.compact,
              onChanged: (v) => setState(() => trackInventory = v ?? false),
            ),
            const Text(
              'Track Inventory for this item',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 40),
          child: Text(
            "You cannot enable/disable inventory tracking once you've created transactions.",
            style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Checkbox(
              value: trackBinLocation,
              visualDensity: VisualDensity.compact,
              onChanged: (v) => setState(() => trackBinLocation = v ?? false),
            ),
            const Text(
              'Track Bin Location for this Item',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),

        if (trackInventory) _buildAdvancedInventory(),
      ],
    );
  }

  // ---------------- ADVANCED INVENTORY BOX ----------------

  Widget _buildAdvancedInventory() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Advanced Inventory Tracking',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),

          RadioListTile<InventoryTrackingMode>(
            title: const Text('None'),
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: InventoryTrackingMode.none,
            groupValue: trackingMode,
            onChanged: (v) =>
                setState(() => trackingMode = v ?? InventoryTrackingMode.none),
          ),

          RadioListTile<InventoryTrackingMode>(
            title: const Text('Track Batches'),
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: InventoryTrackingMode.batches,
            groupValue: trackingMode,
            onChanged: (v) => setState(
              () => trackingMode = v ?? InventoryTrackingMode.batches,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: SharedFieldLayout(
                  label: "Inventory Account",
                  required: true,
                  child: FormDropdown<String>(
                    value: inventoryAccount,
                    items: const [
                      'Inventory Account',
                      'Finished Goods',
                      'Raw Materials',
                    ],
                    hint: 'Select account',
                    onChanged: (v) => setState(() => inventoryAccount = v),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SharedFieldLayout(
                  label: "Valuation Method",
                  required: true,
                  child: FormDropdown<String>(
                    value: valuationMethod,
                    items: const ['FIFO', 'LIFO', 'Weighted Average'],
                    hint: 'Select method',
                    onChanged: (v) => setState(() => valuationMethod = v),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: SharedFieldLayout(
                  label: "Storage",
                  child: FormDropdown<String>(
                    value: storage,
                    items: const ['Below 50c', 'Below 50c', 'Below 50c'],
                    hint: 'Select storage',
                    onChanged: (v) => setState(() => storage = v),
                    showSettings: true,
                    settingsLabel: 'Manage Storage',
                    onSettingsTap: _openCategorySettings,
                    allowClear: true,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SharedFieldLayout(
                  label: "Rack",
                  child: FormDropdown<String>(
                    value: rack,
                    items: const ['A', 'B', 'C'],
                    hint: 'Select rack',
                    onChanged: (v) => setState(() => rack = v),
                    showSettings: true,
                    settingsLabel: 'Manage Racks...',
                    onSettingsTap: _openCategorySettings,
                    allowClear: true,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: SharedFieldLayout(
                  label: "Reorder Point",
                  child: CustomTextField(
                    controller: reorderPointCtrl,
                    hintText: "Enter reorder point",
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SharedFieldLayout(
                  label: "Reorder Terms",
                  child: FormDropdown<String>(
                    value: reorderTerms,
                    items: const [
                      'Prescription Required',
                      'Prescription Not Needed',
                    ],
                    hint: 'Select term',
                    onChanged: (v) => setState(() => reorderTerms = v),
                    showSettings: true,
                    settingsLabel: 'Manage Categories...',
                    onSettingsTap: _openCategorySettings,
                    allowClear: true,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.info_outline, size: 16, color: Color(0xFF2563EB)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'NOTE: You can add opening stock after saving the item.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF1E3A8A)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SAVE / CANCEL STICKY FOOTER ----------------

  Widget _buildSaveCancel(ItemsController controller, bool isSaving) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          ZButton.primary(
            label: "Save",
            loading: isSaving,
            onPressed: isSaving
                ? null
                : () async {
                    final item = Item(
                      name: nameCtrl.text.trim(),
                      sku: skuCtrl.text.trim(),
                      category: categoryCtrl.text.trim(),
                      mrp: null,
                    );

                    await controller.createItem(item);

                    if (!mounted) return;
                    Navigator.pop(context);
                  },
          ),
          const SizedBox(width: 12),
          ZButton.secondary(
            label: "Cancel",
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _openCategorySettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Manage Categories'),
          content: const Text(
            'Later you can navigate to your Categories master screen from here.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// Small helper model for Unit dialog only.
class _UnitRow {
  final TextEditingController unitCtrl;
  String? uqcValue;
  bool isHovered;

  _UnitRow(String unit, String uqc)
    : unitCtrl = TextEditingController(text: unit),
      uqcValue = uqc,
      isHovered = false;
}
