// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hive_todo_app/data/local_storage.dart';
import 'package:hive_todo_app/main.dart';

import 'package:hive_todo_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _taskNameController = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    _taskNameController.text = widget.task.name;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
            )
          ]),
      child: ListTile(
        title: widget.task.isCompleted
            ? Text(widget.task.name,
                style: TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey))
            : _buildTextField(
                taskNameController: _taskNameController,
                widget: widget,
                localStorage: _localStorage),
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted = !widget.task.isCompleted;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              color: widget.task.isCompleted ? Colors.green : Colors.white,
              border: Border.all(color: Colors.grey, width: 0.8),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _buildTextField extends StatelessWidget {
  const _buildTextField({
    super.key,
    required TextEditingController taskNameController,
    required this.widget,
    required LocalStorage localStorage,
  })  : _taskNameController = taskNameController,
        _localStorage = localStorage;

  final TextEditingController _taskNameController;
  final TaskItem widget;
  final LocalStorage _localStorage;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.done,
      minLines: 1,
      maxLines: null,
      controller: _taskNameController,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      onSubmitted: (yeniDeger) {
        widget.task.name = yeniDeger;
        _localStorage.updateTask(task: widget.task);
      },
    );
  }
}
