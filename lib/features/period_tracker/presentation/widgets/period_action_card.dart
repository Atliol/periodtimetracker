import 'package:flutter/material.dart';

class PeriodActionCard extends StatelessWidget {
  final VoidCallback onTap;

  const PeriodActionCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE94360).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_month_rounded, color: Color(0xFFE94360), size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Period & Cycle Calendar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF5F3542)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ရက်စွဲမှတ်ရန်နှင့် လက္ခဏာများကြည့်ရန် နှိပ်ပါ',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFE94360)),
          ],
        ),
      ),
    );
  }
}