import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_const.dart';

class TaskManager {
  late SharedPreferences sp;

  Future<void> initSharedPreferences() async {
    sp = await SharedPreferences.getInstance();
  }

  Future<void> saveData(List<Task> tasks) async {

    List<String> taskStrings = tasks.map((task) => jsonEncode(task.toMap())).toList();
    await sp.setStringList('tasks', taskStrings);

    // Save checkbox status separately
    List<String> checkboxStatus = tasks.map((task) => task.checkbox.toString()).toList();
    await sp.setStringList('checkboxStatus', checkboxStatus);
  }

  Future<List<Task>> loadData() async {
    List<String>? taskStrings = sp.getStringList('tasks');
    List<String>? checkboxStatus = sp.getStringList('checkboxStatus');

    if (taskStrings != null && checkboxStatus != null && taskStrings.length == checkboxStatus.length) {
      List<Task> tasks = [];
      for (int i = 0; i < taskStrings.length; i++) {
        Map<String, dynamic> taskMap = jsonDecode(taskStrings[i]);
        tasks.add(Task(text: taskMap.keys.first, checkbox: checkboxStatus[i] == 'true'));
      }
      return tasks;
    } else {
      return [];
    }
  }
}
