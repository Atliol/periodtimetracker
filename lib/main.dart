import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/guide/presentation/screens/guide_page.dart';
import 'features/home/presentation/screens/home_page.dart';
import 'features/home/presentation/screens/app_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  var box = await Hive.openBox('guideBox');

  // Box ထဲမှာ Data လုံးဝမရှိသေးမှသာ JSON မှ Data များကို ထည့်ပေးမည်
  if (box.isEmpty) {
    await loadGuidesFromJson(box);
  }
  runApp(const PeriodTrackerApp());
}
Future<void> loadGuidesFromJson(Box box) async {
  try {
    // JSON ဖိုင်ကို ဖတ်ရှုခြင်း
    final String response = await rootBundle.loadString('assets/data/guides.json');
    final List<dynamic> data = json.decode(response);

    // Hive Box ထဲသို့ Data တစ်ခုချင်းစီ ထည့်သွင်းခြင်း
    for (var item in data) {
      box.add({
        'title': item['title'],
        'content': item['content'],
      });
    }
  } catch (e) {
    debugPrint("Error loading guides: $e");
  }
}


class PeriodTrackerApp extends StatelessWidget {
  const PeriodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Period Tracker & Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFD47A83),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const PeriodTimeScreen(),
    const GuidePage(),
    const CommunityScreen(),
    const AiScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              height: 75,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade900.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGlassTab(0, Icons.home_rounded, 'Home'),
                  _buildGlassTab(1, Icons.calendar_month_rounded, 'Period'),
                  _buildGlassTab(2, Icons.menu_book_rounded, 'Guide'),
                  _buildGlassTab(3, Icons.chat_bubble_rounded, 'Community'),
                  _buildGlassTab(4, Icons.psychology_rounded, 'AI'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTab(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.4) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.white.withValues(alpha: 0.7), width: 1)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// Screen Placeholders
// ---------------------------------------------------------

class PeriodTimeScreen extends StatelessWidget {
  const PeriodTimeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Color(0xFFD47A83),
    body: Center(child: Text('Period Time Page', style: TextStyle(fontSize: 18, color: Colors.white))),
  );
}



class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Color(0xFFD47A83),
    body: Center(child: Text('Community Page', style: TextStyle(fontSize: 18, color: Colors.white))),
  );
}

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Color(0xFFD47A83),
    body: Center(child: Text('AI Page', style: TextStyle(fontSize: 18, color: Colors.white))),
  );
}