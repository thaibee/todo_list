import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/ui/entity/group.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';
import 'package:todo_list/ui/widgets/tasks/task_widget.dart';

class GroupWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;

  List<Group> get groups => _groups.toList();
  GroupWidgetModel() {
    _setup();
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    BoxManager.instance.closeBox(await _box);
    super.dispose();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupForm);
  }

  Future<void> showTasks(BuildContext context, groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null) {
      final configuration = TaskWidgetConfiguration(group.key, group.name);
      Navigator.of(context)
          .pushNamed(MainNavigationRouteNames.tasks, arguments: configuration);
    }
  }

  Future<void> deleteGroup(groupKey) async {
    final box = await _box;
    final taskBoxName = BoxManager.instance.taskListName(groupKey);
    Hive.deleteBoxFromDisk(taskBoxName);
    box.deleteAt(groupKey);
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> _setup() async {
    _box = BoxManager.instance.openGroupBox();
    await _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }
}

class GroupProvider extends InheritedNotifier {
  final GroupWidgetModel model;
  const GroupProvider({Key? key, required this.model, required Widget child})
      : super(key: key, notifier: model, child: child);

  static GroupProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GroupProvider>();
  }

  static GroupProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupProvider>()
        ?.widget;
    return widget is GroupProvider ? widget : null;
  }
}
