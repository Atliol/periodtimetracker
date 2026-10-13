import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      // AppBar ကို အသုံးပြု၍ အပေါ်ဆုံး කොටပိုင်းကို တည်ဆောက်ခြင်း
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD6E0),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {
            // Drawer ဖွင့်ရန် သို့မဟုတ် Action လုပ်ရန်
          },
        ),
        title: const Text(
          '26 March',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.autorenew, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------
            // ၁။ အပေါ်ဆုံး ပန်းရောင် Container (ရက်စွဲများ Slider နှင့် Status Card)
            // ---------------------------------------------------------
            Container(
              padding: const EdgeInsets.only(bottom: 25),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD6E0), // Soft Pink Header Background
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Horizontal Dates Slider (23 မှ 29 ထိ)
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildDateBubble('23', false),
                        _buildDateBubble('24', false),
                        _buildDateBubble('25', false),
                        _buildDateBubble('26', true), // Selected Date (Active)
                        _buildDateBubble('27', false),
                        _buildDateBubble('28', false),
                        _buildDateBubble('29', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Main Period Status Card (Day 2 of the period)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.favorite, color: Colors.white, size: 28),
                        SizedBox(width: 12),
                        Text(
                          'Day 2 of the period',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Add Period Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFF416C),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      'Add Period',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // ၂။ အလယ်ပိုင်း ကတ်နှစ်ခု (Today Logs & Next Ovulation)
            // ---------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  // Today Logs Card (Pink)
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
                                  fontSize: 16,
                                ),
                              ),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.add, size: 16, color: Color(0xFFFF758C)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Detailed symptom logs',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: const [
                              Icon(Icons.sentiment_satisfied, color: Colors.amber, size: 22),
                              SizedBox(width: 4),
                              Icon(Icons.shield, color: Colors.blue, size: 22),
                              SizedBox(width: 4),
                              Icon(Icons.water_drop, color: Colors.green, size: 22),
                              SizedBox(width: 4),
                              Text(
                                '13+',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Next Ovulation Card (Orange/Yellow)
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
                            child: Text(
                              'Apr 2025',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 4),
                          Icon(Icons.egg, color: Colors.white, size: 22),
                          SizedBox(height: 8),
                          Text(
                            'Next Ovulation',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '04/04 - 09/04',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // ၃။ အောက်ဆုံး Cycle Overview ပိုင်း
            // ---------------------------------------------------------
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
                      Text(
                        'Cycle Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Show all',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                  // Progress Bar
                  LinearProgressIndicator(
                    value: 0.4,
                    backgroundColor: Colors.grey.shade200,
                    color: const Color(0xFFFF416C),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 15),
                  // Small icons row at bottom
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
            const SizedBox(height: 100), // Bottom navbar အတွက် နေရာချန်ရန်
          ],
        ),
      ),
    );
  }

  // ရက်စွဲ Bubbles များအတွက် Helper Widget
  Widget _buildDateBubble(String day, bool isSelected) {
    return Container(
      width: 45,
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF758C) : const Color(0xFFFFE082),
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: Colors.black, width: 1.5)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        day,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}