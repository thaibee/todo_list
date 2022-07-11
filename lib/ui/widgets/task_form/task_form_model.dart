import 'package:flutter/material.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/ui/entity/task.dart';
import 'package:todo_list/ui/widgets/tasks/task_widget.dart';

class TaskFormModel extends ChangeNotifier {
  var _taskText = '';
  final TaskWidgetConfiguration configuration;
  bool get isValid => _taskText.trim().isNotEmpty;

  TaskFormModel({required this.configuration});

  set taskText(String value) {
    final isTaskTextEmpty = _taskText.trim().isEmpty;
    _taskText = value;
    if (value.trim().isEmpty != isTaskTextEmpty) {
      notifyListeners();
    }
  }

  Future<void> saveTask(BuildContext context) async {
    if (_taskText.isEmpty) return;

    final task = Task(text: _taskText, isDone: false);
    final box = await BoxManager.instance.openTaskBox(configuration.groupKey);
    await box.add(task);
    BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class TaskFormProvider extends InheritedNotifier {
  final TaskFormModel model;
  const TaskFormProvider({Key? key, required this.model, required Widget child})
      : super(key: key, child: child, notifier: model);

  static TaskFormProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskFormProvider>();
  }

  static TaskFormProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormProvider>()
        ?.widget;
    return widget is TaskFormProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
