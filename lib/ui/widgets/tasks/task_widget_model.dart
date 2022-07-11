import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/ui/entity/task.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';
import 'package:todo_list/ui/widgets/tasks/task_widget.dart';

class TaskWidgetModel extends ChangeNotifier {
  TaskWidgetConfiguration configuration;
  late final Future<Box<Task>> _box;
  var _tasks = <Task>[];
  ValueListenable<Object>? _listenableBox;

  List<Task> get tasks => _tasks.toList();

  TaskWidgetModel({required this.configuration}) {
    _setup();
  }

  @override
  void dispose() async {
    _listenableBox?.removeListener(_readTaskFromHive);
    await BoxManager.instance.closeBox(await _box);
    super.dispose();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.taskForm,
      arguments: configuration,
    );
  }

  Future<void> deleteTask(int taskIndex) async {
    await (await _box).deleteAt(taskIndex);
  }

  Future<void> toggleDone(int taskIndex) async {
    final task = (await _box).getAt(taskIndex);
    task?.isDone = !task.isDone;
    task?.save();
  }

  Future<void> _readTaskFromHive() async {
    _tasks = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openTaskBox(configuration.groupKey);
    await _readTaskFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readTaskFromHive);
  }
}

class TaskProvider extends InheritedNotifier {
  final TaskWidgetModel model;
  const TaskProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static TaskProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskProvider>();
  }

  static TaskProvider? read(BuildContext context) {
    final widget =
        context.getElementForInheritedWidgetOfExactType<TaskProvider>()?.widget;
    return widget is TaskProvider ? widget : null;
  }
}
