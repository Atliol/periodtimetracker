import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/models/community_model.dart';
import '../widgets/community_stories_widget.dart';
import '../widgets/community_chat_list_widget.dart';
import 'all_users_page.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  String _selectedFilter = 'All';

  final List<Map<String, String>> _stories = [
    {'name': 'မေမီ', 'image': 'https://cdn-icons-png.flaticon.com/512/2922/2922510.png'},
    {'name': 'သဇင်', 'image': 'https://cdn-icons-png.flaticon.com/512/4140/4140047.png'},
    {'name': 'ထက်ထက်', 'image': 'https://cdn-icons-png.flaticon.com/512/1946/1946429.png'},
    {'name': 'ဆုေမာင်', 'image': 'https://cdn-icons-png.flaticon.com/512/2922/2922561.png'},
    {'name': 'စုစု', 'image': 'https://cdn-icons-png.flaticon.com/512/4140/4140037.png'},
  ];

  final List<CommunityItem> _chats = [
    CommunityItem(
      id: '1',
      name: 'ရာသီလာစဉ် အကြံပြုဆွေးနွေးရန်',
      message: 'ဒီလ နာကျင်ကိုက်ခဲမှု သက်သာအောင် ဘာတွေလုပ်သင့်လဲ ရှင့်?',
      time: '12 mins',
      avatarUrl: 'https://cdn-icons-png.flaticon.com/512/2922/2922510.png',
      isUnread: true,
      isOnline: true,
    ),
    CommunityItem(
      id: '2',
      name: 'Dr. နှင်းဆီ (ကျန်းမာရေးမေးခွန်းများ)',
      message: 'ရေများများသောက်ပေးဖို့နဲ့ အနားယူဖို့ မမေ့ပါနဲ့နော်။',
      time: '35 mins',
      avatarUrl: 'https://cdn-icons-png.flaticon.com/512/4140/4140047.png',
      isUnread: false,
      isOnline: true,
    ),
    CommunityItem(
      id: '3',
      name: 'ယောဂနှင့် ကိုယ်လက်လှုပ်ရှားမှု',
      message: 'ဒီနေ့ ညနေ ၅ နာရီ ယောဂလေ့ကျင့်ခန်း အတူလုပ်ကြမယ်လေ။',
      time: '1 hour',
      avatarUrl: 'https://cdn-icons-png.flaticon.com/512/2647/2647625.png',
      isUnread: true,
      isOnline: false,
    ),
    CommunityItem(
      id: '4',
      name: 'မိခင်နှင့် ကလေးစောင့်ရှောက်မှု',
      message: 'ဗိုက်ထဲက ရင်သွေးလေးအတွက် အာဟာရပြည့်တာတွေ စားဖြစ်ရဲ့လား?',
      time: '3 hours',
      avatarUrl: 'https://cdn-icons-png.flaticon.com/512/3081/3082060.png',
      isUnread: false,
      isOnline: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFB6C1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFFFB6C1),
          appBar: CustomAppBar(
            title: 'Community & Chats',
            actions: [
              // 1. Add / Search Friends (Requests အားလုံးပါဝင်သည့် စာမျက်နှာ)
              IconButton(
                icon: const Icon(Icons.person_add_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AllUsersPage()),
                  );
                },
              ),
              // 2. Edit Profile Button
              IconButton(
                icon: const Icon(Icons.account_circle_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                },
              ),
              // 3. Logout Button (ပြန်လည်ထည့်သွင်းပေးထားပါသည်)
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              CommunityStoriesWidget(stories: _stories),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: ['All', 'Discussions', 'Groups', 'Experts'].map((filter) {
                    final bool isSelected = _selectedFilter == filter;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = filter),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFFE94360) : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              CommunityChatListWidget(chats: _chats),
            ],
          ),
        ),
      ),
    );
  }
}