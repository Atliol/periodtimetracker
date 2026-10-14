import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // 🌟 Image Picker package ကို import လုပ်ရန်
import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/suggestion_chips.dart';

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker(); // 🌟 ImagePicker instance

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'ai',
      'text': 'မင်္ဂလာပါရှင် 🌸 Period Tracker AI Assistant မှ ကြိုဆိုပါတယ်။ ကျန်းမာရေး၊ ရာသီစက်ဝန်း သို့မဟုတ် ပုံစံတူ စစ်ဆေးချက်ဓာတ်ပုံများ ပို့ပြီး မေးမြန်းနိုင်ပါတယ်နော်။',
      'time': 'ယခုလေးတင်'
    },
  ];

  void _sendMessage(String text, {String? imagePath}) {
    if (text.trim().isEmpty && imagePath == null) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text,
        'image': imagePath,
        'time': 'ယခု'
      });
    });

    _controller.clear();
    _scrollToBottom();

    // AI မှ အလိုအလျောက် ပြန်ကြားမည့် ပုံစံ
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'sender': 'ai',
          'text': imagePath != null
              ? 'ပုံကို လက်ခံရရှိပါတယ်ရှင့် 🌸 ဤအချက်အလက်နှင့် ပတ်သက်ပြီး လိုအပ်သည်များကို ဆက်လက်ဆွေးနွေးပေးပါမယ်။'
              : 'မေးမြန်းပေးမှုအတွက် ကျေးဇူးတင်ပါတယ်။ ရာသီလာစဉ် ကိုယ်လက်ကိုက်ခဲခြင်း သက်သာစေရန် ရေနွေးအိတ်ကပ်ခြင်းနှင့် အနားယူခြင်းများ ပြုလုပ်ပေးနိုင်ပါတယ် 🌸',
          'time': 'ယခု'
        });
      });
      _scrollToBottom();
    });
  }

  // 🌟 ဖုန်း Gallery မှ ပုံရွေးချယ်ရန် Function
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _sendMessage('', imagePath: image.path);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD47A83),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFD47A83),
          appBar: const CustomAppBar(title: 'AI Health Assistant'),
          body: Column(
            children: [
              SuggestionChips(onSelected: (text) => _sendMessage(text)),

              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return ChatBubble(
                      text: message['text'],
                      imagePath: message['image'],
                      isUser: message['sender'] == 'user',
                    );
                  },
                ),
              ),

              // 🌟 အောက်ဆုံး Input Box (Gallery Icon နှင့် Send Button အပြည့်အစုံပါဝင်သည်)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 🌟 ပုံတင်ရန် Gallery Icon ခလုတ် (အသစ်ထည့်သွင်းထားသည်)
                    IconButton(
                      icon: const Icon(Icons.image_rounded, color: Color(0xFFFF416C), size: 24),
                      onPressed: _pickImage,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (value) => _sendMessage(value),
                        decoration: InputDecoration(
                          hintText: 'ကျန်းမာရေးအကြောင်း မေးမြန်းရန်...',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                          filled: true,
                          fillColor: const Color(0xFFFFD6E0).withValues(alpha: 0.2),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _sendMessage(_controller.text),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF416C),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
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