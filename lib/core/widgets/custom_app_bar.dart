import 'dart:ui';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton; // 🌟 Back button ပြရန် parameter အသစ်

  const CustomAppBar({
    super.key,
    this.title = 'Period Tracker',
    this.actions,
    this.showBackButton = false, // Default အနေဖြင့် Drawer ကိုသာ ပြမည်
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFD6E0).withValues(alpha: 0.45),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.6),
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            titleSpacing: 0,
            // 🌟 showBackButton အပေါ်မူတည်၍ Back Icon သို့မဟုတ် Drawer Icon ပြရန်
            leading: showBackButton
                ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            )
                : Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Colors.black87, size: 26),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 0.4,
              ),
            ),
            actions: actions,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}