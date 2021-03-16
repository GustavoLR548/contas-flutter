import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/widget/todoBottomSheet.dart';
import 'package:todo/widget/todoCard.dart';

import 'provider/todos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Todos(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  _createTodo(BuildContext appCtx) {
    showModalBottomSheet(
        context: appCtx, builder: (modalBottomSheetCtx) => TodoBottomSheet());
  }

  Widget build(BuildContext context) {
    final allTodos = Provider.of<Todos>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: allTodos.length == 0 ? _noTodos() : _showTodos(allTodos),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createTodo(context),
        child: Icon(Icons.add),
      ),
    );
  }

  _noTodos() {
    return Center(child: Text('You have no \'Todo\', start adding some! :-'));
  }

  _showTodos(List<Todo> allTodos) {
    return ListView.builder(
      itemCount: allTodos.length,
      itemBuilder: (ctx, index) =>
          TodoCard(allTodos[index].targetTimeDay, allTodos[index].title),
    );
  }
}
