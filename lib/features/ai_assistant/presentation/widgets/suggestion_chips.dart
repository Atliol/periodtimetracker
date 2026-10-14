import 'package:flutter/material.dart';

class SuggestionChips extends StatelessWidget {
  final Function(String) onSelected;

  const SuggestionChips({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = [
      'နာကျင်ကိုက်ခဲမှု သက်သာရန်',
      'ရာသီစက်ဝန်း မမှန်ခြင်း',
      'စားသုံးသင့်သော အစားအစာများ',
      'ovulation အကြောင်း',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFFFFD6E0).withValues(alpha: 0.3),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: suggestions.map((label) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ActionChip(
                backgroundColor: Colors.white,
                label: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFFF416C),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFFFD6E0)),
                ),
                onPressed: () => onSelected(label),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}