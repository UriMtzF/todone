import 'package:flutter/material.dart';
import 'package:todone/database/database.dart';
import 'package:todone/i18n/strings.g.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final database = AppDatabase();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: database.select(database.todoItems).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Stack(
          children: [
            if (snapshot.data!.isEmpty)
              Center(
                child: Text(context.t.list.noItems),
              )
            else
              ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Text(snapshot.data![index].title);
                },
              ),
            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                onPressed: () async {
                  await database.into(database.todoItems).insert(
                        TodoItemsCompanion.insert(
                          title: 'Otra tarea de prueba',
                        ),
                      );

                  setState(() {});
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      },
    );
  }
}
