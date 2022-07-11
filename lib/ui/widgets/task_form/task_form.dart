import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/task_form/task_form_model.dart';
import 'package:todo_list/ui/widgets/tasks/task_widget.dart';
import 'package:todo_list/ui/widgets/tasks/task_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;
  const TaskFormWidget({Key? key, required this.configuration})
      : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  TaskFormModel? _model;
  @override
  void initState() {
    super.initState();
    TaskFormWidget(configuration: widget.configuration);
  }

  @override
  void didChangeDependencies() {
    _model ??= TaskFormModel(configuration: widget.configuration);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormProvider(
      model: _model!,
      child: const _TaskFormWidgetBody(),
    );
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  const _TaskFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = TaskFormProvider.watch(context)?.model;
    final isValid = _model?.isValid;
    final floatButton = FloatingActionButton(
      onPressed: () => _model?.saveTask(context),
      child: const Icon(Icons.done),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Новая задача'),
          centerTitle: true,
        ),
        body: _FormWidget(),
        floatingActionButton: _model?.isValid == true ? (floatButton) : null);
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormProvider.read(context)?.model;
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
          hintText: 'Введите задачу', contentPadding: EdgeInsets.all(15)),
      autofocus: true,
      expands: true,
      maxLines: null,
      minLines: null,
      onChanged: (value) => model?.taskText = value,
      onEditingComplete: () =>
          TaskFormProvider.read(context)?.model.saveTask(context),
    );
  }
}
