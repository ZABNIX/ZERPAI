// FILE: lib/shared/widgets/sidebar/zoho_sidebar_item.dart

import 'package:flutter/material.dart';

class ZohoSidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isSubItem;
  final double iconSize;
  final VoidCallback onTap;
  final Widget? trailing;

  const ZohoSidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isSubItem = false,
    this.iconSize = 20,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSubItem ? 36 : 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1B8EF1) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: iconSize,
              color: isActive ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.9),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),

            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
