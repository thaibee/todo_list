import 'package:flutter/material.dart';
import 'package:todo_list/domain/data_provider/box_manager.dart';
import 'package:todo_list/ui/entity/group.dart';

class FormGroupModel extends ChangeNotifier {
  var _groupName = '';
  String? errorMessage;

  set groupName(String value) {
    if (errorMessage != null && value.trim().isNotEmpty) {
      errorMessage = null;
      notifyListeners();
    }
    _groupName = value.trim();
  }

  void saveGroup(BuildContext context) async {
    final groupName = _groupName.trim();
    if (groupName.isEmpty) {
      errorMessage = 'Введите название группы';
      notifyListeners();
      return;
    }

    final box = await BoxManager.instance.openGroupBox();
    final group = Group(name: _groupName);
    await box.add(group);
    await BoxManager.instance.closeBox(box);
    Navigator.of(context).pop();
  }
}

class FormGroupProvider extends InheritedNotifier {
  final FormGroupModel model;
  const FormGroupProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, child: child, notifier: model);

  static FormGroupProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FormGroupProvider>();
  }

  static FormGroupProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<FormGroupProvider>()
        ?.widget;
    return widget is FormGroupProvider ? widget : null;
  }
}
