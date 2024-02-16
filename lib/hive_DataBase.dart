import 'package:hive/hive.dart';
import 'task_const.dart';
class HiveData{

  static Future<void> insertHive(Task task) async {
    final box1 = await Hive.openBox<Task>('myBox');
    await box1.add(task);
  }

  static Future<void> updateHive(String oldtext, Task newTask) async {
    final box1 = await Hive.openBox<Task>('myBox');
    final taskIndex = box1.values.toList().indexWhere((task) => task.text == oldtext);
    await box1.putAt(taskIndex, newTask);
  }

  static Future<void> deleteHive(String text) async {
    final box1 = await Hive.openBox<Task>('myBox');
    final taskIndex = box1.values.toList().indexWhere((task) => task.text == text);
    await box1.deleteAt(taskIndex);

  }

  static Future<List<Task>> retrieveHive() async {
    final box = await Hive.openBox<Task>('myBox');
    return box.values.toList();
  }
}