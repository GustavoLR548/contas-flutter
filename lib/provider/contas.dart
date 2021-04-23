import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/helper/sql.dart';
import 'package:todo/models/conta.dart';
import 'package:todo/widget/homepage/contaCard.dart';

class Contas with ChangeNotifier {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  int currUserId;

  final tableName = 'contas';

  Contas();
  Contas.loggedIn(this.currUserId);

  List<Conta> _items = [];

  List<Conta> get items {
    List<Conta> result = [];
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].creatorId == currUserId) result.add(_items[i]);
    }

    return result;
  }

  Conta find(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  GlobalKey<AnimatedListState> get animatedList {
    return listKey;
  }

  Future<void> add(String title, String description, String targetTime,
      double value, IconData icon) async {
    Conta newConta = Conta(DateTime.now().toIso8601String(), currUserId,
        targetTime, title, value, description, icon);

    int id = await SQLDatabase.insert(tableName, {
      'creator_id': currUserId,
      'creation_date': newConta.creationDate,
      'target_time': targetTime,
      'value': value,
      'title': title,
      'description': description,
      'icon': icon.codePoint
    });

    if (listKey.currentState != null)
      listKey.currentState
          .insertItem(id - 1, duration: const Duration(milliseconds: 500));

    newConta.id = id;
    _items.add(newConta);

    notifyListeners();
  }

  bool update(Conta c) {
    final contaIndex = _items.indexWhere((element) => element.id == c.id);

    if (contaIndex == -1) return false;

    _items[contaIndex] = c;
    notifyListeners();
    SQLDatabase.insert(tableName, {
      'id': c.id,
      'creator_id': currUserId,
      'creation_date': c.creationDate,
      'value': c.value,
      'target_time': c.targetTime,
      'title': c.title,
      'description': c.description,
      'icon': c.icon.codePoint
    });
    return true;
  }

  void remove(int id) {
    int index = _items.indexWhere((element) => element.id == id);

    if (index == -1) return;

    Conta removed = _items[index];

    _items.remove(removed);

    listKey.currentState.removeItem(
        index, (context, animation) => ContaCard(removed, animation),
        duration: const Duration(milliseconds: 500));
    SQLDatabase.delete(tableName, id).then((value) => print(value));
    notifyListeners();
  }

  Future<void> fetchData() async {
    final datalist = await SQLDatabase.read(tableName);

    if (datalist.length == 0) return;

    _items = datalist
        .map((item) => Conta.id(
            item['id'],
            item['creation_date'],
            item['creator_id'],
            item['target_time'],
            item['title'],
            item['value'],
            item['description'],
            IconData(item['icon'], fontFamily: 'MaterialIcons')))
        .toList();
    notifyListeners();
  }
}
