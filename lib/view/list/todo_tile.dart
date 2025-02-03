import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todone/database/database.dart';
import 'package:todone/i18n/strings.g.dart';

class TodoTile extends StatefulWidget {
  const TodoTile({
    required this.todoItem,
    required this.updateState,
    super.key,
  });
  final TodoItem todoItem;
  final void Function() updateState;

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  late TodoItem todoItem;
  @override
  void initState() {
    super.initState();
    todoItem = widget.todoItem;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMd(
      context.t.$meta.locale.languageCode,
    );
    if (todoItem.due?.hour != 0 || todoItem.due?.minute != 0) {
      dateFormat.add_jm();
    }

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.1,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              database.deleteTodo(todoItem.id);
              widget.updateState();
            },
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          border: Border.all(color: Theme.of(context).dividerColor, width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          leading: Checkbox(
            value: todoItem.completed,
            onChanged: (value) async {
              await database.updateDone(todoItem.id);
              setState(() {
                todoItem = todoItem.copyWith(completed: value);
              });
              widget.updateState();
            },
          ),
          title: Text(todoItem.title),
          subtitle: todoItem.due != null
              ? Text('${context.t.list.dueDate}:'
                  ' ${dateFormat.format(todoItem.due!)}')
              : null,
        ),
      ),
    );
  }
}
