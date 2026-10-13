import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // ---------------------------------------------------------
            // ၁။ Profile Header (ပုံ၊ နာမည်၊ အသက်၊ Cycle ရက် နှင့် Edit Profile ခလုတ်)
            // ---------------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Profile Image with Camera Icon
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500', // ယာယီပုံစံ
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF758C),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // Name & Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thazin Aung',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Age 22  •  Cycle 28 days',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Edit Profile Button
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const EditProfileScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD6E0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF416C),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 10,
                                      color: Color(0xFFFF416C),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Settings Icon Top Right
                      const Icon(Icons.settings_outlined, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // ---------------------------------------------------------
            // ၂။ Menu List Items (Home, Calendar, Symptoms, etc.)
            // ---------------------------------------------------------
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.home_rounded, 'Home', const Color(0xFFFF416C), () {
                    Navigator.pop(context);
                  }),
                  _buildDrawerItem(Icons.calendar_month_rounded, 'Calendar', Colors.grey.shade700, () {}),
                  _buildDrawerItem(Icons.favorite_rounded, 'Symptoms', Colors.grey.shade700, () {}),
                  _buildDrawerItem(Icons.bar_chart_rounded, 'Statistics & Reports', Colors.grey.shade700, () {}),
                  _buildDrawerItem(Icons.menu_book_rounded, 'Health Articles', Colors.grey.shade700, () {}),
                  _buildDrawerItem(Icons.settings_rounded, 'Settings', Colors.grey.shade700, () {}),
                  const Divider(indent: 16, endIndent: 16, height: 20),
                  _buildDrawerItem(Icons.cloud_upload_outlined, 'Backup & Restore', Colors.grey.shade700, () {}),
                  _buildDrawerItem(Icons.help_outline_rounded, 'Help & FAQ', Colors.grey.shade700, () {}),
                  _buildDrawerItem(Icons.info_outline_rounded, 'About App', Colors.grey.shade700, () {}),
                ],
              ),
            ),

            // ---------------------------------------------------------
            // ၃။ Log Out Button & Footer
            // ---------------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD6E0).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.logout_rounded, color: Color(0xFFFF416C)),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Color(0xFFFF416C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your health matters 🤍',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer Item တစ်ခုချင်းစီအတွက် Helper Widget
  Widget _buildDrawerItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: color == const Color(0xFFFF416C) ? FontWeight.bold : FontWeight.w500,
          color: color == const Color(0xFFFF416C) ? color : Colors.black87,
        ),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}