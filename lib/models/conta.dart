import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Conta with ChangeNotifier {
  final String _creationDate;
  final int _creatorId;
  final String _targetTime;
  final String _title;
  final IconData _icon;
  final String _description;

  Conta(this._creationDate, this._creatorId, this._targetTime, this._title,
      this._description, this._icon);

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

  int get creatorId {
    return _creatorId;
  }

  String get targetTime {
    return _targetTime;
  }

  String get targetTimeDay {
    DateTime date = DateTime.parse(_targetTime);
    return DateFormat("dd/MM").format(date);
  }

  String get targetTimeFullDate {
    DateTime date = DateTime.parse(_targetTime);
    return DateFormat("dd/MM/yyyy - HH:mm").format(date);
  }

  IconData get icon {
    return _icon;
  }
}
