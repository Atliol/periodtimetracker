import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> openPrivateChat({
    required String currentUid,
    required String otherUid,
  }) async {
    if (currentUid == otherUid) {
      throw ArgumentError('A private chat needs two different users.');
    }

    final participants = [currentUid, otherUid]..sort();
    final chatRef = _firestore
        .collection('chats')
        .doc('private_${participants.join('_')}');
    final profileSnapshots = await Future.wait([
      _firestore.collection('users').doc(currentUid).get(),
      _firestore.collection('users').doc(otherUid).get(),
    ]);
    final profilesByUid = {
      currentUid: profileSnapshots[0].data() ?? <String, dynamic>{},
      otherUid: profileSnapshots[1].data() ?? <String, dynamic>{},
    };
    final participantInfo = <String, Map<String, dynamic>>{};
    for (final participantUid in participants) {
      final data = profilesByUid[participantUid] ?? <String, dynamic>{};
      participantInfo[participantUid] = {
        'name': data['name'] as String? ?? 'Community member',
      };
    }

    await _firestore.runTransaction((transaction) async {
      final existingChat = await transaction.get(chatRef);
      if (!existingChat.exists) {
        transaction.set(chatRef, {
          'type': 'private',
          'participants': participants,
          'participantInfo': participantInfo,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'lastMessage': '',
          'lastSenderId': '',
        });
      }
    });

    return chatRef.id;
  }

  static Future<String> createGroupChat({
    required String name,
    required List<String> participantUids,
    required String createdBy,
  }) async {
    final participants = participantUids.toSet().toList()..sort();
    if (name.trim().isEmpty || participants.length < 2) {
      throw ArgumentError('A group needs a name and at least two members.');
    }

    final snapshots = await Future.wait(
      participants.map((uid) => _firestore.collection('users').doc(uid).get()),
    );
    final participantInfo = <String, Map<String, dynamic>>{};
    for (var index = 0; index < participants.length; index++) {
      final data = snapshots[index].data() ?? <String, dynamic>{};
      participantInfo[participants[index]] = {
        'name': data['name'] as String? ?? 'Community member',
      };
    }

    final chatRef = _firestore.collection('chats').doc();
    await chatRef.set({
      'type': 'group',
      'name': name.trim(),
      'participants': participants,
      'participantInfo': participantInfo,
      'image': '',
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastSenderId': '',
    });
    return chatRef.id;
  }
}
