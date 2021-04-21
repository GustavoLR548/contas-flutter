import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo/helper/sql.dart';
import 'package:todo/models/conta.dart';

class Contas with ChangeNotifier {
  String currUserId;

  final tableName = 'contas';

  Contas();
  Contas.loggedIn(this.currUserId);

  List<Conta> _items = [];

  List<Conta> get items {
    _items.sort((a, b) => a.targetTimeFullDate.compareTo(b.targetTimeFullDate));
    List<Conta> result = [];
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].creatorId == currUserId) result.add(_items[i]);
    }

    return result;
  }

  Conta find(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> add(String title, String description, String targetTime,
      IconData icon) async {
    Conta newConta = Conta(DateTime.now().toIso8601String(), currUserId,
        targetTime, title, description, icon);
    _items.add(newConta);

    await SQLDatabase.insert(tableName, {
      'id': newConta.id,
      'creator_id': currUserId,
      'target_time': targetTime,
      'title': title,
      'description': description,
      'icon': icon.codePoint
    });
    notifyListeners();
  }

  bool update(Conta c) {
    final contaIndex = _items.indexOf(c);

    if (contaIndex < 0) return false;

    _items[contaIndex] = c;
    notifyListeners();
    SQLDatabase.insert(tableName, {
      'id': c.id,
      'creator_id': currUserId,
      'target_time': c.targetTime,
      'title': c.title,
      'description': c.description,
      'icon': c.icon.codePoint
    });
    return true;
  }

  void remove(String id) {
    _items.removeWhere((element) => element.creationDate == id);
    SQLDatabase.delete(tableName, id);
    notifyListeners();
  }

  Future<void> fetchData() async {
    final datalist = await SQLDatabase.read(tableName);

    if (datalist.length == 0) return;

    _items = datalist
        .map((item) => Conta(
            item['id'],
            item['creator_id'],
            item['target_time'],
            item['title'],
            item['description'],
            IconData(item['icon'], fontFamily: 'MaterialIcons')))
        .toList();
    notifyListeners();
  }
}
