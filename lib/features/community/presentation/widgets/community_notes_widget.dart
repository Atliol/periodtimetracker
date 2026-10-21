import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/services/community_media_service.dart';

class CommunityNotesWidget extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> users;
  final String currentUid;
  final VoidCallback onAddNote;
  final ValueChanged<String> onOpenProfile;

  const CommunityNotesWidget({
    super.key,
    required this.users,
    required this.currentUid,
    required this.onAddNote,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = users.where((user) => user.id == currentUid);
    final otherUsers = users.where((user) {
      if (user.id == currentUid) return false;
      final data = user.data();
      final note = data['note'] as String? ?? '';
      final expiry = data['noteExpiresAt'] as Timestamp?;
      return note.isNotEmpty &&
          (expiry == null || expiry.toDate().isAfter(DateTime.now()));
    });
    final noteUsers = [...currentUser, ...otherUsers];

    return SizedBox(
      height: 112,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        itemCount: noteUsers.length,
        itemBuilder: (context, index) {
          final user = noteUsers[index];
          final data = user.data();
          final isCurrentUser = user.id == currentUid;
          final storedNote = data['note'] as String? ?? '';
          final expiry = data['noteExpiresAt'] as Timestamp?;
          final note =
              storedNote.isNotEmpty &&
                  (expiry == null || expiry.toDate().isAfter(DateTime.now()))
              ? storedNote
              : '';
          final photo = data['image'] as String?;
          return SizedBox(
            width: 82,
            child: GestureDetector(
              onTap: isCurrentUser ? onAddNote : () => onOpenProfile(user.id),
              child: Column(
                children: [
                  SizedBox(
                    height: 68,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        if (note.isNotEmpty)
                          Positioned(
                            top: 0,
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 78),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                note,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          backgroundImage: CommunityMediaService.imageProvider(
                            photo,
                          ),
                          child:
                              CommunityMediaService.imageProvider(photo) == null
                              ? Icon(
                                  isCurrentUser
                                      ? Icons.add_rounded
                                      : Icons.person_rounded,
                                  color: const Color(0xFFE94360),
                                  size: isCurrentUser ? 28 : 25,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCurrentUser
                        ? 'Your note'
                        : data['name'] as String? ?? 'Member',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
