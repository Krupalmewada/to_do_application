import 'package:hive/hive.dart';
import 'task_const.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0; // Unique identifier

  @override
  Task read(BinaryReader reader) {
    // print(reader.readString());
    return Task(
      text: reader.readString(),
      checkbox: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeString(obj.text);
    writer.writeBool(obj.checkbox);
  }
}
