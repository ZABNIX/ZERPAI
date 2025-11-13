// PATH: lib/modules/items/presentation/items_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dummy item model for now (later Firestore)
class DummyItem {
  final String name;
  final String sku;
  final String category;
  final double mrp;
  final bool isActive;

  DummyItem({
    required this.name,
    required this.sku,
    required this.category,
    required this.mrp,
    this.isActive = true,
  });
}

/// Provider for dummy item list
final itemsProvider = Provider<List<DummyItem>>((ref) {
  return [
    DummyItem(
      name: 'Paracetamol 500mg Tablet',
      sku: 'PARA500',
      category: 'Analgesics',
      mrp: 35.0,
    ),
    DummyItem(
      name: 'Azithromycin 500mg',
      sku: 'AZI500',
      category: 'Antibiotics',
      mrp: 120.0,
    ),
    DummyItem(
      name: 'Vitamin D3 60K Capsule',
      sku: 'VITD360K',
      category: 'Supplements',
      mrp: 180.0,
    ),
    DummyItem(
      name: 'Pantoprazole 40mg',
      sku: 'PANTO40',
      category: 'Gastro',
      mrp: 95.0,
    ),
  ];
});

/// Search text provider
final itemSearchQueryProvider = StateProvider<String>((ref) => '');

class ItemsListScreen extends ConsumerWidget {
  const ItemsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsProvider);
    final query = ref.watch(itemSearchQueryProvider);

    final filteredItems = items.where((item) {
      if (query.isEmpty) return true;
      final q = query.toLowerCase();
      return item.name.toLowerCase().contains(q) ||
          item.sku.toLowerCase().contains(q) ||
          item.category.toLowerCase().contains(q);
    }).toList();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Row(
        children: [
          // LEFT SIDEBAR
          SizedBox(
            width: 230,
            child: Material(
              elevation: 1,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo / App name
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.local_pharmacy_outlined,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Zerpai',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Inventory',
                      style: textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _SidebarTile(
                      label: 'Items',
                      icon: Icons.inventory_2_outlined,
                      isActive: true,
                      onTap: () {},
                    ),
                    _SidebarTile(
                      label: 'Price Lists',
                      icon: Icons.price_change_outlined,
                      isActive: false,
                      onTap: () {},
                    ),
                    _SidebarTile(
                      label: 'Composite Items',
                      icon: Icons.merge_type_outlined,
                      isActive: false,
                      onTap: () {},
                    ),
                    _SidebarTile(
                      label: 'Adjustments',
                      icon: Icons.tune_outlined,
                      isActive: false,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Masters',
                      style: textTheme.labelMedium?.copyWith(
                        color: Colors.grey[600],
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _SidebarTile(
                      label: 'Item Groups',
                      icon: Icons.group_work_outlined,
                      isActive: false,
                      onTap: () {},
                    ),
                    _SidebarTile(
                      label: 'Item Mapping',
                      icon: Icons.link_outlined,
                      isActive: false,
                      onTap: () {},
                    ),
                    const Spacer(),
                    Divider(color: Colors.grey.shade200),
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        radius: 14,
                        child: Icon(Icons.person, size: 16),
                      ),
                      title: Text('Admin User', style: textTheme.bodySmall),
                      subtitle: Text(
                        'Sahakar Group',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: Column(
              children: [
                // TOP BAR
                Material(
                  elevation: 1,
                  child: Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          'Items',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.store_mall_directory_outlined,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Branch: HO / Hyper',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 260,
                          child: TextField(
                            onChanged: (value) {
                              ref.read(itemSearchQueryProvider.notifier).state =
                                  value;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search, size: 20),
                              hintText: 'Search by name, SKU, category',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        FilledButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'New Item – create screen will come later.',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('New Item'),
                        ),
                      ],
                    ),
                  ),
                ),

                // CONTENT AREA
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Header row
                            Row(
                              children: [
                                Text(
                                  'All Items',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Text(
                                    '${filteredItems.length} items',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.filter_list_outlined),
                                  label: const Text('Filter'),
                                ),
                                const SizedBox(width: 4),
                                TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.download_outlined),
                                  label: const Text('Export'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Table header
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 32), // checkbox
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Item Name',
                                      style: textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Item Code / SKU',
                                      style: textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Category',
                                      style: textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'MRP',
                                      textAlign: TextAlign.right,
                                      style: textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 44),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Table body
                            Expanded(
                              child: filteredItems.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No items found for this search.',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: filteredItems.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 4),
                                      itemBuilder: (context, index) {
                                        final item = filteredItems[index];
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 32,
                                                child: Checkbox(
                                                  value: false,
                                                  onChanged: (_) {},
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  item.name,
                                                  style: textTheme.bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  item.sku,
                                                  style: textTheme.bodyMedium,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  item.category,
                                                  style: textTheme.bodyMedium
                                                      ?.copyWith(
                                                        color: Colors.grey[700],
                                                      ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  '₹ ${item.mrp.toStringAsFixed(2)}',
                                                  textAlign: TextAlign.right,
                                                  style: textTheme.bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 44,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.more_vert,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
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
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary.withOpacity(0.08) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? colorScheme.primary : Colors.grey.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? colorScheme.primary : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
