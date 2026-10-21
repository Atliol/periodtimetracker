import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/services/community_media_service.dart';
import 'user_profile_page.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatId;
  final String title;
  final bool isGroup;
  final String? otherUserId;

  const ChatRoomPage({
    super.key,
    required this.chatId,
    required this.title,
    required this.isGroup,
    this.otherUserId,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage({String? imageData}) async {
    final text = _messageController.text.trim();
    final user = FirebaseAuth.instance.currentUser;
    if ((text.isEmpty && imageData == null) || user == null || _isSending) {
      return;
    }

    setState(() => _isSending = true);
    try {
      final profile =
          (await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get())
              .data();
      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId);
      final messageRef = chatRef.collection('messages').doc();
      final senderImage = profile?['image'] as String? ?? '';
      final batch = FirebaseFirestore.instance.batch();
      final messageData = <String, dynamic>{
        'senderId': user.uid,
        'senderName':
            profile?['name'] ?? user.displayName ?? 'Community member',
        'senderImage': senderImage.startsWith('data:image/') ? '' : senderImage,
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      };
      if (imageData != null) messageData['image'] = imageData;
      batch.set(messageRef, messageData);
      batch.update(chatRef, {
        'lastMessage': imageData != null && text.isEmpty ? 'Photo' : text,
        'lastSenderId': user.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();
      _messageController.clear();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Message Error: $error')));
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _pickAndSendImage() async {
    try {
      final image = await CommunityMediaService.pickPhoto(
        maxWidth: 256,
        maxHeight: 256,
        imageQuality: 45,
      );
      if (image != null && mounted) await _sendMessage(imageData: image);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Image Error: $error')));
      }
    }
  }

  Future<void> _changeGroupPhoto() async {
    try {
      final image = await CommunityMediaService.pickPhoto(
        maxWidth: 256,
        maxHeight: 256,
        imageQuality: 45,
      );
      if (image == null) return;
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .set({'image': image}, SetOptions(merge: true));
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Group photo error: $error')));
      }
    }
  }

  Future<void> _openProfile(String userId) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (context) => UserProfilePage(userId: userId)),
    );
  }

  Widget _senderAvatar(String senderId) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .snapshots(),
      builder: (context, snapshot) {
        final photo = snapshot.data?.data()?['image'] as String?;
        return GestureDetector(
          onTap: () => _openProfile(senderId),
          child: CircleAvatar(
            radius: 17,
            backgroundColor: Colors.white,
            backgroundImage: CommunityMediaService.imageProvider(photo),
            child: CommunityMediaService.imageProvider(photo) == null
                ? const Icon(
                    Icons.person_rounded,
                    size: 18,
                    color: Color(0xFFE94360),
                  )
                : null,
          ),
        );
      },
    );
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${date.hour >= 12 ? 'PM' : 'AM'}';
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
            title: widget.title,
            showBackButton: true,
            actions: [
              if (widget.isGroup)
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(widget.chatId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final photo = snapshot.data?.data()?['image'] as String?;
                    return IconButton(
                      tooltip: 'Change group photo',
                      onPressed: _changeGroupPhoto,
                      icon: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        backgroundImage: CommunityMediaService.imageProvider(
                          photo,
                        ),
                        child:
                            CommunityMediaService.imageProvider(photo) == null
                            ? const Icon(
                                Icons.groups_rounded,
                                size: 18,
                                color: Color(0xFFE94360),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              if (!widget.isGroup && widget.otherUserId != null)
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.otherUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final photo = snapshot.data?.data()?['image'] as String?;
                    return IconButton(
                      tooltip: 'View profile',
                      onPressed: () => _openProfile(widget.otherUserId!),
                      icon: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        backgroundImage: CommunityMediaService.imageProvider(
                          photo,
                        ),
                        child:
                            CommunityMediaService.imageProvider(photo) == null
                            ? const Icon(
                                Icons.person_rounded,
                                size: 18,
                                color: Color(0xFFE94360),
                              )
                            : null,
                      ),
                    );
                  },
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(widget.chatId)
                      .collection('messages')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Messages များကို ဖတ်မရပါ',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    final messages = snapshot.data?.docs ?? [];
                    if (messages.isEmpty) {
                      return const Center(
                        child: Text(
                          'စကားစပြောလိုက်ပါ',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index].data();
                        final isMine = message['senderId'] == uid;
                        final senderId = message['senderId'] as String? ?? '';
                        final image = message['image'] as String?;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: isMine
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (!isMine) ...[
                                if (senderId.isNotEmpty)
                                  _senderAvatar(senderId),
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.sizeOf(context).width * 0.76,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMine
                                        ? const Color(0xFFE94360)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (widget.isGroup && !isMine)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 4,
                                          ),
                                          child: Text(
                                            message['senderName'] as String? ??
                                                'Member',
                                            style: const TextStyle(
                                              color: Color(0xFFE94360),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      if (image != null)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                (message['text'] as String? ??
                                                        '')
                                                    .isNotEmpty
                                                ? 8
                                                : 0,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image(
                                              image:
                                                  CommunityMediaService.imageProvider(
                                                    image,
                                                  )!,
                                              fit: BoxFit.cover,
                                              width: 220,
                                              height: 220,
                                            ),
                                          ),
                                        ),
                                      if ((message['text'] as String? ?? '')
                                          .isNotEmpty)
                                        Text(
                                          message['text'] as String,
                                          style: TextStyle(
                                            color: isMine
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 15,
                                          ),
                                        ),
                                      const SizedBox(height: 4),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _formatTime(
                                            message['createdAt'] as Timestamp?,
                                          ),
                                          style: TextStyle(
                                            color: isMine
                                                ? Colors.white70
                                                : Colors.black45,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                color: Colors.white.withValues(alpha: 0.35),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Send photo',
                      onPressed: _isSending ? null : _pickAndSendImage,
                      icon: const Icon(
                        Icons.image_rounded,
                        color: Color(0xFFE94360),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Message',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 11,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      tooltip: 'Send message',
                      onPressed: _isSending ? null : _sendMessage,
                      icon: _isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFE94360),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
