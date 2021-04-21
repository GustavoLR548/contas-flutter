import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/auth.dart';
import 'package:todo/provider/theme_changer.dart';
import 'package:todo/screens/configuration.dart';

class AppDrawer extends StatelessWidget {
  List<Widget> buildDividedListTile(
      BuildContext context, IconData icon, String text, Function f) {
    final currTheme = Provider.of<ThemeChanger>(context).currTheme;
    return [
      Divider(),
      ListTile(
          leading: Icon(icon,
              color:
                  currTheme == ThemeType.light ? Colors.black : Colors.white),
          title: Text(
            text,
            style: Theme.of(context).textTheme.headline1,
          ),
          onTap: f)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text(
            'Educa',
            style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        ...buildDividedListTile(
          context,
          Icons.settings,
          'Configurações',
          () => Navigator.of(context).pushNamed(Configuration.routeName),
        ),
        Divider(),
        ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(color: Colors.red),
            ),
            onTap: () {
              Provider.of<ThemeChanger>(context, listen: false)
                  .setTheme(ThemeType.light);
              Provider.of<AuthProvider>(context, listen: false).logout();
            })
      ],
    ));
  }
}
