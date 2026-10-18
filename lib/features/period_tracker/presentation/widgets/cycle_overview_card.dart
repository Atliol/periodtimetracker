import 'package:flutter/material.dart';
import '../../data/local_storage_service.dart';
import '../../domain/cycle_model.dart';
import '../screens/period_time_page.dart';

class CycleOverviewCard extends StatefulWidget {
  const CycleOverviewCard({super.key});

  @override
  State<CycleOverviewCard> createState() => _CycleOverviewCardState();
}

class _CycleOverviewCardState extends State<CycleOverviewCard> {
  List<CycleModel> _cycles = [];

  @override
  void initState() {
    super.initState();
    _loadCycles();
  }

  void _loadCycles() {
    setState(() {
      _cycles = LocalStorageService.getAllCycles();
    });
  }

  @override
  Widget build(BuildContext context) {
    // မှတ်တမ်း အနည်းဆုံး ၃ ခု (သို့မဟုတ် ရှိသမျှ) ကို ယူခြင်း
    final displayCycles = _cycles.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & See All Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: Color(0xFF5F3542), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'လအလိုက် မှတ်တမ်းများ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF5F3542)),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PeriodTimePage()),
                  );
                  _loadCycles();
                },
                child: const Text(
                  'See All',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE94360)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // မှတ်တမ်းများ မရှိသေးပါက ပြသမည့် UI
          if (displayCycles.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text(
                'ယခုထိ မှတ်တမ်းများ မရှိသေးပါ။',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            )
          else
          // မှတ်တမ်း တစ်ခုချင်းစီကို သီးသန့်ကတ်ပြားလေးများအဖြစ် ပြသခြင်း
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayCycles.length,
              itemBuilder: (context, index) {
                final cycle = displayCycles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD6E0).withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          cycle.isPeriod ? Icons.water_drop_rounded : Icons.auto_awesome_rounded,
                          color: cycle.isPeriod ? const Color(0xFFE94360) : Colors.orange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${cycle.startDate.day} / ${cycle.startDate.month} / ${cycle.startDate.year}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF5F3542)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cycle.note,
                              style: const TextStyle(fontSize: 12, color: Colors.black54),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 8),

          // Period & Notes ထပ်ထည့်ရန် ခလုတ်
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFE94360),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE94360), width: 1),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PeriodTimePage()),
                );
                _loadCycles();
              },
              child: const Text(
                'Period & Notes ထပ်ထည့်ရန်',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}