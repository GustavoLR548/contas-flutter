import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/auth.dart';
import 'package:todo/widget/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      bool isLogin, BuildContext ctx) async {
    bool result = false;

    setState(() {
      _isLoading = true;
    });
    if (isLogin) {
      result = await Provider.of<AuthProvider>(context, listen: false)
          .signIn(email, password);

      if (!result) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Um erro ocorreu ao fazer login'),
                  content: Text('teste'),
                ));
      }
    } else {
      result = await Provider.of<AuthProvider>(context, listen: false)
          .signUp(username, email, password);

      if (!result) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Um erro ocorreu ao fazer registro'),
                  content: Text('teste'),
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(69, 129, 230, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20, top: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                        boxShadow: [
                          const BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Contas',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  AuthForm(_submitAuthForm, _isLoading),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
