import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final myTasks = Hive.box('tasks');
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  bool changeState = false;

  int? key;
  //======================Add Notes===========================
  Future<dynamic> addTask(Map<String, dynamic> task) async {
    await myTasks.add(task);
    log(myTasks.length.toString());
    setState(() {});
  }
  //============filter==========================

  Future<dynamic> filterTasks(String query) async {
    final data = myTasks.keys.map((key) {
      final value = myTasks.get(key);
      return {
        "key": key,
        "title": value['title'],
        "content": value['content'],
        "date": value['date']
      };
    }).toList();
    setState(() {
      tasks =
          data.where((element) => element['title'].contains(query)).toList();
    });
  }

  //===================get Notes==============================
  Future<dynamic> getTasks() async {
    tasks.clear();
    final data = myTasks.keys.map((key) {
      final value = myTasks.get(key);
      return {
        "key": key,
        "title": value['title'],
        "content": value['content'],
        "date": value['date']
      };
    }).toList();

    setState(() {
      tasks = data;
    });
  }

  //edit notes
  Future<dynamic> editTask(int index) async {
    await myTasks.put(index, {
      'title': titleController.text,
      'content': contentController.text,
      "date": formatter.format(now),
    });
    getTasks();
  }

  //==================   Delete Notes==========================
  Future<dynamic> deleteNotes(int index) async {
    await myTasks.deleteAt(index);
    getTasks();
  }

  //=======================================================
  void showAddNote(BuildContext context) {
    //===========================Show Dialog=============================================
    showModalBottomSheet(
        backgroundColor: HexColor("f0f8ff"),
        context: context,
        builder: (context) {
          return Container(
              padding: const EdgeInsets.all(16),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: ' Title'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(hintText: ' Content'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: changeState == true
                          ? Colors.deepPurple
                          : Colors.black,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          contentController.text.isNotEmpty &&
                          changeState == false) {
                        addTask({
                          'title': titleController.text,
                          'content': contentController.text,
                          "date": formatter.format(now),
                        });
                        titleController.clear();
                        contentController.clear();
                        Navigator.of(context).pop();
                        getTasks();
                        setState(() {
                          changeState = !changeState;
                        });
                      } else {
                        editTask(key!);
                        titleController.clear();
                        contentController.clear();
                        Navigator.of(context).pop();
                        getTasks();
                        setState(() {
                          changeState = !changeState;
                        });
                      }
                    },
                    child: Text(
                      changeState == false ? 'Add Task' : 'Edit Task',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    )),
                const SizedBox(height: 16),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      titleController.clear();
                      contentController.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ))
              ]));
        });
  }

//==========================================================================================
  @override
  void initState() {
    getTasks();
    super.initState();
  }

  @override
  void dispose() {
    titleController.clear();
    contentController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("f5f5dc"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        onPressed: () {
          titleController.clear();
          contentController.clear();
          setState(() {
            changeState = false;
          });
          showAddNote(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: HexColor("f5f5dc"),
        centerTitle: true,
        title: const Text(
          'Daily Tasks',
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: HexColor("485058"),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: InputBorder.none),
                onChanged: (value) {
                  filterTasks(value);
                },
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => SizedBox(
                width: double.infinity,
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: ListTile(
                      tileColor: Colors.white,
                      title: Text(
                        tasks[index]['title'],
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "${tasks[index]['content']} ",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis)),
                      ])),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                deleteNotes(index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )), //Spacer(flex: 1,)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  changeState = true;
                                });
                                titleController.text = tasks[index]['title'];
                                contentController.text =
                                    tasks[index]['content'];
                                key = tasks[index]['key'];
                                showAddNote(context);
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.green,
                              )),
                        ],
                      ),
                      leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  DateFormat(DateFormat.ABBR_MONTH).format(
                                      DateTime.parse(tasks[index]['date'])),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  DateFormat(DateFormat.DAY).format(
                                      DateTime.parse(tasks[index]['date'])),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ), //Text("$
                          ))),
                ),
              ),
              itemCount: tasks.length,
            ),
          ],
        ),
      ),
    );
  }
}
