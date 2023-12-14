import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat('d/M/yyyy');
// final formatter = DateFormat('yyyy-MM-dd hh:mm:sss');

const uuid=Uuid();
class Task{
  Task({required this.dueDate,required this.dateAdded,required this.title,required this.description,String ?id}):id=id??uuid.v4();
  String id;
  String title;
  String description;
   DateTime dateAdded;
   DateTime dueDate;

  String get formatteddateAdded{
    return formatter.format(dateAdded);
  }

   String get formatteddueDate{
    return formatter.format(dueDate);
  }

}