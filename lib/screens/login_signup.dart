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
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: deviceSize.height * 0.45,
                width: deviceSize.width * 0.60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 65.0),
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
                              .headline2
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.all_inbox_outlined,
                      color: Colors.white,
                      size: 100,
                    )
                  ],
                ),
              ),
            ),
          ),
          AuthForm(_submitAuthForm, _isLoading),
        ],
      ),
    );
  }
}
