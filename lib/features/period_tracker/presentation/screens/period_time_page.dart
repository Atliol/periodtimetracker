import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../data/local_storage_service.dart';
import '../../domain/cycle_model.dart';
import '../widgets/symptom_note_card.dart'; // 🌟 Import Widget

class PeriodTimePage extends StatefulWidget {
  const PeriodTimePage({super.key});

  @override
  State<PeriodTimePage> createState() => _PeriodTimePageState();
}

class _PeriodTimePageState extends State<PeriodTimePage> {
  final DateTime _selectedDate = DateTime.now();
  List<CycleModel> _savedCycles = [];

  final TextEditingController _noteController = TextEditingController();
  String _selectedMood = '😊 ပုံမှန်';
  final List<String> _moodList = ['😊 ပုံမှန်', '😣 ကိုက်ခဲခြင်း', '😴 မူးဝေ/အိပ်ងိုက်', '😡 စိတ်တိုလွယ်ခြင်း', '🍫 ချိုချဉ်စားချင်ခြင်း'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _savedCycles = LocalStorageService.getAllCycles();
    });
  }

  void _savePeriodWithNote() async {
    final noteText = '${_selectedMood}: ${_noteController.text}';
    DateTime ovulationDate = _selectedDate.add(const Duration(days: 14));

    final newCycle = CycleModel(
      startDate: _selectedDate,
      endDate: _selectedDate.add(const Duration(days: 4)),
      note: noteText.isNotEmpty ? noteText : 'Period Recorded',
      isPeriod: true,
      isOvulation: false,
    );

    final ovulationCycle = CycleModel(
      startDate: ovulationDate,
      endDate: ovulationDate,
      note: 'Auto Ovulation Window',
      isPeriod: false,
      isOvulation: true,
    );

    await LocalStorageService.saveCycle(newCycle);
    await LocalStorageService.saveCycle(ovulationCycle);

    _noteController.clear();
    _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🌸 Period နှင့် မှတ်စုများကို အောင်မြင်စွာ သိမ်းဆည်းပြီးပါပြီ။'),
          backgroundColor: Color(0xFFE94360),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD47A83),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFD47A83),
          appBar: const CustomAppBar(title: 'Period & Cycle Calendar'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Calendar / Date Selection Card
                Container(
                  height: 130,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('ရွေးချယ်ထားသော ရက်စွဲ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            '${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5F3542)),
                          ),
                          const SizedBox(height: 4),
                          const Text('🌸 ဤရက်တွင် Period စတင်ရန် သတ်မှတ်ပါ', style: TextStyle(color: Color(0xFFE94360), fontSize: 11)),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE94360),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        onPressed: _savePeriodWithNote,
                        child: const Text('Period မှတ်ရန်', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Symptom Notes Widget
                SymptomNoteCard(
                  controller: _noteController,
                  selectedMood: _selectedMood,
                  moodList: _moodList,
                  onMoodSelected: (mood) {
                    setState(() {
                      _selectedMood = mood;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // 3. Saved Records List
                const Text('📅 လအလိုက် မှတ်တမ်းဟောင်းများ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _savedCycles.length,
                  itemBuilder: (context, index) {
                    final cycle = _savedCycles[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: Icon(cycle.isPeriod ? Icons.water_drop_rounded : Icons.auto_awesome_rounded, color: cycle.isPeriod ? const Color(0xFFE94360) : Colors.orange),
                        title: Text('${cycle.startDate.day} / ${cycle.startDate.month} / ${cycle.startDate.year}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text(cycle.note, style: const TextStyle(fontSize: 11)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey, size: 18),
                          onPressed: () async {
                            await LocalStorageService.deleteCycle(index);
                            _loadData();
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}