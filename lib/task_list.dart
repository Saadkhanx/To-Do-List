import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/providers/user_tasks.dart';
import 'package:todo_list/task_card.dart';

class TaskList extends ConsumerWidget {
  TaskList(this.tasklist, this.removeTask, {super.key});
  List<Task> tasklist;
  void Function(Task task) removeTask;
  

  @override
  Widget build(BuildContext context,WidgetRef ref) {
  //  final userTasks= ref.watch(userTaskprovider);
  // if(tasklist.isEmpty){
  //   return Center(child: Text('No Tasks Found,Start Adding Some!'),);
  // }
    return ListView.builder(
      itemCount: tasklist.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(tasklist[index]),
        child: TaskCard(
          tasklist[index],
          index,
        
        ),
        onDismissed: (direction) {
          removeTask(tasklist[index]);
        },
      ),
    );
  }
}
