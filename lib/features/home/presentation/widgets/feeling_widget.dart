import 'dart:ui';
import 'package:flutter/material.dart';

class FeelingWidget extends StatefulWidget {
  const FeelingWidget({super.key});

  @override
  State<FeelingWidget> createState() => _FeelingWidgetState();
}

class _FeelingWidgetState extends State<FeelingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // 🌟 Sticker Image ကို အမြဲတမ်း အကန့်အသတ်မရှိ လည်ပတ်နေစေရန် AnimationController သတ်မှတ်ခြင်း
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          // 1. Feeling Today Card (Glassmorphic + Rotating Baby Fetus Sticker Image)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Feeling Today',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Add logs',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 🌟 ဗိုက်ထဲရှိ ကလေးငယ် ပုံစံ 3D Cute Baby Sticker Image + Rotating Effect
                      Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: RotationTransition(
                            turns: _rotationController,
                            child: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/6599/6599087.png', // Transparent Cute Fetus / Baby Sticker
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.child_care_rounded,
                                  color: Color(0xFFE94360), size: 48),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE94360),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () {},
                          child: const Text(
                            '+ Add',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 2. အားကစားလုပ်နည်း Card (Glassmorphic + Girl Exercise Icon)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'အားကစားလုပ်နည်း',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Exercise & Yoga',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 🌟 မိန်းကလေး အားကစားလုပ်နေသည့် Image Sticker
                      Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: Image.network(
                            'https://cdn-icons-png.flaticon.com/512/2647/2647625.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.self_improvement_rounded,
                                color: Color(0xFF8A5CF5), size: 48),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8A5CF5),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () {},
                          child: const Text(
                            '+ View',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}