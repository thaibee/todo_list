import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/group/group_widget.dart';
import 'package:todo_list/ui/widgets/group_form/group_form.dart';
import 'package:todo_list/ui/widgets/tasks/task_widget.dart';
import 'package:todo_list/ui/widgets/task_form/task_form.dart';

abstract class MainNavigationRouteNames {
  static const groups = '/';
  static const groupForm = '/Form';
  static const tasks = '/tasks';
  static const taskForm = '/tasks/form';
}

class MainNavigation {
  final initialRoute = MainNavigationRouteNames.groups;

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.groups: (context) => const GroupWidget(),
    MainNavigationRouteNames.groupForm: (context) => const FormGroupWidget(),
  };
}

Route<Object> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case MainNavigationRouteNames.tasks:
      final configuration = settings.arguments as TaskWidgetConfiguration;
      return MaterialPageRoute(
        builder: (context) => TaskWidget(configuration: configuration),
      );
    case MainNavigationRouteNames.taskForm:
      final configuration = settings.arguments as TaskWidgetConfiguration;
      return MaterialPageRoute(
        builder: (context) => TaskFormWidget(configuration: configuration),
      );
    default:
      const widget = Text('Navigation error');
      return MaterialPageRoute(builder: (context) => widget);
  }
}
