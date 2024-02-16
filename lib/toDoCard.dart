import 'package:flutter/material.dart';
import 'saveData.dart';
import 'task_const.dart';
import 'main.dart';

class ToDoCard extends StatefulWidget {
  final List<Task> tasks1;
  final Future<void> Function()? onSaveData;
  final bool isSwitched;
  // const ToDoCard(this.tasks, {required this.onSaveData,super.key});
  const ToDoCard({required this.tasks1, required this.onSaveData, Key? key, required this.isSwitched})
      : super(key: key);
  @override
  State<ToDoCard> createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {
  late TaskManager taskManager;

  @override
  void initState() {
    super.initState();
    taskManager = TaskManager();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasks1.length,
      itemBuilder: (BuildContext context, int index) {
        Task task = widget.tasks1[index] as Task;
        Widget slideRightBackground() {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            color: Colors.green,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 2,
                  ),
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  Text(
                    " Edit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          );
        }

        Widget slideLeftBackground() {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Text(
                    " Delete",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          );
        }

        return Dismissible(
            key: UniqueKey(),
            // key: ValueKey(widget.l1[index]),
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                // setState(() {
                //   // widget.tasks1.removeAt(index);
                //   // widget.onSaveData?.call();
                //   // taskManager.saveData(widget.tasks1.cast<Task>());
                //
                // });
              }
            },
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                String lastData = widget.tasks1[index].text;
                final textController = TextEditingController(text: lastData);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Edit Task'),
                    content: TextField(
                      controller: textController,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, textController.text),
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                ).then((newText1) {
                  if (newText1 != null && newText1.trim().isNotEmpty) {
                    setState(() {
                      if (newText1 != null && newText1.trim().isNotEmpty) {
                        setState(() {
                          // Update the task text in the list
                          widget.tasks1[index].text = newText1;
                        });
                        // Save the updated task data
                        widget.onSaveData?.call();
                        taskManager.saveData(widget.tasks1.cast<Task>());
                      }
                    });
                  }
                });
              } else {
                // Handle deletion:
                return await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Task'),
                    content: const Text(
                        'Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                          setState(() {
                            if (filteredTasks.isNotEmpty) {
                              var text1 = widget.tasks1[index].text;
                              int og_lis_ind = tasks.indexWhere((task) => task.text == text1);
                              tasks.removeAt(og_lis_ind);
                            }
                            widget.tasks1.removeAt(index);
                            taskManager.saveData(widget.tasks1.cast<Task>());

                          });widget.onSaveData?.call();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              }
              ;
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                tileColor: Colors.white,
                leading: Checkbox(
                  value: task.checkbox, // Use value directly
                  activeColor: widget.isSwitched
                      ? const Color(0xff000000)
                      : const Color(0xff7FC7D9),
                  onChanged: (newBool) {
                    setState(() {
                      task.checkbox = newBool!;
                      widget.onSaveData?.call();
                      taskManager.saveData(widget.tasks1.cast<Task>());
                    });
                  },
                ),
                title: Text(
                  task.text,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ));
      },
    );
  }
}
