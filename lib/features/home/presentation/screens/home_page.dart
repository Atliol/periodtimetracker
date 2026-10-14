import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/quick_section.dart';
import '../widgets/cycle_overview.dart';
import '../widgets/date_slider_section.dart';
import '../widgets/promo_banner_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late DateTime _selectedDate;
  late List<DateTime> _weekDays;
  late ScrollController _scrollController;
  late AnimationController _animationController; // 🌟 AnimationController အသစ်ထည့်သွင်းသည်

  final List<int> _periodDays = [13, 14, 15, 16, 17];
  final int _nextPeriodStartDay = 13;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDays();

    _scrollController = ScrollController();

    // 🌟 Marquee စာသား အလိုအလျောက် ရွေ့လျားစေမည့် Animation Controller
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
    _animationController.dispose(); // 🌟 Controller ကို ဖျက်ရန်
    super.dispose();
  }

  void _generateWeekDays() {
    _weekDays = List.generate(7, (index) {
      return _selectedDate.subtract(Duration(days: 3 - index));
    });
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

    return Container(
      color: const Color(0xFFD47A83),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFD47A83),
          appBar: const CustomAppBar(title: 'Period Tracker'),
          body: Column(
            children: [
              // 1. Text Marquee Banner (အမြဲတမ်း ရွေ့လျားနေမည့် Banner)
              Container(
                width: double.infinity,
                height: 36,
                color: const Color(0xFFFFB74D),
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
                              '🌸 ကျန်းမာရေး သတိပြုစရာ - ရာသီလာစဉ် ကာလအတွင်း ရေများများသောက်ပေးပါ၊ အနားယူပါ၊ နာကျင်ပါက ရေနွေးအိတ် ကပ်ပေးပါ 🌸   |   🌸 Period Tracker App မှ နွေးထွေးစွာ ကြိုဆိုပါတယ်။ 🌸',
                              style: TextStyle(
                                color: Colors.white,
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

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // 3. Date Slider Section Widget
                      DateSliderSection(
                        selectedDate: _selectedDate,
                        periodDays: _periodDays,
                        todayString: todayString,
                        nextPeriodString: nextPeriodString,
                      ),
                      const SizedBox(height: 10),
                      // 2. Promo Banner Carousel Widget
                      //const PromoBannerSection(),
                      const SizedBox(height: 10),
                      // 4. Quick Section Widget
                      const QuickSection(),
                      const SizedBox(height: 10),
                      // 6. Cycle Overview Widget
                      const CycleOverview(),


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}