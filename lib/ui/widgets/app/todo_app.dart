import 'package:flutter/material.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';

class ToDoApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();

  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
