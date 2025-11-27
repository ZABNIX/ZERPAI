// FILE: lib/shared/sidebar/zoho_sidebar.dart
import 'package:zerpai_erp/shared/widgets/sidebar/zoho_sidebar_item.dart';

import 'package:flutter/material.dart';

class ZohoSidebar extends StatefulWidget {
  const ZohoSidebar({super.key});

  @override
  State<ZohoSidebar> createState() => _ZohoSidebarState();
}

class _ZohoSidebarState extends State<ZohoSidebar> {
  String activeMenu = "Items";
  bool inventoryExpanded = true;

  static const sidebarBg = Color(0xFF1F2637);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: sidebarBg,
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: Inventory
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 20,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  "Zerpai",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Home
          ZohoSidebarItem(
            icon: Icons.home_outlined,
            label: "Home",
            isActive: activeMenu == "Home",
            onTap: () => setState(() => activeMenu = "Home"),
          ),

          // Inventory / Items Group (like Zoho)
          _buildInventoryGroup(),

          ZohoSidebarItem(
            icon: Icons.point_of_sale_outlined,
            label: "Sales",
            isActive: activeMenu == "Sales",
            onTap: () => setState(() => activeMenu = "Sales"),
          ),
          ZohoSidebarItem(
            icon: Icons.local_shipping_outlined,
            label: "Purchases",
            isActive: activeMenu == "Purchases",
            onTap: () => setState(() => activeMenu = "Purchases"),
          ),
          ZohoSidebarItem(
            icon: Icons.bar_chart_outlined,
            label: "Reports",
            isActive: activeMenu == "Reports",
            onTap: () => setState(() => activeMenu = "Reports"),
          ),
          ZohoSidebarItem(
            icon: Icons.insert_drive_file_outlined,
            label: "Documents",
            isActive: activeMenu == "Documents",
            onTap: () => setState(() => activeMenu = "Documents"),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "APPS",
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          ZohoSidebarItem(
            icon: Icons.payment_outlined,
            label: "Zerpai Payments",
            isActive: false,
            onTap: () {},
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInventoryGroup() {
    return Column(
      children: [
        ZohoSidebarItem(
          icon: Icons.inventory_2_outlined,
          label: "Items",
          isActive: activeMenu == "ItemsRoot",
          trailing: Icon(
            inventoryExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: Colors.white.withValues(alpha: 0.7),
            size: 18,
          ),
          onTap: () {
            setState(() {
              inventoryExpanded = !inventoryExpanded;
            });
          },
        ),
        if (inventoryExpanded) ...[
          ZohoSidebarItem(
            icon: Icons.circle,
            iconSize: 6,
            label: "Items",
            isSubItem: true,
            isActive: activeMenu == "Items",
            onTap: () => setState(() => activeMenu = "Items"),
          ),
          ZohoSidebarItem(
            icon: Icons.circle,
            iconSize: 6,
            label: "Composite Items",
            isSubItem: true,
            isActive: activeMenu == "Composite Items",
            onTap: () => setState(() => activeMenu = "Composite Items"),
          ),
          ZohoSidebarItem(
            icon: Icons.circle,
            iconSize: 6,
            label: "Item Groups",
            isSubItem: true,
            isActive: activeMenu == "Item Groups",
            onTap: () => setState(() => activeMenu = "Item Groups"),
          ),
          ZohoSidebarItem(
            icon: Icons.circle,
            iconSize: 6,
            label: "Price Lists",
            isSubItem: true,
            isActive: activeMenu == "Price Lists",
            onTap: () => setState(() => activeMenu = "Price Lists"),
          ),
          ZohoSidebarItem(
            icon: Icons.circle,
            iconSize: 6,
            label: "Item Mapping",
            isSubItem: true,
            isActive: activeMenu == "Item Mapping",
            onTap: () => setState(() => activeMenu = "Item Mapping"),
          ),
        ],
      ],
    );
  }
}
