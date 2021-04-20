import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart';

class Conta with ChangeNotifier {
  final String _creationDate;
  final String _targetTime;
  final String _title;
  final String _description;

  Conta(this._creationDate, this._targetTime, this._title, this._description);

  String get id {
    return this._creationDate;
  }

  String get title {
    return this._title;
  }

  String get description {
    return this._description;
  }

  String get creationDate {
    DateTime date = DateTime.parse(_creationDate);
    return DateFormat("dd/MM/yyyy - HH:mm").format(date);
  }

  String get targetTimeDay {
    DateTime date = DateTime.parse(_targetTime);
    return DateFormat("dd/MM").format(date);
  }

  String get targetTimeFullDate {
    DateTime date = DateTime.parse(_targetTime);
    return DateFormat("dd/MM/yyyy - HH:mm").format(date);
  }
}
