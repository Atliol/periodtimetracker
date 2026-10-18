import 'package:flutter/material.dart';
import 'dart:ui'; // 🌟 BackdropFilter အတွက် လိုအပ်သည်
import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/feeling_widget.dart';
import '../widgets/quick_section.dart';
import '../widgets/cycle_overview.dart';
import '../widgets/date_slider_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late DateTime _selectedDate;
  late ScrollController _scrollController;
  late AnimationController _animationController;

  final List<int> _periodDays = [13, 14, 15, 16, 17];
  final int _nextPeriodStartDay = 13;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _scrollController = ScrollController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..addListener(() {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _animationController.value * maxScroll;
        _scrollController.jumpTo(currentScroll);
      }
    })..repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final String todayString = "${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}";
    final String nextPeriodString = "$_nextPeriodStartDay ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}";

    return Scaffold(
      backgroundColor: const Color(0xFFF8BBD0), // Soft Pink Background
      // 🌟 AppBar ၏ ညာဘက်တွင် တောင်းဆိုထားသော ပုံစံအတိုင်း Period Badge ထည့်သွင်းထားသည်
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Period Tracker',
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE94262).withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE94262).withValues(alpha: 0.14),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.water_drop_rounded,
                        size: 14,
                        color: Color(0xFFE94262),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Period: $nextPeriodString',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFFE94262),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 🌟 နောက်ခံတွင် Glassmorphism ပေါ်လွင်စေရန် အရောင်စုံ Gradient အဝိုင်းများ ထည့်သွင်းခြင်း
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pinkAccent.withOpacity(0.2),
              ),
            ),
          ),

          // ပင်မ အကြောင်းအရာများ
          Column(
            children: [
              // Glassmorphism Marquee Banner
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: double.infinity,
                    height: 36,
                    color: Colors.white.withOpacity(0.2),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.campaign_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Row(
                              children: const [
                                Text(
                                  '🌸 ကျန်းမာရေး သတိပြုစရာ - ရာသီလာစဉ် ကာလအတွင်း ရေများများသောက်ပေးပါ၊ အနားယူပါ 🌸   |   🌸 Period Tracker App မှ ကြိုဆိုပါတယ် 🌸',
                                  style: TextStyle(
                                    color: Color(0xFF7C0E34),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: 100),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      DateSliderSection(
                        selectedDate: _selectedDate,
                        periodDays: _periodDays,
                        todayString: todayString,
                        nextPeriodString: nextPeriodString,
                      ),
                      const SizedBox(height: 15),
                      const QuickSection(),
                      const SizedBox(height: 15),
                      const CycleOverview(),
                      const SizedBox(height: 20),
                      const FeelingWidget(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}