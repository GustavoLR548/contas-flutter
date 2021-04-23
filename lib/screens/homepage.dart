import 'package:flutter/material.dart';
import 'package:todo/models/conta.dart';
import 'package:todo/provider/contas.dart';
import 'package:todo/screens/contaEditor.dart';
import 'package:todo/widget/drawer/drawer.dart';
import 'package:todo/widget/homepage/contaCard.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  _createConta(BuildContext appCtx) {
    Navigator.of(appCtx).push(MaterialPageRoute<void>(
      builder: (context) => ContaEditor(),
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<Contas>(context, listen: false).fetchData(),
          builder: (ctx, result) {
            if (result.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Consumer<Contas>(
                builder: (ctx, contas, _) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: contas.items.length == 0
                        ? _noContas(ctx)
                        : _showContas(contas)));
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createConta(context),
        child: Icon(Icons.add),
      ),
    );
  }

  _noContas(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Text(
          'Você não tem nenhuma conta\nAdicione alguma :-)',
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ));
  }

  _showContas(Contas allContas) {
    return AnimatedList(
        key: allContas.animatedList,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        initialItemCount: allContas.items.length,
        itemBuilder: (ctx, index, animation) =>
            ContaCard(allContas.items[index], animation));
  }
}
