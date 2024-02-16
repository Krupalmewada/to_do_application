import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String text;

  @HiveField(1)
  late bool checkbox;

  Task({required this.text, required this.checkbox});
}
