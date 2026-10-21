import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/services/community_chat_service.dart';
import '../../data/services/community_media_service.dart';
import 'all_users_page.dart';
import 'chat_room_page.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';
import 'user_profile_page.dart';
import '../widgets/community_notes_widget.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  bool _isCreatingGroup = false;

  Future<void> _writeNote() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    final profile = (await userRef.get()).data();
    if (!mounted) return;
    final controller = TextEditingController(
      text: profile?['note'] as String? ?? '',
    );
    final note = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Your note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 60,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Share a short status',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, ''),
            child: const Text('Clear'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Post'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (note == null) return;

    try {
      if (note.isEmpty) {
        await userRef.set({
          'note': FieldValue.delete(),
          'noteUpdatedAt': FieldValue.delete(),
          'noteExpiresAt': FieldValue.delete(),
        }, SetOptions(merge: true));
      } else {
        await userRef.set({
          'note': note,
          'noteUpdatedAt': FieldValue.serverTimestamp(),
          'noteExpiresAt': Timestamp.fromDate(
            DateTime.now().add(const Duration(hours: 24)),
          ),
        }, SetOptions(merge: true));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Note Error: $error')));
      }
    }
  }

  Future<void> _createGroup() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final nameController = TextEditingController();
    final selectedMembers = <String>{};
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Create group'),
          content: SizedBox(
            width: double.maxFinite,
            height: 360,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  onChanged: (_) => setDialogState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Group name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('friends', arrayContains: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final friends = snapshot.data?.docs ?? [];
                      if (friends.isEmpty) {
                        return const Center(
                          child: Text('Add friends before creating a group.'),
                        );
                      }
                      return ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          final friend = friends[index];
                          final data = friend.data();
                          final isSelected = selectedMembers.contains(
                            friend.id,
                          );
                          return CheckboxListTile(
                            value: isSelected,
                            title: Text(data['name'] as String? ?? 'Member'),
                            secondary: CircleAvatar(
                              backgroundImage:
                                  CommunityMediaService.imageProvider(
                                    data['image'] as String?,
                                  ),
                              child:
                                  CommunityMediaService.imageProvider(
                                        data['image'] as String?,
                                      ) ==
                                      null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            onChanged: (value) => setDialogState(() {
                              if (value == true) {
                                selectedMembers.add(friend.id);
                              } else {
                                selectedMembers.remove(friend.id);
                              }
                            }),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed:
                  nameController.text.trim().isEmpty || selectedMembers.isEmpty
                  ? null
                  : () => Navigator.pop(dialogContext, {
                      'name': nameController.text.trim(),
                      'members': selectedMembers.toList(),
                    }),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
    nameController.dispose();
    if (result == null || !mounted) return;

    setState(() => _isCreatingGroup = true);
    try {
      final chatId = await CommunityChatService.createGroupChat(
        name: result['name'] as String,
        participantUids: [user.uid, ...(result['members'] as List<String>)],
        createdBy: user.uid,
      );
      if (!mounted) return;
      await _openChat(chatId, result['name'] as String, isGroup: true);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Group Error: $error')));
      }
    } finally {
      if (mounted) setState(() => _isCreatingGroup = false);
    }
  }

  Future<void> _openChat(
    String chatId,
    String title, {
    required bool isGroup,
    String? otherUserId,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomPage(
          chatId: chatId,
          title: title,
          isGroup: isGroup,
          otherUserId: otherUserId,
        ),
      ),
    );
  }

  String _formatChatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final difference = DateTime.now().difference(timestamp.toDate());
    if (difference.inMinutes < 1) return 'now';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}h';
    return '${difference.inDays}d';
  }

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
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Container(
      color: const Color(0xFFFFB6C1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFFFB6C1),
          appBar: CustomAppBar(
            title: 'Community Chats',
            actions: [
              IconButton(
                tooltip: 'Create group',
                icon: const Icon(Icons.group_add_rounded, color: Colors.white),
                onPressed: _isCreatingGroup ? null : _createGroup,
              ),
              IconButton(
                tooltip: 'Find friends',
                icon: const Icon(Icons.person_add_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllUsersPage(),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Edit profile',
                icon: const Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Log out',
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
          body: uid == null
              ? const Center(
                  child: Text(
                    'အကောင့်ဝင်ရန် လိုအပ်ပါသည်',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Column(
                  children: [
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(height: 112);
                        }
                        return CommunityNotesWidget(
                          users: snapshot.data!.docs,
                          currentUid: uid,
                          onAddNote: _writeNote,
                          onOpenProfile: (userId) => Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserProfilePage(userId: userId),
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .where('participants', arrayContains: uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                'Chats များကို ဖတ်မရပါ',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }

                          final chats = snapshot.data?.docs.toList() ?? [];
                          chats.sort((first, second) {
                            final firstTime =
                                (first.data()['updatedAt'] as Timestamp?)
                                    ?.toDate() ??
                                DateTime.fromMillisecondsSinceEpoch(0);
                            final secondTime =
                                (second.data()['updatedAt'] as Timestamp?)
                                    ?.toDate() ??
                                DateTime.fromMillisecondsSinceEpoch(0);
                            return secondTime.compareTo(firstTime);
                          });

                          if (chats.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.forum_outlined,
                                      color: Colors.white,
                                      size: 54,
                                    ),
                                    const SizedBox(height: 14),
                                    const Text(
                                      'စကားပြောရန် chat မရှိသေးပါ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    FilledButton.icon(
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AllUsersPage(),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.person_search_rounded,
                                      ),
                                      label: const Text('Find friends'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                            itemCount: chats.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final chat = chats[index];
                              final data = chat.data();
                              final isGroup = data['type'] == 'group';
                              final participants = List<String>.from(
                                data['participants'] as List? ?? [],
                              );
                              final otherUid = participants.firstWhere(
                                (participant) => participant != uid,
                                orElse: () => '',
                              );
                              final participantInfo =
                                  data['participantInfo']
                                      as Map<String, dynamic>? ??
                                  {};
                              final otherInfo =
                                  participantInfo[otherUid]
                                      as Map<String, dynamic>? ??
                                  {};
                              final title = isGroup
                                  ? data['name'] as String? ?? 'Group chat'
                                  : otherInfo['name'] as String? ??
                                        'Community member';
                              final image =
                                  (isGroup
                                      ? data['image'] as String?
                                      : otherInfo['image'] as String?) ??
                                  '';
                              final lastMessage =
                                  data['lastMessage'] as String? ?? '';
                              final lastSenderId =
                                  data['lastSenderId'] as String? ?? '';
                              final preview = !isGroup && lastSenderId == uid
                                  ? 'You: $lastMessage'
                                  : lastMessage;

                              return Material(
                                color: Colors.white.withValues(alpha: 0.28),
                                borderRadius: BorderRadius.circular(18),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: () => _openChat(
                                    chat.id,
                                    title,
                                    isGroup: isGroup,
                                    otherUserId: isGroup ? null : otherUid,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      children: [
                                        isGroup
                                            ? CircleAvatar(
                                                radius: 27,
                                                backgroundColor: Colors.white,
                                                backgroundImage:
                                                    CommunityMediaService.imageProvider(
                                                      image,
                                                    ),
                                                child:
                                                    CommunityMediaService.imageProvider(
                                                          image,
                                                        ) ==
                                                        null
                                                    ? const Icon(
                                                        Icons.groups_rounded,
                                                        color: Color(
                                                          0xFFE94360,
                                                        ),
                                                      )
                                                    : null,
                                              )
                                            : StreamBuilder<
                                                DocumentSnapshot<
                                                  Map<String, dynamic>
                                                >
                                              >(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(otherUid)
                                                    .snapshots(),
                                                builder: (context, profileSnapshot) {
                                                  final profilePhoto =
                                                      profileSnapshot.data
                                                              ?.data()?['image']
                                                          as String?;
                                                  return CircleAvatar(
                                                    radius: 27,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage:
                                                        CommunityMediaService.imageProvider(
                                                          profilePhoto,
                                                        ),
                                                    child:
                                                        CommunityMediaService.imageProvider(
                                                              profilePhoto,
                                                            ) ==
                                                            null
                                                        ? const Icon(
                                                            Icons
                                                                .person_rounded,
                                                            color: Color(
                                                              0xFFE94360,
                                                            ),
                                                          )
                                                        : null,
                                                  );
                                                },
                                              ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                preview.isEmpty
                                                    ? (isGroup
                                                          ? 'Group conversation'
                                                          : 'Start a conversation')
                                                    : preview,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          _formatChatTime(
                                            data['updatedAt'] as Timestamp?,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
