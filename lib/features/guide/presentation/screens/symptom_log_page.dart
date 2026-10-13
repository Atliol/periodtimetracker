import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class SymptomLogPage extends StatefulWidget {
  const SymptomLogPage({super.key});

  @override
  State<SymptomLogPage> createState() => _SymptomLogPageState();
}

class _SymptomLogPageState extends State<SymptomLogPage> {
  // ရွေးချယ်ထားသော ရောဂါလက္ခဏာများ
  final List<String> _selectedSymptoms = [];

  final List<Map<String, dynamic>> _symptomOptions = [
    {'name': 'ဗိုက်နာခြင်း (Cramps)', 'icon': Icons.bolt_rounded},
    {'name': 'ခေါင်းကိုက်ခြင်း (Headache)', 'icon': Icons.psychology_rounded},
    {'name': 'မူးဝေခြင်း (Dizziness)', 'icon': Icons.air_rounded},
    {'name': 'စိတ်ဖိစီးခြင်း (Mood Swings)', 'icon': Icons.mood_bad_rounded},
    {'name': 'ပင်ပန်းနွမ်းနယ်ခြင်း (Fatigue)', 'icon': Icons.battery_alert_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD47A83),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFD47A83),
          appBar: const CustomAppBar(
            title: 'Health & Symptom Tracker',
            showBackButton: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ယနေ့ သင့်ရဲ့ ကျန်းမာရေး အခြေအနေဘယ်လိုရှိလဲ?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'ကြုံတွေ့နေရသော လက္ခဏာများကို ရွေးချယ်မှတ်တမ်းတင်ပါ',
                  style: TextStyle(fontSize: 12.5, color: Colors.white70),
                ),
                const SizedBox(height: 20),

                // Symptom Options List
                Expanded(
                  child: ListView.builder(
                    itemCount: _symptomOptions.length,
                    itemBuilder: (context, index) {
                      final symptom = _symptomOptions[index];
                      final isSelected = _selectedSymptoms.contains(symptom['name']);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFF416C) : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            symptom['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isSelected ? const Color(0xFFFF416C) : Colors.black87,
                            ),
                          ),
                          secondary: Icon(symptom['icon'], color: isSelected ? const Color(0xFFFF416C) : Colors.grey),
                          value: isSelected,
                          activeColor: const Color(0xFFFF416C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedSymptoms.add(symptom['name']);
                              } else {
                                _selectedSymptoms.remove(symptom['name']);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFF416C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('မှတ်တမ်းများကို အောင်မြင်စွာ သိမ်းဆည်းပြီးပါပြီ')),
                      );
                    },
                    child: const Text(
                      'မှတ်တမ်းတင်မည် (Save Log)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}