import 'package:flutter/foundation.dart';
import 'package:todo/models/conta.dart';

class Contas with ChangeNotifier {
  String authToken;
  String userId;

  Contas();
  Contas.loggedIn(this.authToken, this.userId);

  List<Conta> _items = [];

  List<Conta> get items {
    _items.sort((a, b) => a.targetTimeFullDate.compareTo(b.targetTimeFullDate));
    return [...this._items];
  }

  void add(String title, String description, String targetTime) {
    Conta newConta =
        Conta(DateTime.now().toIso8601String(), targetTime, title, description);

    _items.add(newConta);
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((element) => element.creationDate == id);
    notifyListeners();
  }
}
