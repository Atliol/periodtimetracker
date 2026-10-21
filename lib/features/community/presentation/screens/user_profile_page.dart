import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/services/community_media_service.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFB6C1),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFFFB6C1),
          appBar: const CustomAppBar(title: 'Profile', showBackButton: true),
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  !snapshot.data!.exists) {
                return const Center(
                  child: Text(
                    'Profile ကိုဖတ်မရပါ',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final profile = snapshot.data!.data()!;
              final photo = profile['image'] as String?;
              final note = profile['note'] as String? ?? '';
              final noteExpiry = profile['noteExpiresAt'] as Timestamp?;
              final hasActiveNote =
                  note.isNotEmpty &&
                  (noteExpiry == null ||
                      noteExpiry.toDate().isAfter(DateTime.now()));
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                CommunityMediaService.imageProvider(photo),
                            child:
                                CommunityMediaService.imageProvider(photo) ==
                                    null
                                ? const Icon(
                                    Icons.person_rounded,
                                    size: 64,
                                    color: Color(0xFFE94360),
                                  )
                                : null,
                          ),
                          if (hasActiveNote)
                            Positioned(
                              top: -24,
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 190,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  note,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        profile['name'] as String? ?? 'Community member',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if ((profile['role'] as String? ?? '').isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          profile['role'] as String,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _ProfileDetail(
                        icon: Icons.info_outline_rounded,
                        text: profile['bio'] as String? ?? 'Bio မရှိသေးပါ',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProfileDetail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
