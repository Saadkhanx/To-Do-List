import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/new_task.dart';


class TaskCard extends StatefulWidget {
  TaskCard(this.newTask,this.index, {super.key});
  Task newTask;
  final index;
  // List<Task> tasklist;
  


  @override
  State<StatefulWidget> createState() {
    return _TaskCard();
  }
}

class _TaskCard extends State<TaskCard> {
  var cardColor = Colors.amber[50];
  var statusText = "Pending...";
  

  void checkDate() {
    if ((widget.newTask.dateAdded.day > widget.newTask.dueDate.day ||
        widget.newTask.dateAdded.month > widget.newTask.dueDate.month ||
        widget.newTask.dateAdded.year > widget.newTask.dueDate.year)||
        (widget.newTask.dueDate.day < DateTime.now().day ||
        widget.newTask.dueDate.month <  DateTime.now().month ||
        widget.newTask.dueDate.year < DateTime.now().year)
        ) {
      setState(() {
        cardColor = Color.fromARGB(110, 216, 215, 215);
        // cardColor=Colors.grey[400];
        statusText = "Task Failed!";
      });
    }
  }

  void onDone() {
    setState(() {
      cardColor = Color.fromARGB(255, 168, 245, 161);
      statusText = "Task Completed!";
    });
  }

void editTask(){
  Navigator.push(context, MaterialPageRoute(builder:(context) => NewTask( widget.newTask,widget.index),));
}


  @override
  Widget build(BuildContext context) {
    checkDate();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child:
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.newTask.title,
                        style: GoogleFonts.abhayaLibre(
                            fontSize: 30,
                            color: Color.fromARGB(255, 119, 90, 3)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(widget.newTask.description,
                          style: GoogleFonts.notoSansJavanese(
                              fontSize: 14,
                              color: Color.fromARGB(255, 82, 61, 0))),
                    ],
                  ),
                ),
              ),
              // Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(

                child: 
                Column(
                
                  children: [
                    Text(
                      'Start Date: ${widget.newTask.formatteddateAdded}',
                      style: GoogleFonts.andika(
                          color: Color.fromARGB(255, 82, 61, 0), fontSize: 15),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text('Due Date: ${widget.newTask.formatteddueDate}',
                        style: GoogleFonts.andika(
                            color: Color.fromARGB(255, 82, 61, 0),
                            fontSize: 15)),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      statusText,
                      style: GoogleFonts.andika(
                          color: Color.fromARGB(255, 82, 61, 0), fontSize: 15),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                     
                      children: [
                        ElevatedButton(
                          onPressed: editTask,
                          child: const Icon(Icons.edit_outlined,
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        ElevatedButton(
                          onPressed: onDone,
                          child: const Icon(Icons.done, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
