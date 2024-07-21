import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_todo_app/data/local_storage.dart';
import 'package:hive_todo_app/main.dart';
import 'package:hive_todo_app/models/task_model.dart';
import 'package:hive_todo_app/widgets/custom_search_delegate.dart';
import 'package:hive_todo_app/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTask;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTask = <Task>[];
    _getAllTaskFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              _showAddTaskBottomSheet();
            },
            child: Text('title').tr()),
        actions: [
          IconButton(
              onPressed: () {
                _showSearcPage();
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () => _showAddTaskBottomSheet(),
              icon: Icon(Icons.add)),
        ],
      ),
      body: _allTask.isNotEmpty
          ? ListView.builder(
              itemCount: _allTask.length,
              itemBuilder: (context, index) {
                var oAnkiListeElemani = _allTask[index];
                return Dismissible(
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(
                          width: 5,
                        ),
                        Text('remove_task').tr(),
                      ],
                    ),
                    key: Key(oAnkiListeElemani.id),
                    onDismissed: (direction) {
                      _allTask.removeAt(index);
                      _localStorage.deleteTask(task: oAnkiListeElemani);
                      setState(() {});
                    },
                    child: TaskItem(task: oAnkiListeElemani));
              },
            )
          : Center(
              child: Text('empty_task_list').tr(),
            ),
    );
  }

  _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'add_task'.tr(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) async {
                Navigator.of(context).pop();
                var eklenecekTask = Task.create(name: value);
                _allTask.add(eklenecekTask);
                await _localStorage.addTask(task: eklenecekTask);
                setState(() {});
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _getAllTaskFromDb() async {
    _allTask = await _localStorage.getAllTask();
    setState(() {});
  }

  void _showSearcPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTask));
    _getAllTaskFromDb();
  }
}
