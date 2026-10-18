import 'package:flutter/material.dart';
import 'dart:ui';

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
          // 🌟 Glassmorphism Effect for Quick Icons
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.35),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 30),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
            ),
          ),
        ],
      ),
    );
  }
}