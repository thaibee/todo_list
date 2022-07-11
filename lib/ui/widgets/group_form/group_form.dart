import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/group_form/group_form_model.dart';

class FormGroupWidget extends StatefulWidget {
  const FormGroupWidget({Key? key}) : super(key: key);

  @override
  State<FormGroupWidget> createState() => _FormGroupWidgetState();
}

class _FormGroupWidgetState extends State<FormGroupWidget> {
  final _model = FormGroupModel();
  @override
  Widget build(BuildContext context) {
    return FormGroupProvider(model: _model, child: const FormGroupWidgetBody());
  }
}

class FormGroupWidgetBody extends StatelessWidget {
  const FormGroupWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Добавить группу'),
      ),
      body: const FormWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            FormGroupProvider.read(context)?.model.saveGroup(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class FormWidget extends StatelessWidget {
  const FormWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = FormGroupProvider.watch(context)?.model;
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Имя группы',
          errorText: model?.errorMessage,
        ),
        autofocus: true,
        onChanged: (value) => model?.groupName = value,
        onEditingComplete: () => model?.saveGroup(context),
      ),
    ));
  }
}
