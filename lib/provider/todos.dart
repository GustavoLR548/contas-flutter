import 'package:flutter/foundation.dart';
import 'package:todo/models/todo.dart';

class Todos with ChangeNotifier {
  List<Todo> _items = [];

  List<Todo> get items {
    _items.sort((a, b) => a.targetTimeFullDate.compareTo(b.targetTimeFullDate));
    return [...this._items];
  }

  void add(String title, String description, String targetTime) {
    Todo newTodo =
        Todo(DateTime.now().toIso8601String(), targetTime, title, description);

    _items.add(newTodo);
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((element) => element.creationDate == id);
    notifyListeners();
  }
}
