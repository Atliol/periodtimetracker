import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/services/community_chat_service.dart';
import '../../data/services/community_media_service.dart';
import 'chat_room_page.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  int _selectedTab = 0; // 0 = All Users, 1 = Requests
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  String? get _currentUid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> _sendFriendRequest(
    QueryDocumentSnapshot<Map<String, dynamic>> target,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final currentProfile =
          (await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get())
              .data();
      await FirebaseFirestore.instance
          .collection('friend_requests')
          .doc('${user.uid}_${target.id}')
          .set({
            'fromUid': user.uid,
            'toUid': target.id,
            'fromName': currentProfile?['name'] ?? user.displayName ?? 'Member',
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _resolveRequest(
    QueryDocumentSnapshot<Map<String, dynamic>> request, {
    required bool accept,
  }) async {
    final uid = _currentUid;
    if (uid == null) return;

    try {
      final data = request.data();
      final senderUid = data['fromUid'] as String?;
      final batch = FirebaseFirestore.instance.batch();
      batch.update(request.reference, {
        'status': accept ? 'accepted' : 'rejected',
        'respondedAt': FieldValue.serverTimestamp(),
      });
      if (accept && senderUid != null) {
        batch.set(
          FirebaseFirestore.instance.collection('users').doc(uid),
          {
            'friends': FieldValue.arrayUnion([senderUid]),
          },
          SetOptions(merge: true),
        );
        batch.set(
          FirebaseFirestore.instance.collection('users').doc(senderUid),
          {
            'friends': FieldValue.arrayUnion([uid]),
          },
          SetOptions(merge: true),
        );
      }
      await batch.commit();
    } catch (error) {
      _showError(error);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
    );
  }

  Future<void> _openPrivateChat(
    QueryDocumentSnapshot<Map<String, dynamic>> target,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final chatId = await CommunityChatService.openPrivateChat(
        currentUid: user.uid,
        otherUid: target.id,
      );
      if (!mounted) return;
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomPage(
            chatId: chatId,
            title: target.data()['name'] as String? ?? 'Community member',
            isGroup: false,
            otherUserId: target.id,
          ),
        ),
      );
    } catch (error) {
      _showError(error);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = _currentUid;
    if (uid == null) {
      return const Center(
        child: Text(
          'အကောင့်ဝင်ရန် လိုအပ်ပါသည်',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      color: const Color(0xFFFFB6C1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFFFB6C1),
          appBar: const CustomAppBar(
            title: 'Friends & Requests',
            showBackButton: true,
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('friend_requests')
                .where('toUid', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              final incomingRequests =
                  snapshot.data?.docs
                      .where((request) => request.data()['status'] == 'pending')
                      .toList() ??
                  [];
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTabButton(label: 'All Users', index: 0),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTabButton(
                            label: 'Requests (${incomingRequests.length})',
                            index: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _selectedTab == 0
                        ? _buildAllUsersList(incomingRequests)
                        : snapshot.hasError
                        ? const Center(
                            child: Text(
                              'Requests များကို ဖတ်မရပါ',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : _buildRequestsList(incomingRequests),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({required String label, required int index}) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFE94360) : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllUsersList(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> incomingRequests,
  ) {
    final uid = _currentUid!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _searchController,
            onChanged: (value) =>
                setState(() => _searchText = value.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search people',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchText.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchText = '');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'အသုံးပြုသူများကို ဖတ်မရပါ',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              final users =
                  snapshot.data?.docs.where((user) {
                    if (user.id == uid) return false;
                    if (_searchText.isEmpty) return true;
                    final data = user.data();
                    final name = (data['name'] as String? ?? '').toLowerCase();
                    final email = (data['email'] as String? ?? '')
                        .toLowerCase();
                    return name.contains(_searchText) ||
                        email.contains(_searchText);
                  }).toList() ??
                  [];
              if (users.isEmpty) {
                return Center(
                  child: Text(
                    _searchText.isEmpty
                        ? 'အသုံးပြုသူများ မရှိသေးပါ'
                        : 'မတွေ့ရှိပါ',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }

              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('friend_requests')
                    .where('fromUid', isEqualTo: uid)
                    .snapshots(),
                builder: (context, outgoingSnapshot) {
                  final outgoing = {
                    for (final request in outgoingSnapshot.data?.docs ?? [])
                      request.data()['toUid'] as String? ?? '':
                          request.data()['status'] as String? ?? '',
                  };
                  final incomingByUid = {
                    for (final request in incomingRequests)
                      request.data()['fromUid'] as String? ?? '': request,
                  };

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final userDoc = users[index];
                      final user = userDoc.data();
                      final friends = user['friends'] as List<dynamic>? ?? [];
                      final incoming = incomingByUid[userDoc.id];
                      final isFriend = friends.contains(uid);
                      final outgoingStatus = outgoing[userDoc.id];
                      final hasPendingOutgoing = outgoingStatus == 'pending';
                      final buttonLabel = isFriend
                          ? 'Message'
                          : incoming != null
                          ? 'Accept'
                          : hasPendingOutgoing
                          ? 'Requested'
                          : 'Add Friend';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        CommunityMediaService.imageProvider(
                                          user['image'] as String?,
                                        ),
                                    child:
                                        CommunityMediaService.imageProvider(
                                              user['image'] as String?,
                                            ) ==
                                            null
                                        ? const Icon(
                                            Icons.person_rounded,
                                            color: Color(0xFFE94360),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['name'] as String? ?? 'No Name',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          user['role'] as String? ??
                                              'General User',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE94360),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                    ),
                                    onPressed: isFriend
                                        ? () => _openPrivateChat(userDoc)
                                        : hasPendingOutgoing
                                        ? null
                                        : incoming != null
                                        ? () => _resolveRequest(
                                            incoming,
                                            accept: true,
                                          )
                                        : () => _sendFriendRequest(userDoc),
                                    child: Text(
                                      buttonLabel,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsList(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> requests,
  ) {
    if (requests.isEmpty) {
      return const Center(
        child: Text(
          'Friend Request များမရှိပါ',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        final req = request.data();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(req['fromUid'] as String? ?? '')
                          .snapshots(),
                      builder: (context, profileSnapshot) {
                        final photo =
                            profileSnapshot.data?.data()?['image'] as String?;
                        return CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white,
                          backgroundImage: CommunityMediaService.imageProvider(
                            photo,
                          ),
                          child:
                              CommunityMediaService.imageProvider(photo) == null
                              ? const Icon(
                                  Icons.person_rounded,
                                  color: Color(0xFFE94360),
                                )
                              : null,
                        );
                      },
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req['fromName'] as String? ?? 'Community member',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Friend request',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () =>
                              _resolveRequest(request, accept: true),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.cancel_rounded,
                            color: Colors.white70,
                            size: 30,
                          ),
                          onPressed: () =>
                              _resolveRequest(request, accept: false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
