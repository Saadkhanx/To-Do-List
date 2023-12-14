import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:sqflite/sqflite.dart'as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart'as path;

Future<Database>_getDatabase()async{
final dbPath=await sql.getDatabasesPath();

  final db=await sql.openDatabase(path.join(dbPath,'tasks.db'),onCreate: (db, version) {
     return db.execute('CREATE TABLE user_tasks(id TEXT PRIMARY KEY,title TEXT,description TEXT,dateAdded INTEGER,dueDate INTEGER)');

   },version: 1);
   return db;
}

class UserTasksNotifier extends StateNotifier<List<Task>>{
  UserTasksNotifier() :super(const []);

  Future<void> loadPlaces()async{
    final db=await _getDatabase();
    final data=await db.query('user_tasks');
   final tasks= data.map((item) => Task(id: item['id'] as String,dueDate: DateTime.fromMillisecondsSinceEpoch(item['dueDate'] as int), dateAdded: DateTime.fromMillisecondsSinceEpoch(item['dateAdded']as int), title: item['title'] as String, description: item['description'] as String)).toList();
   
   tasks.forEach((element) {print(element.title);});

   state=[...tasks];
  }

  // void addTask(Task task){
  //   state=[...state,task];
  // }
  void removeTask(String id)async{
    state=state.where((element) => id!=element.id).toList();
    final db=await _getDatabase();
    await db.delete('user_tasks',where: 'id=?',whereArgs: [id]);
    
  }
 void addTask(Task task,int index)async{
   final newDateAdded=task.dateAdded.millisecondsSinceEpoch;
   final newDueDate=task.dueDate.millisecondsSinceEpoch;

   
   final db=await _getDatabase();


  final list=state;
  // final index=list.indexOf(task);
  if(index==-1){
  await db.insert('user_tasks', {
    'id':task.id,
    'title':task.title,
    'description':task.description,
    'dateAdded':newDateAdded,
    'dueDate':newDueDate,
   });
    state=[...state,task];

  }
  else {
    final id=list[index].id;
    final title=list[index].title;
   await db.update('user_tasks', 
      where: 'id=?',whereArgs: [id],
   {
    'title':task.title,
    'description':task.description,
    'dateAdded':newDateAdded,
    'dueDate':newDueDate,},
     );
    // print(db.query('user_tasks').toString());

    // list.insert(index, task);
    // for(int i=0;i<list.length;i++){
    //   if(list[i].id==id){
    //     list[i].title=task.title;
    //     list[i].description=task.description;
    //     list[i].dateAdded=task.dateAdded;
    //     list[i].dueDate=task.dueDate;
    //   }
    // }
        list[index].title=task.title;
        list[index].description=task.description;
        list[index].dateAdded=task.dateAdded;
        list[index].dueDate=task.dueDate;
        // print(task.title);
        // print(title);
        // print(list[index].title);
        loadPlaces();
        
  
    state=[...list];
  }

 }

}

final userTaskprovider=StateNotifierProvider<UserTasksNotifier,List<Task>>((ref) => UserTasksNotifier());