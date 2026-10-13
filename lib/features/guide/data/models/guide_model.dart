import 'package:hive/hive.dart';

part 'guide_model.g.dart'; // build_runner ဖြင့် အလိုအလျောက် ထွက်လာမည့် file

@HiveType(typeId: 0)
class GuideModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final String category;

  GuideModel({
    required this.title,
    required this.content,
    required this.category,
  });
}