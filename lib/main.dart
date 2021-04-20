import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/auth.dart';
import 'package:todo/provider/theme_changer.dart';
import 'package:todo/screens/homepage.dart';
import 'package:todo/screens/login_signup.dart';
import 'package:todo/screens/splash_screen.dart';
import 'provider/contas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(
        value: ThemeChanger(),
      ),
      ChangeNotifierProvider.value(
        value: AuthProvider(),
      ),
      ChangeNotifierProxyProvider<AuthProvider, Contas>(
        create: (ctx) => Contas(),
        update: (ctx, authData, previousContas) =>
            Contas.loggedIn(authData.token, authData.userId),
      )
    ], child: MyMaterialApp());
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return Consumer<AuthProvider>(
      builder: (ctx, authData, _) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: theme.themeData,
          home: authData.isAuth
              ? HomePage()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
        );
      },
    );
  }
}
