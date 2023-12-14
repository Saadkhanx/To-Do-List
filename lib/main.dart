import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/todo_list.dart';

void main() {

  runApp(
    ProviderScope(
      child: MaterialApp(theme: ThemeData(useMaterial3: true),
        home: TodoList(),
      ),
    ),
  );
}
