import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import 'guide_category_page.dart';
import 'music_player_page.dart';
import 'symptom_log_page.dart'; // 🌟 Symptom Log Page ကို import လုပ်ရန်

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'ကျန်းမာရေး အကြံပြုချက်အသစ်များ',
      'subtitle': 'ရာသီလာစဉ် ကိုယ်လက်လှုပ်ရှားမှုများကို လေ့လာပါ',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xFFFF758C),
      'actionText': 'ဖတ်ရှုရန်',
    },
    {
      'title': 'အထူးကမ်းလှမ်းချက်',
      'subtitle': 'ပရီမီယံ အင်္ဂါရပ်များကို အခမဲ့ စမ်းသပ်သုံးစွဲပါ',
      'icon': Icons.star_rounded,
      'color': const Color(0xFFFFB74D),
      'actionText': 'ကြည့်မည်',
    },
    {
      'title': 'AI Assistant ဖြင့် မေးမြန်းပါ',
      'subtitle': 'သင့်ရဲ့ ကျန်းမာရေး သံသယများကို ချက်ချင်းမေးမြန်းပါ',
      'icon': Icons.chat_bubble_rounded,
      'color': const Color(0xFFAB47BC),
      'actionText': 'စတင်ရန်',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD47A83),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFD47A83),
          appBar: const CustomAppBar(title: 'Period Guide & Tips'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Slider
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _banners.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      final banner = _banners[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [banner['color'], banner['color'].withValues(alpha: 0.8)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(banner['title'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(banner['subtitle'],
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: banner['color'],
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      minimumSize: Size.zero,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: () {},
                                    child: Text(banner['actionText'],
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(banner['icon'], color: Colors.white, size: 36),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _banners.length,
                        (index) => Container(
                      width: _currentPage == index ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.white : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                const Text(
                  'ကျန်းမာရေး လမ်းညွှန်ချက်များနှင့် အနားယူရန်',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Row ကတ် ၃ ခု (ဆောင်ရန်၊ ရှောင်ရန်၊ Music)
                Row(
                  children: [
                    Expanded(
                      child: _buildGridFeatureCard(
                        context,
                        title: 'ဆောင်ရန်',
                        icon: Icons.check_circle_rounded,
                        gradientColors: [const Color(0xFF4CAF50), const Color(0xFF81C784)],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GuideCategoryPage(
                                categoryKey: 'do',
                                categoryTitle: 'ဆောင်ရန် အချက်များ (Dos)',
                                headerColor: Color(0xFF4CAF50),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildGridFeatureCard(
                        context,
                        title: 'ရှောင်ရန်',
                        icon: Icons.cancel_rounded,
                        gradientColors: [const Color(0xFFE53935), const Color(0xFFEF5350)],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GuideCategoryPage(
                                categoryKey: 'dont',
                                categoryTitle: "ရှောင်ရန် အချက်များ (Don'ts)",
                                headerColor: Color(0xFFE53935),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildGridFeatureCard(
                        context,
                        title: 'Music',
                        icon: Icons.headset_rounded,
                        gradientColors: [const Color(0xFF8E24AA), const Color(0xFFAB47BC)],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MusicPlayerPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 🌟 အောက်ဆုံးတွင် Column ပုံစံဖြင့် Symptom & Cycle Tracker ကတ်အသစ် ထည့်သွင်းခြင်း
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SymptomLogPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(18),
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
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 18),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ရာသီနှင့် ကျန်းမာရေး မှတ်တမ်း',
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'ပြောင်းလဲနေသော ရာသီစက်ဝန်းနှင့် ရောဂါအခြေအနေများကို မှတ်ပါ။',
                                style: TextStyle(fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridFeatureCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required List<Color> gradientColors,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 125,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}