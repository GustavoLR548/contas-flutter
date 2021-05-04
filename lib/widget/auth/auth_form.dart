import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      bool isLogin, BuildContext ctx) _submitData;

  final bool _isLoading;

  AuthForm(this._submitData, this._isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  Map<String, String> _formValues = {
    'email': '',
    'username': '',
    'password': '',
  };
  var _isLogin = true;

  //Functions
  //
  bool _isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  void _trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) return;

    _formKey.currentState.save();
    widget._submitData(_formValues['email'].trim(), _confirmPass.text.trim(),
        _formValues['username'].trim(), _isLogin, ctx);
  }

  void dispose() {
    super.dispose();
    _pass.dispose();
    _confirmPass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Widget confirmButton = (widget._isLoading)
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: OutlinedButton(
                child: Text(_isLogin ? 'Entrar' : 'Inscrever-se'),
                onPressed: () => _trySubmit(context)));
    return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height:
                _isLogin ? deviceSize.height * 0.50 : deviceSize.height * 0.65,
            width: deviceSize.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(50.0),
                  topRight: const Radius.circular(50.0),
                )),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Text(
                        _isLogin ? 'Entrar' : 'Registrar',
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        key: ValueKey('email'),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        initialValue: _formValues['email'],
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty || !_isValidEmail(value))
                            return 'Por favor, coloque um email válido';
                          return null;
                        },
                        onSaved: (value) {
                          _formValues['email'] = value;
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: ValueKey('username'),
                          textCapitalization: TextCapitalization.words,
                          enableSuggestions: false,
                          initialValue: _formValues['username'],
                          decoration:
                              InputDecoration(labelText: 'Nome de usuário'),
                          validator: (value) {
                            if (value.isEmpty || value.length < 4)
                              return 'O usuário precisa ter no mínimo 4 caractéres';
                            return null;
                          },
                          onSaved: (value) {
                            _formValues['username'] = value;
                          },
                        ),
                      TextFormField(
                        key: ValueKey('password'),
                        controller: _pass,
                        decoration: InputDecoration(labelText: 'Senha'),
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty || value.length < 7)
                            return 'A senha deve ter no mínimo 7 caractéres';
                          return null;
                        },
                        onSaved: (value) {
                          _formValues['password'] = value;
                        },
                      ),
                      if (!_isLogin)
                        TextFormField(
                          key: ValueKey('confirm_password'),
                          controller: _confirmPass,
                          decoration:
                              InputDecoration(labelText: 'Confirmar senha'),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty || value.length < 7)
                              return 'A senha deve ter no mínimo 7 caractéres';
                            if (value != _pass.text)
                              return 'As senhas não são iguais';
                            return null;
                          },
                          onSaved: (value) {
                            _formValues['password'] = value;
                          },
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      confirmButton,
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: ElevatedButton(
                          child: Text(
                              _isLogin ? 'Criar nova conta' : 'Fazer Login'),
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
