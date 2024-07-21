import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_todo_app/data/local_storage.dart';
import 'package:hive_todo_app/main.dart';
import 'package:hive_todo_app/models/task_model.dart';
import 'package:hive_todo_app/widgets/task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});

  //Search açılırken sağda olması gereken widgetler
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: Icon(Icons.clear)),
    ];
  }

  //Search açılırken solda olması gereken widget
  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 24,
        ));
  }

  //Search kısmına bir şey yazıp arama tuşuna bastığımızda bize ilgili sonucu gösterir
  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var oAnkiListeElemani = filteredList[index];
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
                  onDismissed: (direction) async {
                    filteredList.removeAt(index);
                    await locator<LocalStorage>()
                        .deleteTask(task: oAnkiListeElemani);
                  },
                  child: TaskItem(task: oAnkiListeElemani));
            },
          )
        : Center(
            child: Text('search_not_found').tr(),
          );
  }

  //Search kısmına daha yazmayı  bitirmeden bize uygun sonuçları getirmeye başlar
  @override
  Widget buildSuggestions(BuildContext context) {
    // Arama sorgusu boşsa öneri gösterme
    if (query.isEmpty) {
      return Center(
        child: Text('search_not_found').tr(),
      );
    }

    // Kullanıcının yazdığı terime göre filtreleme
    List<Task> filteredList = allTask
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var oAnkiListeElemani = filteredList[index];
              return TaskItem(task: oAnkiListeElemani);
            },
          )
        : Center(child: Text('search_not_found').tr());
  }
}
