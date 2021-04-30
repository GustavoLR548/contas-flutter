import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/conta.dart';
import 'package:todo/provider/contas.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/theme_changer.dart';

class ContaEditor extends StatefulWidget {
  final Conta conta;

  ContaEditor({this.conta});
  @override
  _ContaEditorState createState() => _ContaEditorState();
}

class _ContaEditorState extends State<ContaEditor> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _formData;
  IconData _contaIcon;
  bool updateConta = false;

  final int _minTitleLength = 3;

  final List<IconData> _possibleIcons = [
    Icons.account_balance,
    Icons.agriculture,
    Icons.airplanemode_active,
    Icons.airport_shuttle,
    Icons.anchor,
    Icons.apartment,
    Icons.article,
    Icons.assignment_ind,
    Icons.attach_money,
    Icons.audiotrack,
    Icons.auto_stories,
    Icons.book,
  ];

  void initState() {
    if (widget.conta == null) {
      _formData = {
        'Title': '',
        'Description': '',
        'targetTime': '',
        'value': ''
      };
      _contaIcon = Icons.account_balance;
    } else {
      updateConta = true;
      _formData = {
        'Title': widget.conta.title,
        'Description': widget.conta.description,
        'targetTime': widget.conta.targetTime,
        'value': widget.conta.value.toString(),
      };
      _contaIcon = widget.conta.icon;
    }
    super.initState();
  }

  _chooseDate(BuildContext ctx) {
    DateTime currTime = DateTime.now().add(Duration(days: 1));
    showDatePicker(
            context: context,
            locale: const Locale('pt', 'PT'),
            initialDate: currTime,
            firstDate: currTime,
            lastDate: DateTime(currTime.year + 1))
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _formData['targetTime'] = pickedDate.toIso8601String();
      });
    });
  }

  _save() {
    if (DateTime.tryParse(_formData['targetTime']) == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Alerta!'),
                content: const Text('Você não escolheu uma data!'),
              ));
    } else {
      if (_formKey.currentState.validate() && _contaIcon != null) {
        _formKey.currentState.save();
        final provider = Provider.of<Contas>(context, listen: false);
        if (updateConta) {
          provider.update(Conta.id(
              widget.conta.id,
              DateTime.now().toIso8601String(),
              widget.conta.creatorId,
              _formData['targetTime'],
              _formData['Title'],
              double.parse(_formData['value']),
              _formData['Description'],
              _contaIcon));
        } else {
          provider.add(
              _formData['Title'],
              _formData['Description'],
              _formData['targetTime'],
              double.parse(_formData['value']),
              _contaIcon);
        }
        Navigator.of(context).pop();
      }
    }
  }

  String _selectedDateInText() {
    return DateFormat("dd/MM/yyyy")
        .format(DateTime.parse(_formData['targetTime']));
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<ThemeChanger>(context).currTheme;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(updateConta ? 'Atualizando conta' : 'Criando uma nova conta'),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: ListView(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FormField<IconData>(
                        builder: (FormFieldState<IconData> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: currTheme == ThemeType.light
                                      ? Colors.black
                                      : Colors.white,
                                )),
                                labelStyle:
                                    Theme.of(context).textTheme.bodyText2,
                                errorStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 16.0),
                                hintText: 'Selecione um icone para essa conta',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            isEmpty: _contaIcon == null,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<IconData>(
                                value: _contaIcon,
                                isDense: true,
                                onChanged: (icon) {
                                  setState(() {
                                    _contaIcon = icon;
                                    state.didChange(icon);
                                  });
                                },
                                items: _possibleIcons.map((value) {
                                  return DropdownMenuItem<IconData>(
                                      value: value,
                                      child: Icon(
                                        value,
                                        color: currTheme == ThemeType.light
                                            ? Colors.black
                                            : Colors.white,
                                      ));
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue: _formData['Title'],
                        maxLength: 20,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: currTheme == ThemeType.light
                                      ? Colors.black
                                      : Colors.white)),
                          labelText: 'Título',
                          labelStyle: Theme.of(context).textTheme.bodyText2,
                        ),
                        keyboardType: TextInputType.name,
                        onSaved: (value) {
                          _formData['Title'] = value.trim();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'The \'Title\' shouldn\'t be empty';
                          } else if (value.length < _minTitleLength) {
                            return 'The \'Title\' should at least $_minTitleLength characters long';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: _formData['Description'],
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: currTheme == ThemeType.light
                                  ? Colors.black
                                  : Colors.white)),
                      labelText: 'Descrição',
                      labelStyle: Theme.of(context).textTheme.bodyText2),
                  maxLength: 50,
                  keyboardType: TextInputType.name,
                  onSaved: (value) {
                    _formData['Description'] = value.trim();
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'A \'descrição\' não deveria ser vazia';
                    } else if (value.length < _minTitleLength) {
                      return 'A \'descrição\' deveria ser no mínimo $_minTitleLength ';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  initialValue: _formData['value'],
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: currTheme == ThemeType.light
                                ? Colors.black
                                : Colors.white)),
                    labelText: 'Valor',
                    labelStyle: Theme.of(context).textTheme.bodyText2,
                    prefix: Text('R\$'),
                    prefixStyle: Theme.of(context).textTheme.bodyText1,
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _formData['value'] = value.trim();
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'O \'valor\' não deveria ser vazio';
                    } else if (double.tryParse(value) == null) {
                      return 'Valor inválido, tente novamente';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_formData['targetTime'] == ''
                            ? 'Nenhuma data selecionada'
                            : 'Data selecionada : ' + _selectedDateInText()),
                      ),
                      TextButton(
                          onPressed: () => _chooseDate(context),
                          child: Text('Escolha uma data'))
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: _save, child: Text('Salvar \'Conta\'')),
                ),
              ],
            ),
          )),
    );
  }
}
