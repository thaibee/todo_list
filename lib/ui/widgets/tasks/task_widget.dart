import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/ui/widgets/tasks/task_widget_model.dart';

class TaskWidgetConfiguration {
  final String title;
  final int groupKey;
  TaskWidgetConfiguration(this.groupKey, this.title);
}

class TaskWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;
  const TaskWidget({Key? key, required this.configuration}) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late final TaskWidgetModel _model;
  @override
  void initState() {
    super.initState();
    _model = TaskWidgetModel(configuration: widget.configuration);
  }

  @override
  void dispose() async {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TaskProvider(
      model: _model,
      child: const _TaskWidgetBody(),
    );
  }
}

class _TaskWidgetBody extends StatelessWidget {
  const _TaskWidgetBody({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    @override
    final model = TaskProvider.watch(context)?.model;
    final title = model?.configuration.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        centerTitle: true,
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _TaskItemWidget(
          taskIndex: index,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 1,
        );
      },
      itemCount: TaskProvider.watch(context)?.model.tasks.length ?? 0,
    );
  }
}

class _TaskItemWidget extends StatelessWidget {
  final int taskIndex;
  const _TaskItemWidget({Key? key, required this.taskIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final model = TaskProvider.watch(context)?.model;
    // final task = model?.tasks[taskIndex].text;
    // return Text('$task');
    final model = TaskProvider.watch(context)!.model;
    final task = model.tasks[taskIndex];
    final icon =
        task.isDone ? Icons.check_box_outlined : Icons.check_box_outline_blank;
    final textColor = task.isDone ? Colors.black26 : Colors.black;
    final textLineT = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteTask(taskIndex),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          task.text,
          style: textLineT,
        ),
        textColor: textColor,
        trailing: Icon(icon),
        onTap: () => TaskProvider.read(context)?.model.toggleDone(taskIndex),
      ),
    );
  }
}
