import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'toDoCard.dart';
import 'task_const.dart';
import 'HiveAdapter.dart';
import 'package:hive/hive.dart';
import 'hive_DataBase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('myBox');
  runApp(
      MaterialApp(
        home: Home(isSwitched: false,),
        debugShowCheckedModeBanner: false,
      ));
}
class Home extends StatefulWidget {
  bool isSwitched;
  Home({required this.isSwitched,super.key});

  @override
  State<Home> createState() => _HomeState();
}
late SharedPreferences sp ;

late List<Task> tasks =[];
late List<Task> filteredTasks = [];
class _HomeState extends State<Home> {

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadHive();
  }
  Future<void> loadHive() async {
    List<Task> retrievedTasks = await HiveData.retrieveHive();
    setState(() {
      tasks = retrievedTasks;
    });
    sp = await SharedPreferences.getInstance();
    widget.isSwitched = sp.getBool("isSwitched")!;
  }

  void onQueryChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTasks.clear();
        filteredTasks = List.from(tasks);

      } else {
        filteredTasks = tasks.where((task) =>
            task.text.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }
  themechange() async {
    sp = await SharedPreferences.getInstance();
    sp.setBool("isSwitched", widget.isSwitched);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:widget.isSwitched? Color(0xff0F0F0F):
      const Color(0xffDCF2F1) ,
      appBar: AppBar(
        backgroundColor:widget.isSwitched? const Color(0xff35455f):
        const Color(0xff7FC7D9),
        title:Text("To Do List",style: TextStyle(
          color:widget.isSwitched? Colors.white: Colors.black,
        ),),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.all(15),
            child: Switch(
                inactiveTrackColor: Color(0xffffffff),
                inactiveThumbColor: Color(0xff7FC7D9),
                trackOutlineColor: MaterialStatePropertyAll( Color(0xffffffff)),
                activeColor: Color(0xff35455f),
                activeTrackColor: Color(0xffffffff),
                value: widget.isSwitched,
                onChanged:(value){
                  setState(() {
                    widget.isSwitched = !widget.isSwitched;
                    themechange();
                  });

                }),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.white,
            ),
            child: TextField(
              controller: searchController,
              onChanged: onQueryChanged,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey[800]),
                border: InputBorder.none,
                icon: Icon(Icons.search),

              ),
            ),
          ),
          Expanded(
            child: ToDoCard(
                tasks1: searchController.text.isEmpty ? tasks : filteredTasks,
                onSaveData: loadHive,
                isSwitched:widget.isSwitched
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final textController = TextEditingController();
          String newTaskText = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) =>
                AlertDialog(
                  backgroundColor: widget.isSwitched? const Color(0xff98a1a5):
                  const Color(0xffa6d0db),
                  title: const Text('Add Task'),
                  content: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                        hintText: 'Enter task description'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: const Text('Cancel',style: TextStyle(color: Colors.black),),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context, textController.text),
                      child: const Text('Add',style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
          );
          setState(() {
            Task newTask = Task(text: newTaskText, checkbox: false);
            HiveData.insertHive(newTask);
            tasks.add(newTask);
            textController.clear();

          });

        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))
        ),
        backgroundColor:widget.isSwitched? const Color(0xff35455f):
        const Color(0xff7FC7D9),
        foregroundColor: Colors.white,
        child:Icon(
          Icons.add,color:widget.isSwitched? Colors.white:
        Colors.black ,size: 30.0,
        ),
      ),



    );
  }
}


