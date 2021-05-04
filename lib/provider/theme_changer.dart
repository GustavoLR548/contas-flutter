import 'package:flutter/material.dart';

enum ThemeType {
  light,
  dark,
}

class ThemeChanger with ChangeNotifier {
  ThemeData _lightThemeData;
  ThemeData _darkThemeData;

  ThemeType _currTheme;

  ThemeChanger() {
    _currTheme = ThemeType.light;
    _setThemesDatas();
  }

  ThemeChanger.fromBrightness(Brightness b) {
    _currTheme = b == Brightness.light ? ThemeType.light : ThemeType.dark;
    _setThemesDatas();
  }

  _setThemesDatas() {
    _lightThemeData = ThemeData(
      primarySwatch: Colors.green,
      accentColor: Colors.limeAccent[700],
      accentColorBrightness: Brightness.dark,
      textTheme: ThemeData.light().textTheme.copyWith(
          headline1: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            fontSize: 36,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          bodyText2: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 0.5)),
    );
    _darkThemeData = ThemeData(
      primarySwatch: Colors.indigo,
      canvasColor: Color(0xFF00183f),
      accentColor: Colors.deepPurple,
      accentColorBrightness: Brightness.dark,
      textTheme: ThemeData.dark().textTheme.copyWith(
          headline1: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headline3: TextStyle(
            fontSize: 36,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
              fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
          bodyText2: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.5,
              color: Colors.white)),
    );
    notifyListeners();
  }

  ThemeData get themeData {
    if (_currTheme == ThemeType.dark) {
      return _darkThemeData;
    }
    return _lightThemeData;
  }

  ThemeType get currTheme {
    return _currTheme;
  }

  setTheme(ThemeType theme) {
    this._currTheme = theme;
    notifyListeners();
  }

  setThemeFromBrightness(Brightness b) {
    this._currTheme = b == Brightness.light ? ThemeType.light : ThemeType.dark;
    notifyListeners();
  }
}
