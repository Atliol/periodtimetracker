import 'package:hive/hive.dart';

part 'cycle_model.g.dart';

@HiveType(typeId: 0)
class CycleModel extends HiveObject {
  @HiveField(0)
  DateTime startDate; // Period စတင်သည့်ရက်

  @HiveField(1)
  DateTime endDate;   // Period ပြီးဆုံးသည့်ရက် (သို့ တွက်ချက်ထားသောရက်)

  @HiveField(2)
  String note;        // မှတ်စု

  @HiveField(3)
  bool isPeriod;      // Period ရက် ဟုတ်/မဟုတ်

  @HiveField(4)
  bool isOvulation;   // မျိုးဥကြွေရက် ဟုတ်/မဟုတ်

  CycleModel({
    required this.startDate,
    required this.endDate,
    required this.note,
    required this.isPeriod,
    required this.isOvulation,
  });
}