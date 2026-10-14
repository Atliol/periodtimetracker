import 'package:flutter/material.dart';

/// ရက်စွဲအတွက် နူးညံ့ပြီး ခေတ်မီသော blood-drop shape
class BloodDropClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.035);
    path.cubicTo(
      size.width * 0.69,
      size.height * 0.27,
      size.width * 0.94,
      size.height * 0.51,
      size.width * 0.92,
      size.height * 0.70,
    );
    path.cubicTo(
      size.width * 0.90,
      size.height * 0.89,
      size.width * 0.72,
      size.height * 0.98,
      size.width * 0.5,
      size.height * 0.98,
    );
    path.cubicTo(
      size.width * 0.28,
      size.height * 0.98,
      size.width * 0.10,
      size.height * 0.89,
      size.width * 0.08,
      size.height * 0.70,
    );
    path.cubicTo(
      size.width * 0.06,
      size.height * 0.51,
      size.width * 0.31,
      size.height * 0.27,
      size.width * 0.5,
      size.height * 0.035,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BloodDropOutlinePainter extends CustomPainter {
  const _BloodDropOutlinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 1.2;
    final path = BloodDropClipper().getClip(
      Size(size.width - inset * 2, size.height - inset * 2),
    );
    canvas.save();
    canvas.translate(inset, inset);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.7,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BloodDropOutlinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class DateSliderSection extends StatelessWidget {
  final DateTime selectedDate;
  final List<int> periodDays;
  final String todayString;
  final String nextPeriodString;

  const DateSliderSection({
    super.key,
    required this.selectedDate,
    required this.periodDays,
    required this.todayString,
    required this.nextPeriodString,
  });

  @override
  Widget build(BuildContext context) {
    // 🌟 လက်ရှိလ (ဥပမာ- အောက်တိုဘာ ၂၀၂၆) ၏ စုစုပေါင်း ရက်အရေအတွက်ကို ရှာဖွေခြင်း
    final int daysInCurrentMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

    return Container(
      padding: const EdgeInsets.only(bottom: 25, top: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFFD6E0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Color(0xFF5F3542),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ယနေ့: $todayString',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF5F3542),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE94262).withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE94262).withValues(alpha: 0.14),
                    ),
                  ),
                  child: Row(
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
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 🌟 လက်ရှိလ၏ ရက်အကုန် (ဥပမာ- ၁ မှ ၃၁ ရက်အထိ) ကို ဘေးတိုက် Scroll ဆွဲကြည့်နိုင်သော သွေးစက် Slider
          SizedBox(
            height: 75,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: daysInCurrentMonth, // လက်ရှိလ ၏ ရက်အရေအတွက်အပြည့်
              itemBuilder: (context, index) {
                final int dayNumber = index + 1;
                final bool isSelected = dayNumber == selectedDate.day;
                final bool isPeriodDay = periodDays.contains(dayNumber);

                final List<Color> dropGradient = isSelected
                    ? const [Color(0xFFE94360), Color(0xFFB9163D)]
                    : isPeriodDay
                    ? const [Color(0xFFFFA2B0), Color(0xFFF26780)]
                    : const [Color(0xFFFFF0B8), Color(0xFFFFD66E)];

                final Color baseColor = dropGradient.last;
                final Color numberColor = isSelected || isPeriodDay
                    ? Colors.white
                    : const Color(0xFF704452);

                return Semantics(
                  label: '$dayNumber${isPeriodDay ? ', Period day' : ''}',
                  selected: isSelected,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: PhysicalShape(
                          clipper: BloodDropClipper(),
                          color: baseColor,
                          elevation: isSelected ? 5 : 2,
                          shadowColor: baseColor.withValues(alpha: 0.32),
                          child: SizedBox(
                            width: 46,
                            height: 56,
                            child: ClipPath(
                              clipper: BloodDropClipper(),
                              child: CustomPaint(
                                foregroundPainter: isSelected
                                    ? const _BloodDropOutlinePainter(
                                  color: Colors.white,
                                )
                                    : null,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: dropGradient,
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(
                                        left: 12,
                                        top: 10,
                                        child: Transform.rotate(
                                          angle: -0.32,
                                          child: Container(
                                            width: 6,
                                            height: 15,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(
                                                alpha: isSelected ? 0.38 : 0.48,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: Text(
                                          '$dayNumber',
                                          style: TextStyle(
                                            color: numberColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                            height: 1,
                                            shadows: isSelected || isPeriodDay
                                                ? const [
                                              Shadow(
                                                color: Color(0x22A00020),
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                              ),
                                            ]
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (isPeriodDay && !isSelected)
                        const Icon(
                          Icons.water_drop_rounded,
                          size: 8,
                          color: Color(0xFFE94262),
                        )
                      else
                        const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Cycle status card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE94360), Color(0xFFFF7890)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE94360).withValues(alpha: 0.25),
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
                          style: TextStyle(color: Colors.white70, fontSize: 11),
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
                          foregroundColor: const Color(0xFFE94360),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Add Period',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}