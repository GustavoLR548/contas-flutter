import 'package:flutter/material.dart';
import 'package:todo/models/conta.dart';
import 'package:todo/provider/contas.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/contaEditor.dart';

class ContaPage extends StatelessWidget {
  static const routeName = 'conta';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as int;
    final loadedConta = Provider.of<Contas>(context).find(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedConta.title),
        elevation: 0,
        centerTitle: true,
        actions: [_buildPopMenuButton(context, loadedConta)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: id,
              child: Container(
                color: Theme.of(context).primaryColor,
                height: 300,
                width: double.infinity,
                child: Icon(
                  loadedConta.icon,
                  size: 150,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('R\$' + loadedConta.value.toString(),
                style: Theme.of(context).textTheme.headline1),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedConta.title,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedConta.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopMenuButton(BuildContext context, Conta c) {
    return PopupMenuButton(
      onSelected: (String value) {
        if (value == 'edit') {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (context) => ContaEditor(
              conta: c,
            ),
          ));
        } else if (value == 'delete') {
          Navigator.of(context).pop('delete');
        }
      },
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.border_color,
                color: Colors.black,
              ),
              const SizedBox(
                width: 5,
              ),
              Text('Editar')
            ],
          ),
          value: 'edit',
        ),
        PopupMenuItem(
          child: Row(
            children: [
              const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Deletar',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          value: 'delete',
        ),
      ],
    );
  }
}
