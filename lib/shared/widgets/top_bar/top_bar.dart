import 'package:flutter/material.dart';

// Correct imports based on your folder structure
import '../../theme/app_text_styles.dart';
import '../inputs/custom_text_field.dart';

class TopBar extends StatelessWidget {
  final String title;

  const TopBar({super.key, required this.title});

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
            child: CustomTextField(
              hintText: "Search",
              prefixIcon: Icons.search,
            ),
          ),

          const Spacer(),

          Text("Welcome To Zerpai", style: AppTextStyles.subtitle),

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
