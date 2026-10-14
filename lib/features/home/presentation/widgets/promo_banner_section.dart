import 'dart:async';
import 'package:flutter/material.dart';

class PromoBannerSection extends StatefulWidget {
  const PromoBannerSection({super.key});

  @override
  State<PromoBannerSection> createState() => _PromoBannerSectionState();
}

class _PromoBannerSectionState extends State<PromoBannerSection> {
  final PageController _bannerPageController = PageController();
  late Timer _bannerTimer;
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_bannerPageController.hasClients) return;
      final nextPage = (_currentBannerIndex + 1) % 5;
      _bannerPageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _bannerPageController.dispose();
    super.dispose();
  }

  Widget _buildPromoBanner({
    required String eyebrow,
    required String title,
    required String subtitle,
    required IconData icon,
    required IconData trailingIcon,
    required List<Color> gradientColors,
    required Color accentColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.45),
            width: 0.8,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 9, 16, 17),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.88),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 27),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    eyebrow,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 8,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF61233D),
                      fontSize: 13,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8B5366),
                      fontSize: 10,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.82),
                shape: BoxShape.circle,
              ),
              child: Icon(trailingIcon, color: accentColor, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final banners = <Widget>[
      _buildPromoBanner(
        eyebrow: 'PERIOD CARE GUIDE',
        title: 'ရာသီလာချိန် ကိုယ့်ကိုယ်ကို ဂရုစိုက်ပါ',
        subtitle: 'ကျန်းမာရေးအတွက် အသုံးဝင်တဲ့ အကြံပြုချက်များ',
        icon: Icons.spa_rounded,
        trailingIcon: Icons.favorite_rounded,
        gradientColors: const [Color(0xFFFFE6EC), Color(0xFFFFC8D5)],
        accentColor: const Color(0xFFD94F79),
      ),
      _buildPromoBanner(
        eyebrow: 'CYCLE INSIGHTS',
        title: 'သင့် Cycle ကို နားလည်လိုက်ပါ',
        subtitle: 'ရာသီစက်ဝန်းမှတ်တမ်းကို ပြန်လည်လေ့လာပါ',
        icon: Icons.auto_graph_rounded,
        trailingIcon: Icons.chevron_right_rounded,
        gradientColors: const [Color(0xFFFFE9E0), Color(0xFFFFD1C7)],
        accentColor: const Color(0xFFC85E68),
      ),
      _buildPromoBanner(
        eyebrow: 'DAILY SYMPTOM LOG',
        title: 'ယနေ့ခံစားချက်တွေ မှတ်တမ်းတင်ပါ',
        subtitle: 'Mood နဲ့ လက္ခဏာတွေကို နေ့စဉ် မှတ်ထားပါ',
        icon: Icons.edit_note_rounded,
        trailingIcon: Icons.chevron_right_rounded,
        gradientColors: const [Color(0xFFFFE6F4), Color(0xFFFFD1E8)],
        accentColor: const Color(0xFFC34D87),
      ),
      _buildPromoBanner(
        eyebrow: 'GENTLE REMINDERS',
        title: 'ကိုယ့်အတွက် သတိပေးချက်များ',
        subtitle: 'နေ့စဉ် ကိုယ်တိုင်ဂရုစိုက်ဖို့ မမေ့ပါနဲ့',
        icon: Icons.notifications_active_rounded,
        trailingIcon: Icons.chevron_right_rounded,
        gradientColors: const [Color(0xFFFFE7E8), Color(0xFFFFD5D7)],
        accentColor: const Color(0xFFD84F68),
      ),
      _buildPromoBanner(
        eyebrow: 'SELF CARE MOMENT',
        title: 'ကိုယ့်ကျန်းမာရေးကို ဦးစားပေးပါ',
        subtitle: 'ရေများများသောက်ပြီး အနားယူပေးပါ',
        icon: Icons.favorite_rounded,
        trailingIcon: Icons.chevron_right_rounded,
        gradientColors: const [Color(0xFFFFE6EC), Color(0xFFFFD9E5)],
        accentColor: const Color(0xFFD94F79),
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 88,
          child: PageView(
            controller: _bannerPageController,
            onPageChanged: (index) {
              if (mounted) setState(() => _currentBannerIndex = index);
            },
            children: banners,
          ),
        ),
        Container(
          height: 13,
          width: double.infinity,
          color: const Color(0xFFD47A83),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final isActive = index == _currentBannerIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 15 : 5,
                height: 5,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}