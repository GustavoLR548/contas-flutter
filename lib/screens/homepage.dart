import 'package:flutter/material.dart';
import 'package:todo/models/conta.dart';
import 'package:todo/provider/contas.dart';
import 'package:todo/widget/contaEditor.dart';
import 'package:todo/widget/drawer/drawer.dart';
import 'package:todo/widget/homepage/contaCard.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/homepage';

  _createTodo(BuildContext appCtx) {
    showModalBottomSheet(
        context: appCtx, builder: (modalBottomSheetCtx) => ContaEditor());
  }

  Widget build(BuildContext context) {
    final contasProvider = Provider.of<Contas>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: contasProvider.fetchData(),
          builder: (ctx, result) {
            if (result.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final contasItems = contasProvider.items;
            if (contasItems.length == 0) {
              return _noContas(context);
            }
            return _showContas(contasItems);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createTodo(context),
        child: Icon(Icons.add),
      ),
    );
  }

  _noContas(BuildContext context) {
    return Center(
        child: Text(
      'Você não tem nenhuma conta\nAdicione alguma :-)',
      style: Theme.of(context).textTheme.headline1,
      textAlign: TextAlign.center,
    ));
  }

  _showContas(List<Conta> allContas) {
    return ListView.builder(
      itemCount: allContas.length,
      itemBuilder: (ctx, index) =>
          ContaCard(allContas[index].targetTimeDay, allContas[index].title),
    );
  }
}
