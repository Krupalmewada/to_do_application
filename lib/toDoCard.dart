import 'package:flutter/material.dart';
import 'package:to_do_application/main.dart';
import 'task_const.dart';
import 'hive_DataBase.dart';


class ToDoCard extends StatefulWidget {
  final List<Task> tasks1;
  final Future<void> Function()? onSaveData;
  final bool isSwitched;
  const ToDoCard({required this.tasks1, required this.onSaveData, Key? key,required this.isSwitched}) : super(key: key);
  @override
  State<ToDoCard> createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasks1.length,
      itemBuilder: (BuildContext context, int index) {
        Task task = widget.tasks1[index] ;
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
            key:  UniqueKey(),
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {

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
                    backgroundColor: widget.isSwitched? const Color(0xff98a1a5):
                    const Color(0xffa6d0db),
                    title: const Text('Edit Task'),
                    content: TextField(
                      controller: textController,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, textController.text),
                        child: const Text('Edit',style: TextStyle(color: Colors.black),),
                      ),
                    ],
                  ),
                ).then((newText1) {
                  if (newText1 != null && newText1.trim().isNotEmpty) {
                    setState(() {
                      if (filteredTasks.isNotEmpty) {
                        int filteredIndex = filteredTasks.indexWhere((filteredTask) => filteredTask.text == task.text);
                        if (filteredIndex != -1) {
                          filteredTasks[filteredIndex] = Task(text: newText1, checkbox: task.checkbox);
                        }
                      }
                      HiveData.updateHive(task.text,Task(text: newText1,checkbox: task.checkbox));
                      widget.onSaveData?.call();

                    });
                  }});}
              else {
                // Handle deletion:
                return await showDialog<bool>(

                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: widget.isSwitched? const Color(0xff98a1a5):
                    const Color(0xffa6d0db),
                    title: const Text('Delete Task'),
                    content: const Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel',style: TextStyle(color: Colors.black),),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                          setState(() {
                            HiveData.deleteHive(task.text);
                            widget.tasks1.removeAt(index);
                            widget.onSaveData?.call();
                          });
                        },
                        child: const Text('Delete',style: TextStyle(color: Colors.black),),
                      ),

                    ],

                  ),
                );

              };


            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                tileColor: Colors.white,
                leading:Checkbox(
                  value: task.checkbox, // Use value directly
                  activeColor: widget.isSwitched? const Color(0xff000000): const Color(0xff7FC7D9),
                  onChanged: (newBool) {
                    setState(() {
                      task.checkbox = newBool!;
                      // DatabaseHelper.updateTask(task.text, task);
                      HiveData.updateHive(task.text, task);
                      widget.onSaveData?.call();
                    });
                  },
                ),
                title: Text(task.text,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            )

        );


      },


    );
  }

}







