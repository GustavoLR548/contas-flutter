import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TodoCard extends StatelessWidget {
  final String _todoTargetDay;
  final String _todoTitle;

  const TodoCard(this._todoTargetDay, this._todoTitle);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 50,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FittedBox(
              child: Text(_todoTargetDay),
            ),
          ),
        ),
        title: Text(_todoTitle),
      ),
    );
  }
}
