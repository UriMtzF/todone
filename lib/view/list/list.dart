import 'package:flutter/material.dart';
import 'package:todone/database/database.dart';
import 'package:todone/i18n/strings.g.dart';
import 'package:todone/view/list/todo_tile.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  void updateState() {
    setState(() {});
  }

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

        // Separate active and completed tasks
        final activeTasks =
            snapshot.data!.where((item) => !item.completed).toList();
        final completedTasks =
            snapshot.data!.where((item) => item.completed).toList();

        return Stack(
          children: [
            if (snapshot.data!.isEmpty)
              Center(
                child: Text(context.t.list.noItems),
              )
            else
              Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    if (completedTasks.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ExpansionTile(
                        title: Text(
                          '${context.t.list.done} (${completedTasks.length})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        leading: IconButton(
                          onPressed: () {
                            showDeleteConfirmation(context);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        children: completedTasks
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  bottom: 8,
                                ),
                                child: TodoTile(
                                  todoItem: item,
                                  updateState: updateState,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    ...activeTasks.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: TodoTile(
                          todoItem: item,
                          updateState: updateState,
                        ),
                      ),
                    ),
                  ],
                ),
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

  void showDeleteConfirmation(BuildContext context) {
    // Type of showDialog cannot be set
    // ignore: inference_failure_on_function_invocation
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(context.t.list.deleteDialog.content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(context.t.list.deleteDialog.cancel),
            ),
            TextButton(
              onPressed: () async {
                await database.deleteDoneTodo();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
              child: Text(
                context.t.list.deleteDialog.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
