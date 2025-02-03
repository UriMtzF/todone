import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todone/database/database.dart';
import 'package:todone/i18n/strings.g.dart';

class TodoEditor extends StatefulWidget {
  const TodoEditor({
    required this.updateListState,
    this.todoItem,
    this.updateTileState,
    super.key,
  });
  final TodoItem? todoItem;
  final void Function() updateListState;
  final void Function()? updateTileState;

  @override
  State<TodoEditor> createState() => _TodoEditorState();
}

class _TodoEditorState extends State<TodoEditor> {
  late TodoItem? todoItem;
  DateTime? dateTimeController;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final dateController = TextEditingController();

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    todoItem = widget.todoItem;
    if (widget.todoItem != null) {
      titleController.text = todoItem!.title;
      bodyController.text = todoItem!.body ?? '';
      dateTimeController = todoItem!.due;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setDateTimeValue();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final firstDate = initialDate.subtract(const Duration(days: 365));
    final lastDate = initialDate.add(const Duration(days: 365 * 5));

    final selectedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return;

    if (!context.mounted) {
      dateTimeController = selectedDate;
      return;
    }

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    dateTimeController = selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  void setDateTimeValue() {
    if (dateTimeController != null) {
      final controller = dateTimeController!;
      final dateFormat = DateFormat.yMMMMd(
        context.t.$meta.locale.languageCode,
      );
      if (controller.hour != 0 || controller.minute != 0) {
        dateFormat.add_jm();
      }
      dateController.text = dateFormat.format(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNew = todoItem == null;

    return Material(
      child: Column(
        children: [
          AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(
              isNew ? context.t.editor.createTask : context.t.editor.editTask,
            ),
            actions: [
              TextButton.icon(
                onPressed: _isFormValid
                    ? () async {
                        if (formKey.currentState!.validate()) {
                          if (todoItem == null) {
                            await database.addTodo(
                              title: titleController.text,
                              body: bodyController.text,
                              dueDate: dateTimeController,
                            );
                          } else {
                            await database.updateTodo(
                              id: todoItem!.id,
                              title: titleController.text,
                              body: bodyController.text,
                              dueDate: dateTimeController,
                            );
                          }

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                          widget.updateTileState?.call();
                          widget.updateListState();
                        }
                      }
                    : null,
                label: Text(context.t.editor.save),
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  onChanged: () {
                    final isValid = formKey.currentState?.validate() ?? false;
                    setState(() {
                      _isFormValid = isValid;
                    });
                  },
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: context.t.editor.taskName,
                          suffix: IconButton(
                            onPressed: titleController.clear,
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                        maxLength: 100,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.t.editor.emptyTitle;
                          }
                          if (value.length > 100) {
                            return context.t.editor.longContent(max: 100);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: context.t.editor.dueDate,
                          suffix: IconButton(
                            onPressed: () {
                              dateController.clear();
                              dateTimeController = null;
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          await _selectDate(context);
                          setDateTimeValue();
                        },
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: bodyController,
                        decoration: InputDecoration(
                          labelText: context.t.editor.taskDescription,
                          suffix: IconButton(
                            onPressed: bodyController.clear,
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                        maxLength: 1000,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 3,
                        validator: (value) {
                          if (value != null && value.length > 1000) {
                            return context.t.editor.longContent(max: 1000);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
