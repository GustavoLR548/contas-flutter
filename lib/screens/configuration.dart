import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/theme_changer.dart';

class Configuration extends StatefulWidget {
  static const routeName = '/Configuracoes';
  @override
  _ConfigurationState createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  bool isLightMode = true;
  bool hasInitiated = false;

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasInitiated) {
      isLightMode =
          Provider.of<ThemeChanger>(context).currTheme == ThemeType.light
              ? true
              : false;
      hasInitiated = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SwitchListTile(
              title: Text(
                isLightMode ? 'Tema branco' : 'Tema preto',
                style: Theme.of(context).textTheme.headline1,
              ),
              secondary: Icon(
                isLightMode
                    ? Icons.brightness_4_rounded
                    : Icons.brightness_4_outlined,
                color: isLightMode ? Colors.black : Colors.white,
              ),
              subtitle: Text(
                'Trocar temática de cor',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              value: isLightMode,
              onChanged: (value) {
                setState(() {
                  isLightMode = value;
                });

                if (isLightMode)
                  theme.setTheme(ThemeType.light);
                else
                  theme.setTheme(ThemeType.dark);
              })
        ],
      ),
    );
  }
}
