import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'task_const.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'tasks';
  DatabaseHelper._();

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'ToDoTasks.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tableName(text TEXT PRIMARY KEY, checkbox INTEGER)',
        );
      },
      version: 1,
    );

    return _database!;
  }


  static Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(
      _tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,

    );
  }

  static Future<void> updateTask(String oldText, Task newTask) async {
    final db = await database;
    await db.update(
      _tableName,
      newTask.toMap(),
      where: 'text = ?',
      whereArgs: [oldText], // Use the old text as the WHERE clause
    );
  }
  static Future<void> deleteTask(String text) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'text = ?',
      whereArgs: [text],
    );
  }

  static Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Task(
        text: maps[i]['text'],
        checkbox: maps[i]['checkbox'] == 1 ? true : false,
      );
    });
  }
}