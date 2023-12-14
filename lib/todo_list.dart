import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/providers/user_tasks.dart';
import 'package:todo_list/task_list.dart';
import 'package:todo_list/new_task.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class TodoList extends ConsumerStatefulWidget {
  @override
  ConsumerState<TodoList> createState() {
    return _TodoListState();
  }
}

class _TodoListState extends ConsumerState<TodoList> {
  late Future <void>_tasksFuture;
  List<Task>_tasks=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tasksFuture=ref.read(userTaskprovider.notifier).loadPlaces();
  }



  void modalOverlay() async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NewTask(
        null,-1
        
      ),
    ));
  }

  // void addTask(Task newtask) {
  //   setState(() {
  //     _tasks.add(newtask);
  //   });
  // }

  bool check1 = false;

  void deleteTask(Task newtask) {

    final index=_tasks.indexOf(newtask);
    ref.read(userTaskprovider.notifier).removeTask(newtask.id);
    // setState(() {
    //   _tasks.remove(newtask);
    // });
    

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task Deleted'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // setState(() {
            //   _tasks.insert(index,newtask);
            // });
            ref.read(userTaskprovider.notifier).addTask(newtask,-1);

            check1 = true;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget maincontent = Center(
      child: Text('No Tasks Found,Start Adding Some!'),
    );
   final userTasks= ref.watch(userTaskprovider);
   
    if (userTasks.isNotEmpty) {
      setState(() {
        _tasks=userTasks;
        maincontent = 
       FutureBuilder(future: _tasksFuture, builder: (context, snapshot) => snapshot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator(),):TaskList(
          userTasks,
          deleteTask,
        ));
      });
    }
 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        title: Text(
          'To-Do List',
          style: GoogleFonts.abhayaLibre(
            fontSize: 36,
            color: Color.fromARGB(255, 16, 0, 53),
          ),
        ),
      ),
      body: Column(children: [
        SizedBox(
          height: 16,
        ),
        Expanded(child: maincontent ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          // mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
                onPressed: () {
                  modalOverlay();
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.amber[200]),
            const SizedBox(
              width: 25,
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ]),
    );
  }
}
