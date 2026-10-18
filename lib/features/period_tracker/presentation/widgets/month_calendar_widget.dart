import 'package:flutter/material.dart';
import '../../data/local_storage_service.dart';
import '../../domain/cycle_model.dart';

class MonthCalendarWidget extends StatefulWidget {
  const MonthCalendarWidget({super.key});

  @override
  State<MonthCalendarWidget> createState() => _MonthCalendarWidgetState();
}

class _MonthCalendarWidgetState extends State<MonthCalendarWidget> {
  final DateTime _currentMonth = DateTime.now();
  List<CycleModel> _savedCycles = [];
  int? _selectedTempDay;
  int _selectedCycleLength = 28; // Default ရာသီစက်ဝန်း ၂၈ ရက်

  @override
  void initState() {
    super.initState();
    _loadCycles();
  }

  void _loadCycles() {
    setState(() {
      _savedCycles = LocalStorageService.getAllCycles();
    });
  }

  // 🌟 ရက်စွဲနှိပ်လိုက်သောအခါ ရာသီစက်ဝန်း မေးမြန်းသည့် Confirmation Alert Dialog ပေါ်လာစေခြင်း
  void _onDayTap(int day) {
    setState(() {
      _selectedTempDay = day;
      _selectedCycleLength = 28;
    });

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.event_available_rounded, color: Color(0xFFC2185B)),
                  SizedBox(width: 8),
                  Text('ရာသီစက်ဝန်း သတ်မှတ်ရန်', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_currentMonth.month} လပိုင်း $day ရက်နေ့ကို ရာသီစတင်သည့်ရက်အဖြစ် သတ်မှတ်မည်။',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF5F3542)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'မိမိ၏ ပုံမှန် ရာသီစက်ဝန်း (ရက်) ကို ရွေးချယ်ပါ -',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF5F3542)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC2185B).withValues(alpha: 0.3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedCycleLength,
                        isExpanded: true,
                        items: List.generate(15, (index) => 21 + index).map((int length) {
                          return DropdownMenuItem<int>(
                            value: length,
                            child: Text(
                              '$length ရက်',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFC2185B)),
                            ),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setDialogState(() {
                              _selectedCycleLength = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTempDay = null;
                    });
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('မလုပ်တော့ပါ', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC2185B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _confirmAndSaveCycle(day, _selectedCycleLength);
                  },
                  child: const Text('အတည်ပြုမည်'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 🌟 Confirm လုပ်ပြီး Hive Database သို့ တိုက်ရိုက်သိမ်းဆည်းခြင်း
  void _confirmAndSaveCycle(int day, int cycleLength) async {
    DateTime selectedDate = DateTime(_currentMonth.year, _currentMonth.month, day);

    // 1. Period Cycle (5 ရက်)
    final newPeriodCycle = CycleModel(
      startDate: selectedDate,
      endDate: selectedDate.add(const Duration(days: 4)),
      note: 'Period Start Day ($cycleLength Days Cycle)',
      isPeriod: true,
      isOvulation: false,
    );

    // 2. Ovulation Date တွက်ချက်ခြင်း: (Cycle Length - 14) ရက်မြောက်နေ့
    int ovulationOffset = cycleLength - 14;
    DateTime ovulationDate = selectedDate.add(Duration(days: ovulationOffset));

    final autoOvulationCycle = CycleModel(
      startDate: ovulationDate,
      endDate: ovulationDate,
      note: 'Auto Ovulation Window',
      isPeriod: false,
      isOvulation: true,
    );

    await LocalStorageService.saveCycle(newPeriodCycle);
    await LocalStorageService.saveCycle(autoOvulationCycle);

    setState(() {
      _selectedTempDay = null;
    });

    _loadCycles();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🌸 ရာသီစက်ဝန်း အချက်အလက်များကို Hive Database သို့ သိမ်းဆည်းပြီးပါပြီ။'),
          backgroundColor: Color(0xFFC2185B),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Edit an existing period record and regenerate its predicted ovulation date.
  Future<void> _editPeriodCycle(CycleModel cycle) async {
    DateTime pickedDate = cycle.startDate;
    final cycleLengthMatch = RegExp(r'(\d+) Days Cycle').firstMatch(cycle.note);
    int cycleLength = int.tryParse(cycleLengthMatch?.group(1) ?? '') ?? 28;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'ရာသီရက်စွဲ ပြင်ဆင်ရန်',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF5F3542)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ရာသီစတင်ရက်'),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_month_rounded),
                label: Text('${pickedDate.day}/${pickedDate.month}/${pickedDate.year}'),
                style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFC2185B)),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: dialogContext,
                    initialDate: pickedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    helpText: 'ရာသီစတင်ရက် ရွေးချယ်ပါ',
                  );
                  if (date != null) setDialogState(() => pickedDate = date);
                },
              ),
              const SizedBox(height: 12),
              const Text('ပုံမှန် Cycle Length'),
              DropdownButton<int>(
                value: cycleLength.clamp(21, 35),
                isExpanded: true,
                items: List.generate(15, (i) => i + 21)
                    .map((length) => DropdownMenuItem(value: length, child: Text('$length ရက်')))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setDialogState(() => cycleLength = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('မလုပ်တော့ပါ', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC2185B),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('သိမ်းမည်'),
            ),
          ],
        ),
      ),
    );

    if (result != true || !mounted) return;

    // Keep every unrelated record. Replace the selected period record and its
    // generated ovulation record (identified by its old predicted date).
    final oldStart = cycle.startDate;
    final oldLengthMatch = RegExp(r'(\d+) Days Cycle').firstMatch(cycle.note);
    final oldLength = int.tryParse(oldLengthMatch?.group(1) ?? '') ?? 28;
    final oldOvulationDate = oldStart.add(Duration(days: oldLength - 14));
    final preservedCycles = _savedCycles.where((item) {
      if (identical(item, cycle)) return false;
      if (item.isOvulation && item.note == 'Auto Ovulation Window' &&
          _sameDate(item.startDate, oldOvulationDate)) {
        return false;
      }
      return true;
    }).toList();

    await LocalStorageService.clearAllCycles();
    for (final item in preservedCycles) {
      await LocalStorageService.saveCycle(item);
    }
    await LocalStorageService.saveCycle(CycleModel(
      startDate: pickedDate,
      endDate: pickedDate.add(const Duration(days: 4)),
      note: 'Period Start Day ($cycleLength Days Cycle)',
      isPeriod: true,
      isOvulation: false,
    ));
    await LocalStorageService.saveCycle(CycleModel(
      startDate: pickedDate.add(Duration(days: cycleLength - 14)),
      endDate: pickedDate.add(Duration(days: cycleLength - 14)),
      note: 'Auto Ovulation Window',
      isPeriod: false,
      isOvulation: true,
    ));

    if (!mounted) return;
    _loadCycles();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ရာသီရက်စွဲကို ပြင်ဆင်ပြီးပါပြီ။'),
        backgroundColor: Color(0xFFC2185B),
      ),
    );
  }

  bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _deletePeriodCycle(CycleModel cycle) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('မှတ်တမ်းဖျက်မည်လား?'),
        content: Text('${cycle.startDate.day}/${cycle.startDate.month}/${cycle.startDate.year} ရက်နေ့၏ ရာသီမှတ်တမ်းကို ဖျက်မည်။'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('မဖျက်ပါ')),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('ဖျက်မည်', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    final oldStart = cycle.startDate;
    final match = RegExp(r'(\d+) Days Cycle').firstMatch(cycle.note);
    final length = int.tryParse(match?.group(1) ?? '') ?? 28;
    final oldOvulationDate = oldStart.add(Duration(days: length - 14));
    final preservedCycles = _savedCycles.where((item) {
      if (identical(item, cycle)) return false;
      if (item.isOvulation && item.note == 'Auto Ovulation Window' &&
          _sameDate(item.startDate, oldOvulationDate)) return false;
      return true;
    }).toList();

    await LocalStorageService.clearAllCycles();
    for (final item in preservedCycles) {
      await LocalStorageService.saveCycle(item);
    }
    if (!mounted) return;
    _loadCycles();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ရာသီမှတ်တမ်းကို ဖျက်ပြီးပါပြီ။')),
    );
  }

  void _showEditOptions() {
    final periodCycles = _savedCycles.where((cycle) => cycle.isPeriod).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ရာသီမှတ်တမ်း ပြင်ဆင်ရန်',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF5F3542)),
              ),
              const SizedBox(height: 8),
              if (periodCycles.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('ပြင်ဆင်ရန် ရာသီမှတ်တမ်း မရှိသေးပါ။ Calendar မှ ရက်စွဲတစ်ခုကို နှိပ်ပြီး မှတ်တမ်းထည့်ပါ။'),
                )
              else ...[
                const Text('ပြင်ဆင်လိုသော ရာသီစတင်ရက်ကို ရွေးပါ။'),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: periodCycles.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final cycle = periodCycles[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFCE4EC),
                          child: Icon(Icons.water_drop_rounded, color: Color(0xFFC2185B)),
                        ),
                        title: Text('${cycle.startDate.day}/${cycle.startDate.month}/${cycle.startDate.year}'),
                        subtitle: const Text('ရာသီစတင်ရက်'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'ပြင်ဆင်ရန်',
                              icon: const Icon(Icons.edit_rounded, color: Color(0xFFC2185B)),
                              onPressed: () {
                                Navigator.pop(sheetContext);
                                _editPeriodCycle(cycle);
                              },
                            ),
                            IconButton(
                              tooltip: 'ဖျက်ရန်',
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                              onPressed: () {
                                Navigator.pop(sheetContext);
                                _deletePeriodCycle(cycle);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('ပိတ်မည်'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final int firstDayWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;

    Set<int> periodDays = {};
    Set<int> fertileDays = {};
    Set<int> ovulationDays = {};
    Set<int> mainPeriodStartDays = {};
    int? firstPeriodDay;
    int? lastPeriodDay;

    for (var cycle in _savedCycles) {
      if (cycle.startDate.month == _currentMonth.month && cycle.startDate.year == _currentMonth.year) {
        if (cycle.isPeriod) {
          mainPeriodStartDays.add(cycle.startDate.day);
          firstPeriodDay = cycle.startDate.day;
          lastPeriodDay = cycle.startDate.add(const Duration(days: 4)).day;
          for (int i = 0; i < 5; i++) {
            periodDays.add(cycle.startDate.add(Duration(days: i)).day);
          }
        }
        if (cycle.isOvulation) {
          ovulationDays.add(cycle.startDate.day);
          for (int i = -4; i <= 1; i++) {
            if (i != 0) {
              fertileDays.add(cycle.startDate.add(Duration(days: i)).day);
            }
          }
        }
      }
    }

    final int todayDay = DateTime.now().day;
    final bool isCurrentMonthToday = _currentMonth.month == DateTime.now().month && _currentMonth.year == DateTime.now().year;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Period Calendar',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF5F3542)),
              ),
              IconButton(
                icon: const Icon(Icons.edit_note_rounded, color: Color(0xFFC2185B), size: 22),
                onPressed: _showEditOptions,
                tooltip: 'ရက်စွဲများ ပြန်ပြင်ရန်',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Weekday Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _WeekdayText('SUN'),
              _WeekdayText('MON'),
              _WeekdayText('TUE'),
              _WeekdayText('WED'),
              _WeekdayText('THU'),
              _WeekdayText('FRI'),
              _WeekdayText('SAT'),
            ],
          ),
          const SizedBox(height: 12),

          // Calendar Grid Builder
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: daysInMonth + firstDayWeekday,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 0,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              if (index < firstDayWeekday) {
                return const SizedBox.shrink();
              }

              int dayNumber = index - firstDayWeekday + 1;
              bool isPeriodRange = periodDays.contains(dayNumber);
              bool isFertileRange = fertileDays.contains(dayNumber);
              bool isOvulationDay = ovulationDays.contains(dayNumber);
              bool isStartDay = mainPeriodStartDays.contains(dayNumber) || _selectedTempDay == dayNumber;
              bool isToday = isCurrentMonthToday && dayNumber == todayDay;

              // Fertile window အပြင်ဘက်ရက်များကို သီးခြားအရောင်ပြမည်။
              // သို့သော် ယင်းရက်များကို ကိုယ်ဝန်လုံးဝမရနိုင်ဟု မဆိုလိုပါ။
              bool isOtherDay = _savedCycles.isNotEmpty &&
                  !isPeriodRange && !isFertileRange && !isOvulationDay;

              // တစ်ပတ်အတွင်း ဘေးချင်းကပ်နေသော ရက်များကို range တစ်ခုလို ချိတ်ဆက်ရန်
              final bool hasPreviousInRow = index % 7 != 0;
              final bool hasNextInRow = index % 7 != 6;
              final bool periodHasPrevious = hasPreviousInRow &&
                  periodDays.contains(dayNumber - 1);
              final bool periodHasNext = hasNextInRow &&
                  periodDays.contains(dayNumber + 1);
              final bool fertileHasPrevious = hasPreviousInRow &&
                  fertileDays.contains(dayNumber - 1);
              final bool fertileHasNext = hasNextInRow &&
                  fertileDays.contains(dayNumber + 1);

              BorderRadius segmentRadius(bool hasPrevious, bool hasNext) {
                const radius = Radius.circular(16);
                return BorderRadius.horizontal(
                  left: hasPrevious ? Radius.zero : radius,
                  right: hasNext ? Radius.zero : radius,
                );
              }

              return GestureDetector(
                onTap: () => _onDayTap(dayNumber),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. Period days — pink continuous range
                    if (isPeriodRange)
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8BBD0),
                          borderRadius: segmentRadius(
                            periodHasPrevious,
                            periodHasNext,
                          ),
                        ),
                      ),

                    // 2. Fertile window — blue continuous range
                    if (isFertileRange && !isPeriodRange)
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB3E5FC),
                          borderRadius: segmentRadius(
                            fertileHasPrevious,
                            fertileHasNext,
                          ),
                        ),
                      ),

                    // 3. Other cycle days — green, not a guarantee of infertility
                    if (isOtherDay)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                    // 4. Ovulation day
                    if (isOvulationDay)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7E57C2),
                          shape: BoxShape.circle,
                        ),
                      ),

                    // 5. Period start day
                    if (isStartDay)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC2185B),
                          shape: BoxShape.circle,
                        ),
                      ),

                    // 6. Today (ယနေ့ရောက်နေသောရက် - အနားသတ်မျဉ်း)
                    if (isToday && !isStartDay && !isOvulationDay)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFC2185B), width: 1.5),
                          shape: BoxShape.circle,
                        ),
                      ),

                    Text(
                      '$dayNumber',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: (isStartDay || isOvulationDay || isToday) ? FontWeight.bold : FontWeight.w600,
                        color: (isStartDay || isOvulationDay) ? Colors.white : const Color(0xFF4A4A4A),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),

          // 🌟 Calendar အောက်ခြေ Color Legend (အရောင်သတ်မှတ်ချက်များ - ကိုယ်ဝန်မရနိုင်သောရက် အပါအဝင်)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: const [
              _LegendItem(color: Color(0xFFC2185B), label: 'ရာသီစရက်'),
              _LegendItem(color: Color(0xFFF8BBD0), label: 'ရာသီလာရက်များ'),
              _LegendItem(color: Color(0xFFB3E5FC), label: 'ကိုယ်ဝန်ရနိုင်ခြေရှိရက်'),
              _LegendItem(color: Color(0xFF7E57C2), label: 'မျိုးဥကြွေရက်'),
              _LegendItem(color: Color(0xFFE8F5E9), label: 'Fertile window ပြင်ပရက်'),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekdayText extends StatelessWidget {
  final String text;
  const _WeekdayText(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF5F3542), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}