import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/month_calendar_widget.dart';
import '../widgets/cycle_overview_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getMonthYearString() {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return "${now.day} ${months[now.month - 1]}, ${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFB6C1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFFFB6C1),
          appBar: const CustomAppBar(title: 'Period Tracker'),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Date Header & Settings
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getMonthYearString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5F3542),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.settings_outlined, size: 18, color: Color(0xFF5F3542)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // 2. Month Calendar Widget
                const MonthCalendarWidget(),
                const SizedBox(height: 20),

                // 3. Cycle Overview Card Widget
                const CycleOverviewCard(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}