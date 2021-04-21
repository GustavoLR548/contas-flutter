import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/helper/sql.dart';
import 'package:todo/models/usuario.dart';

class AuthProvider with ChangeNotifier {
  Usuario _currUser;
  List<Usuario> _allUsers = [];
  Timer _authTimer;

  final tableName = 'users';

  AuthProvider() {
    Future.delayed(Duration(milliseconds: 50)).then((value) async {
      final datalist = await SQLDatabase.read('users');
      if (datalist.length == 0) return;

      _allUsers = datalist
          .map((item) => Usuario(
              item['name'], item['email'], item['password'], item['id'], null))
          .toList();
      notifyListeners();
    });
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_currUser != null) return _currUser.getExpiryToken;
    return null;
  }

  Usuario get currUser {
    return _currUser;
  }

  Future<bool> signIn(String email, String password) async {
    int userIndex = _allUsers.indexWhere((element) => element.email == email);
    if (userIndex == -1) return false;

    Usuario user = _allUsers[userIndex];

    if (user.password.compareTo(password) != 0) return false;

    _currUser = user;
    _currUser.setExpiryToken =
        DateTime.now().add(Duration(hours: 10)).toIso8601String();
    _autoLogout();
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    final userData = json.encode(
        {'userId': _currUser.id, 'expiryDate': _currUser.getExpiryToken});
    preferences.setString('userData', userData);

    return true;
  }

  Future<bool> signUp(String username, String email, String password) async {
    int userIndex = _allUsers.indexWhere((element) => element.email == email);
    if (userIndex != -1) return false;

    final currDate = DateTime.now();

    _currUser = Usuario(username, email, password, currDate.toIso8601String(),
        currDate.add(Duration(hours: 10)).toIso8601String());

    _allUsers.add(_currUser);
    await SQLDatabase.insert(tableName, {
      'id': _currUser.id,
      'name': _currUser.name,
      'email': email,
      'password': password
    });

    _autoLogout();
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    final userData = json.encode(
        {'userId': _currUser.id, 'expiryDate': _currUser.getExpiryToken});
    preferences.setString('userData', userData);

    return true;
  }

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) return false;

    final extractedUserData =
        json.decode(preferences.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return false;

    final userId = extractedUserData['userId'];

    Usuario user = _allUsers.firstWhere((element) => element.id == userId);
    _currUser = user;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _currUser = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();

    final expireTokenDate = DateTime.parse(_currUser.getExpiryToken);

    final timeToExpiry = expireTokenDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
