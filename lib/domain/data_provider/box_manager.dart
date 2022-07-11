import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/ui/entity/group.dart';
import 'package:todo_list/ui/entity/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  BoxManager._();

  final Map<String, int> _boxCounter = <String, int>{};

  String taskListName(int groupKey) => 'task_list$groupKey';

  Future<Box<Group>> openGroupBox() async {
    return _openBox('group_list', 0, GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox(taskListName(groupKey), 1, TaskAdapter());
  }

  Future<Box<T>> _openBox<T>(
      String name, int typeId, TypeAdapter<T> adapter) async {
    if (Hive.isBoxOpen(name)) {
      final count = _boxCounter[name] ?? 1;
      _boxCounter[name] = count + 1;
      return Hive.box(name);
    }

    _boxCounter[name] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(name);
  }

  Future<void> closeBox<T>(Box<T> box) async {
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
      return;
    }
    var count = _boxCounter[box.name] ?? 1;
    count -= 1;
    _boxCounter[box.name] = count;
    if (count > 0) return;
    _boxCounter.remove(box.name);
    await box.compact();
    await box.close();
  }
}
