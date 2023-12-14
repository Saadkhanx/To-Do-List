import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/models/task.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list/providers/user_tasks.dart';

class NewTask extends ConsumerStatefulWidget {
  NewTask(this.editTask,this.index, {super.key});
  // void Function(Task newtask) createTask;
  Task? editTask;
  final index;
  @override
  ConsumerState<NewTask> createState() {
    return _NewTaskState();
  }
}

class _NewTaskState extends ConsumerState<NewTask> {
  DateTime? dateAdded;
  DateTime? dueDate;
  final _titleController = TextEditingController();
  final _desController = TextEditingController();

  @override
   
   bool isEdit=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.editTask!=null){
      Task task=widget.editTask!;
      isEdit=true;
      final title=task.title;
      final description=task.description;
      _titleController.text=title;
      _desController.text=description;
      
       dateAdded=task.dateAdded;
       dueDate=task.dueDate;
       

    }
  }

  void dateAddedPicker() async {
    var now = DateTime.now();
    var firstDate = DateTime(now.year - 1);
    var lastDate = DateTime(now.year + 1);
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      dateAdded = pickedDate;
    });
  }

  void dueDatePicker() async {
    var now = DateTime.now();
    var firstDate = DateTime(now.year - 1);
    var lastDate = DateTime(now.year + 1);
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      dueDate = pickedDate;
    });
  }

  var _isSending = false;


  void submitTaskData() async {

    setState(() {
      _isSending = true;
    });

    if (_titleController.text.trim().isEmpty ||
        _desController.text.trim().isEmpty ||
        dateAdded == null ||
        dueDate == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text(
                    "Invalid Input, Please Recheck All The Values and Try Again.",
                    style: GoogleFonts.notoSansJavanese(
                        fontSize: 14, color: Color.fromARGB(255, 82, 61, 0))),
                title: Text(
                  'Invalid Input',
                  style: GoogleFonts.abhayaLibre(
                      fontSize: 32, color: Color.fromARGB(255, 119, 90, 3)),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Okay',
                        style: GoogleFonts.andika(
                            color: Color.fromARGB(255, 82, 61, 0),
                            fontSize: 15),
                      ))
                ],
              ));
    } else {
      // final index=isEdit?
      if(isEdit){
        // ref.read(userTaskprovider.notifier).removeTask(widget.editTask!.id);
      }
      ref.read(userTaskprovider.notifier).addTask(Task(
          
          dueDate: dueDate!,
          dateAdded: dateAdded!,
          title: _titleController.text,
          description: _desController.text),widget.index);
      


      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(_titleController);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 20,
              decoration: InputDecoration(
                label: Text(
                  'Title:',
                  style: GoogleFonts.lato(
                      fontSize: 18, color: Color.fromARGB(255, 119, 90, 3)),
                ),
              ),
            ),
            TextField(
              controller: _desController,
              maxLength: 120,
              decoration: InputDecoration(
                label: Text('Description:',
                    style: GoogleFonts.lato(
                        fontSize: 18, color: Color.fromARGB(255, 119, 90, 3))),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  dateAdded == null
                      ? "Select Starting Date"
                      : formatter.format(dateAdded!),
                  style: GoogleFonts.andika(
                      color: Color.fromARGB(255, 82, 61, 0), fontSize: 15),
                ),
                IconButton(
                  onPressed: dateAddedPicker,
                  icon: const Icon(Icons.calendar_month),
                ),
                Spacer(),
                Text(
                    dueDate == null
                        ? "Select Due Date"
                        : formatter.format(dueDate!),
                    style: GoogleFonts.andika(
                        color: Color.fromARGB(255, 82, 61, 0), fontSize: 15)),
                IconButton(
                  onPressed: dueDatePicker,
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: 
                       () {
                          Navigator.pop(context);
                        },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.andika(
                        color: Color.fromARGB(255, 82, 61, 0), fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return null;
                        }
                        return Color.fromARGB(
                            255, 252, 236, 188); // Use the component's default.
                      },
                    ),
                  ),
                  onPressed:
                      // print(_titleController.text),
                      submitTaskData,
                  child: Text(isEdit?'Update':
                          'Submit',
                          style: GoogleFonts.andika(
                              color: Color.fromARGB(255, 82, 61, 0),
                              fontSize: 15),
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
