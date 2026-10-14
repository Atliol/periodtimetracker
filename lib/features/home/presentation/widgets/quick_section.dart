import 'package:flutter/material.dart';

class QuickSection extends StatelessWidget {
  const QuickSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickItem(Icons.water_drop_rounded, 'Hydration', Colors.blue, () {}),
          _buildQuickItem(Icons.note_alt_rounded, 'Notes', Colors.pink, () {}),
          _buildQuickItem(Icons.medication_rounded, 'Pills', Colors.orange, () {}),
          _buildQuickItem(Icons.monitor_weight_rounded, 'Weight', Colors.purple, () {}),
          _buildQuickItem(Icons.insights_rounded, 'Insights', Colors.green, () {}),
        ],
      ),
    );
  }

  Widget _buildQuickItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            // 🌟 အိုင်ကွန် အရွယ်အစားကို 26 သို့ တိုးမြှင့်ထားသည်[cite: 27]
            child: Icon(icon, color: color, size: 37),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}