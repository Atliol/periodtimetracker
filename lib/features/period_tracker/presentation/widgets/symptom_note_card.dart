import 'package:flutter/material.dart';

class SymptomNoteCard extends StatelessWidget {
  final TextEditingController controller;
  final String selectedMood;
  final List<String> moodList;
  final Function(String) onMoodSelected;

  const SymptomNoteCard({
    super.key,
    required this.controller,
    required this.selectedMood,
    required this.moodList,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝 Period လာစဉ် ခံစားချက်နှင့် မှတ်စုများ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF5F3542)),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: moodList.map((mood) {
                bool isSelected = selectedMood == mood;
                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: ChoiceChip(
                    label: Text(mood, style: const TextStyle(fontSize: 11)),
                    selected: isSelected,
                    selectedColor: const Color(0xFFE94360),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : const Color(0xFF5F3542)),
                    onSelected: (selected) => onMoodSelected(mood),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'အသေးစိတ် ခံစားချက်များ ရေးရန်...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              filled: true,
              fillColor: const Color(0xFFFFD6E0).withValues(alpha: 0.2),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}