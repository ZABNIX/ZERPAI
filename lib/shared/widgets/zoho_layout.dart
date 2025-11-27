import 'package:flutter/material.dart';
import '../widgets/sidebar/zoho_sidebar.dart';

class ZohoLayout extends StatelessWidget {
  final Widget child;
  final String pageTitle;
  final bool enableBodyScroll; // NEW PARAM

  const ZohoLayout({
    super.key,
    required this.child,
    required this.pageTitle,
    this.enableBodyScroll = true, // default behaviour
  });

  @override
  Widget build(BuildContext context) {
    // body scroll logic
    final Widget body = enableBodyScroll
        ? SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(40, 24, 40, 32),
            child: child,
          )
        : Padding(
            padding: const EdgeInsets.fromLTRB(40, 24, 40, 32),
            child: child,
          );

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ZohoSidebar(),

          Expanded(
            child: Column(
              children: [
                _TopBar(title: pageTitle),

                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;

  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EC))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 340,
            child: TextField(
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                prefixIcon: const Icon(Icons.search, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Color(0xFFD3D6DD),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          Text(
            "Welcome To Zerpai ",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),

          const Spacer(),

          Row(
            children: const [
              Icon(Icons.help_outline, size: 20, color: Color(0xFF4B5162)),
              SizedBox(width: 10),
              Icon(
                Icons.notifications_none,
                size: 20,
                color: Color(0xFF4B5162),
              ),
              SizedBox(width: 10),
              Icon(Icons.settings_outlined, size: 20, color: Color(0xFF4B5162)),
              SizedBox(width: 10),
              CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF6C5CE7),
                child: Text("Z", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
