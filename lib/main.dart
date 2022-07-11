import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/ui/widgets/app/todo_app.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const ToDoApp());
}
