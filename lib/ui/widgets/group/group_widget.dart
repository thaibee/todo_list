import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/ui/widgets/group/group_widget_model.dart';

class GroupWidget extends StatefulWidget {
  const GroupWidget({Key? key}) : super(key: key);

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  final _model = GroupWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupProvider(
      model: _model,
      child: const _GroupListWidget(),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Группы'),
        centerTitle: true,
      ),
      body: const _GroupListWidgetBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GroupProvider.read(context)?.model.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GroupListWidgetBody extends StatelessWidget {
  const _GroupListWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.separated(
        itemCount: GroupProvider.watch(context)?.model.groups.length ?? 10,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1);
        },
        itemBuilder: (BuildContext context, int index) {
          return _GroupListRowWidget(
            groupIndex: index,
          );
        },
      ),
    );
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int groupIndex;
  const _GroupListRowWidget({Key? key, required this.groupIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = GroupProvider.watch(context)!.model;
    final group = model.groups[groupIndex].name;
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteGroup(groupIndex),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      child: ListTile(
        title: Text(group),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => model.showTasks(context, groupIndex),
      ),
    );
  }
}
