import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/models/conta.dart';
import 'package:todo/provider/contas.dart';
import 'package:todo/screens/conta_page.dart';
import 'package:provider/provider.dart';

class ContaCard extends StatelessWidget {
  final Conta _conta;
  final Animation _animation;

  const ContaCard(this._conta, this._animation);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset(0, 0))
          .animate(_animation),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 70,
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context)
                          .pushNamed(ContaPage.routeName, arguments: _conta.id);

                      await Future.delayed(Duration(milliseconds: 600));
                      if (result == null) return;
                      if (result == 'delete')
                        Provider.of<Contas>(context, listen: false)
                            .remove(_conta.id);
                    },
                    child: Hero(
                      tag: _conta.id,
                      child: Container(
                        color: Colors.blue,
                        width: 70,
                        height: 70,
                        child: Icon(_conta.icon, color: Colors.white),
                      ),
                    )),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_conta.title),
                      Text(_conta.targetTimeDay,
                          style: TextStyle(color: Colors.grey)),
                      Text('R\$' + _conta.value.toString(),
                          style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: () {
                      Provider.of<Contas>(context, listen: false)
                          .remove(_conta.id);
                    },
                    child: Icon(
                      Icons.check_box_outline_blank,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
