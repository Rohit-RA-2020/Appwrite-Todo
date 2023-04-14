import 'package:flutter/material.dart';

import '../model/todo.dart';

class TodoListTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback? toggle;
  final VoidCallback? delete;

  const TodoListTile({
    Key? key,
    required this.todo,
    this.toggle,
    this.delete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      key: Key(todo.id),
      leading: IconButton(
        icon: Icon(
          todo.isComplete
              ? Icons.check_box
              : Icons.check_box_outline_blank_rounded,
          color: const Color.fromRGBO(16, 185, 129, 1),
        ),
        onPressed: toggle,
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.delete_outline,
          color: Color.fromRGBO(239, 68, 68, 1),
        ),
        onPressed: delete,
      ),
      dense: true,
      title: Text(
        todo.content,
      ),
    );
  }
}
