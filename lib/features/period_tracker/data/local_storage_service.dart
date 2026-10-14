import 'package:hive/hive.dart';
import '../domain/cycle_model.dart';

class LocalStorageService {
  static const String boxName = 'cycle_box';

  static Future<void> saveCycle(CycleModel cycle) async {
    final box = Hive.box<CycleModel>(boxName);
    await box.add(cycle);
  }

  static List<CycleModel> getAllCycles() {
    final box = Hive.box<CycleModel>(boxName);
    return box.values.toList();
  }

  static Future<void> deleteCycle(int index) async {
    final box = Hive.box<CycleModel>(boxName);
    await box.deleteAt(index);
  }
}