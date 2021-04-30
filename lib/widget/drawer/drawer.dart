import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/auth.dart';
import 'package:todo/provider/theme_changer.dart';
import 'package:todo/screens/configuration.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<ThemeChanger>(context).currTheme;
    final user = Provider.of<AuthProvider>(context).currUser;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: const Radius.circular(35),
          bottomRight: const Radius.circular(35)),
      child: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: currTheme == ThemeType.light
                        ? Colors.yellowAccent[100]
                        : Colors.purpleAccent[900],
                    radius: 40,
                    child: Text(
                      user.initials,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(user.email)
                ],
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
          ListTile(
              leading: Icon(Icons.settings,
                  color: currTheme == ThemeType.light
                      ? Colors.black
                      : Colors.white),
              title: Text(
                'Configurações',
                style: Theme.of(context).textTheme.headline1,
              ),
              onTap: () =>
                  Navigator.of(context).pushNamed(Configuration.routeName)),
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
      )),
    );
  }
}
