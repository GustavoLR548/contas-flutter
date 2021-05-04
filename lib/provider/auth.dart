import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/helper/sql.dart';
import 'package:todo/models/usuario.dart';

class AuthProvider with ChangeNotifier {
  int currUserId;
  String currUserToken;
  List<Usuario> _allUsers = [];
  Timer _authTimer;

  bool startedDatabase = false;

  final tableName = 'users';

  bool get isAuth {
    return token != 'N/A';
  }

  String get token {
    if (currUserToken != null) return currUserToken;
    return 'N/A';
  }

  int get id {
    return currUserId;
  }

  Usuario get currUser {
    return _allUsers.firstWhere((element) => element.id == currUserId);
  }

  Future<void> _fetchUsers() async {
    final datalist = await SQLDatabase.read('users');
    if (datalist.length == 0) return false;

    _allUsers = datalist
        .map((item) => Usuario(
            item['name'], item['email'], item['password'], item['id'], null))
        .toList();
    notifyListeners();
    startedDatabase = true;
  }

  Future<bool> signIn(String email, String password) async {
    if (!startedDatabase) await _fetchUsers();

    int userIndex = _allUsers.indexWhere((element) => element.email == email);
    print(userIndex);
    if (userIndex == -1) return false;

    Usuario user = _allUsers[userIndex];

    if (user.password.compareTo(password) != 0) return false;
    currUserId = user.id;
    currUserToken = DateTime.now().add(Duration(days: 1)).toIso8601String();
    print('created Expiry Token = ' + currUserToken);
    _autoLogout();
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    final userData =
        json.encode({'userId': user.id, 'expiryDate': currUserToken});
    preferences.setString('userData', userData);

    return true;
  }

  Future<bool> signUp(String username, String email, String password) async {
    int userIndex = _allUsers.indexWhere((element) => element.email == email);
    if (userIndex != -1) return false;

    final currDate = DateTime.now();

    Usuario newUser = Usuario(username, email, password, 0,
        currDate.add(Duration(days: 1)).toIso8601String());

    int id = await SQLDatabase.insert(
        tableName, {'name': username, 'email': email, 'password': password});

    newUser.id = id;
    _allUsers.add(newUser);

    currUserId = id;
    currUserToken = newUser.getExpiryToken;

    _autoLogout();
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    final userData = json.encode({'userId': id, 'expiryDate': currUserToken});
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

    currUserId = extractedUserData['userId'];
    currUserToken = extractedUserData['expiryDate'];

    print('currUserToken = ' + currUserToken);
    if (!startedDatabase) await _fetchUsers();
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    print('GOTTA SWEEP');
    currUserId = null;
    currUserToken = null;
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

    final expireTokenDate = DateTime.parse(currUserToken);

    final timeToExpiry = expireTokenDate.difference(DateTime.now()).inSeconds;
    print(timeToExpiry);
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
