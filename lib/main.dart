import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'features/ai_assistant/presentation/screens/ai_page.dart';
import 'features/community/presentation/screens/community_page.dart';
import 'features/guide/presentation/screens/guide_page.dart';
import 'features/home/presentation/screens/home_page.dart';
import 'features/home/presentation/screens/app_drawer.dart';
import 'core/widgets/period_bottom_nav_bar.dart'; // 🌟 Bottom Nav Bar ကို import လုပ်ခြင်း
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/period_tracker/presentation/screens/home_screen.dart';
import 'features/period_tracker/domain/cycle_model.dart';
import 'features/period_tracker/data/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(CycleModelAdapter());
  }

  await Hive.openBox<CycleModel>(
    LocalStorageService.boxName,
  );

  var box = await Hive.openBox('guideBox');

  if (box.isEmpty) {
    await loadGuidesFromJson(box);
  }

  runApp(const PeriodTrackerApp());
}

Future<void> loadGuidesFromJson(Box box) async {
  try {
    final String response = await rootBundle.loadString('assets/data/guides.json');
    final List<dynamic> data = json.decode(response);

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
  final int initialIndex; // 🌟 ဝင်ရောက်မည့် Tab ၏ Index များကို လက်ခံရန်
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // 🌟 ပေးလိုက်သော Index ဖြင့် စတင်ခြင်း
  }

  final List<Widget> _pages = [
    const HomePage(),
    const HomeScreen(),
    const GuidePage(),
    const CommunityPage(),
    const AiPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: PeriodBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}