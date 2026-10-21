import 'dart:ui';
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
    final int daysInCurrentMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

    return Column(
      children: [
        // သွေးစက် Slider
        SizedBox(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: daysInCurrentMonth,
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
        const SizedBox(height: 25),

        // 🌟 အပြင်ဘက် Container ကို ဖြုတ်ထားပြီး စက်ဝိုင်းဒီဇိုင်းနှင့် ခလုတ်ကို တိုက်ရိုက်ဖော်ပြထားခြင်း
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // အပြင်ဘက် စက်ဝိုင်းတန်း (Progress Track)
                  SizedBox(
                    width: 210,
                    height: 210,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.transparent),
                    ),
                  ),
                  SizedBox(
                    width: 210,
                    height: 210,
                    child: CircularProgressIndicator(
                      value: 0.35,
                      strokeWidth: 10,
                      strokeCap: StrokeCap.round,
                      backgroundColor: Colors.transparent,
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFFFF4081)),
                    ),
                  ),
                  // အလယ်ဗဟိုရှိ ပန်းရောင် စက်ဝိုင်း
                  Container(
                    width: 165,
                    height: 165,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6584), Color(0xFFFF4081)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4081).withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.water_drop_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Period',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 1),
                        const Text(
                          'Day 1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.circle, size: 7, color: Color(0xFF80D8FF)),
                            SizedBox(width: 4),
                            Text(
                              'Fertility',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.5),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.circle, size: 7, color: Color(0xFFFFD54F)),
                            SizedBox(width: 4),
                            Text(
                              'Ovulation',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // Edit Period ခလုတ်
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94360),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 10,
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  '+ Edit Period',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}