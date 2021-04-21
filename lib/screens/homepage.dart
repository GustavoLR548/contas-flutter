import 'package:flutter/material.dart';
import 'package:todo/models/conta.dart';
import 'package:todo/provider/contas.dart';
import 'package:todo/widget/contaEditor.dart';
import 'package:todo/widget/homepage/contaCard.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/homepage';

  _createTodo(BuildContext appCtx) {
    showModalBottomSheet(
        context: appCtx, builder: (modalBottomSheetCtx) => ContaEditor());
  }

  Widget build(BuildContext context) {
    final allTodos = Provider.of<Contas>(context).items;
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
    return Center(
        child: Text('Você não tem nenhuma conta\nAdicione alguma :-)'));
  }

  _showTodos(List<Conta> allTodos) {
    return ListView.builder(
      itemCount: allTodos.length,
      itemBuilder: (ctx, index) =>
          TodoCard(allTodos[index].targetTimeDay, allTodos[index].title),
    );
  }
}
