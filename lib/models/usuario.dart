class Usuario {
  String _name;
  String _email;
  String _password;
  String _id;
  String _expiryToken;

  Usuario(this._name, this._email, this._password, this._id, this._expiryToken);

  String get name {
    return _name;
  }

  String get email {
    return _email;
  }

  String get password {
    return _password;
  }

  String get id {
    return _id;
  }

  String get getExpiryToken {
    return _expiryToken;
  }

  set setExpiryToken(String token) {
    _expiryToken = token;
  }

  String get initials {
    String result = '';
    var split = _name.split(' ');

    int length = split.length >= 3 ? split.length : 3;
    for (int i = 0; i < length; i++) result += split[0][0];

    return result;
  }
}
