import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late DateTime _selectedDate;
  late List<DateTime> _weekDays;
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDays();

    // 🌟 Marquee Animation အတွက် Controller များ သတ်မှတ်ခြင်း
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
    })..repeat(); // အဆုံးမရှိ ပတ်နေစေရန်
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _generateWeekDays() {
    _weekDays = List.generate(7, (index) {
      return _selectedDate.subtract(Duration(days: 3 - index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD47A83),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFD47A83),
          appBar: const CustomAppBar(title: 'Period Tracker'),
          body: Column(
            children: [
              // ---------------------------------------------------------
              // 🌟 1. Text Marquee Banner (AppBar အောက်တွင် ပြေးနေမည့် စာသား)
              // ---------------------------------------------------------
              Container(
                width: double.infinity,
                height: 36,
                color: const Color(0xFFFFB74D), // သတိပြုမိလွယ်သော လိမ္မော်ရောင်ဖျော့
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.campaign_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(), // User ဆွဲလို့မရအောင် ပိတ်ထားသည်
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
                            SizedBox(width: 100), // စာကြောင်း အစနှင့် အဆုံး ကွာဟချက်
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
                      // ---------------------------------------------------------
                      // 2. အပေါ်ဆုံး ပန်းရောင် Container (ရက်စွဲများ Slider)
                      // ---------------------------------------------------------
                      Container(
                        padding: const EdgeInsets.only(bottom: 25),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD6E0),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(35),
                            bottomRight: Radius.circular(35),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _weekDays.length,
                                itemBuilder: (context, index) {
                                  final date = _weekDays[index];
                                  final isToday = date.year == _selectedDate.year &&
                                      date.month == _selectedDate.month &&
                                      date.day == _selectedDate.day;

                                  return Container(
                                    width: 45,
                                    height: 45,
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: isToday ? const Color(0xFFFF758C) : const Color(0xFFFFE082),
                                      shape: BoxShape.circle,
                                      border: isToday ? Border.all(color: Colors.black, width: 1.5) : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${date.day}',
                                      style: TextStyle(
                                        color: isToday ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Circular Progress Chart Card
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pink.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 90,
                                        height: 90,
                                        child: CircularProgressIndicator(
                                          value: 0.28,
                                          strokeWidth: 9,
                                          backgroundColor: Colors.white24,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Day 2',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'of 28',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Period အခြေအနေ',
                                          style: TextStyle(color: Colors.white70, fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'ပုံမှန်အတိုင်း သွေးဆင်းနေဆဲဖြစ်သည်',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: const Color(0xFFFF416C),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            minimumSize: Size.zero,
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            'Add Period',
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 3. Today Logs & Next Ovulation
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF758C),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'Today Logs',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        CircleAvatar(
                                          radius: 11,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.add, size: 14, color: Color(0xFFFF758C)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    const Text('Detailed symptom logs', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: const [
                                        Icon(Icons.sentiment_satisfied, color: Colors.amber, size: 20),
                                        SizedBox(width: 4),
                                        Icon(Icons.shield, color: Colors.blue, size: 20),
                                        SizedBox(width: 4),
                                        Icon(Icons.water_drop, color: Colors.green, size: 20),
                                        SizedBox(width: 4),
                                        Text('13+', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFB74D),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text('Apr 2025', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                    ),
                                    SizedBox(height: 2),
                                    Icon(Icons.egg, color: Colors.white, size: 20),
                                    SizedBox(height: 6),
                                    Text('Next Ovulation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                    SizedBox(height: 4),
                                    Text('04/04 - 09/04', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 4. Cycle Overview
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Cycle Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                                Text('Show all', style: TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Ongoing Cycle', style: TextStyle(color: Colors.black54, fontSize: 13)),
                                Text('25 March - 26 March', style: TextStyle(color: Colors.black54, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: 0.4,
                              backgroundColor: Colors.grey.shade200,
                              color: const Color(0xFFFF416C),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                Icon(Icons.water_drop, color: Colors.pink, size: 18),
                                Icon(Icons.water_drop, color: Colors.blue, size: 18),
                                Icon(Icons.water_drop, color: Colors.green, size: 18),
                                Icon(Icons.water_drop, color: Colors.amber, size: 18),
                                Icon(Icons.water_drop, color: Colors.blue, size: 18),
                                Icon(Icons.water_drop, color: Colors.grey, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
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