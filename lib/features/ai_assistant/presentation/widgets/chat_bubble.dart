import 'dart:io';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String? text;
  final String? imagePath;
  final bool isUser;

  const ChatBubble({
    super.key,
    this.text,
    this.imagePath,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFFF5252) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🌟 ပုံပါလာပါက ပုံကိုပါ ဖော်ပြပေးရန်
            if (imagePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath!),
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              if (text != null && text!.isNotEmpty) const SizedBox(height: 8),
            ],
            // စာသားပါလာပါက စာသားပြရန်
            if (text != null && text!.isNotEmpty)
              Text(
                text!,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 13.5,
                  height: 1.3,
                ),
              ),
          ],
        ),
      ),
    );
  }
}