import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/provider/contas.dart';
import 'package:provider/provider.dart';

class ContaEditor extends StatefulWidget {
  @override
  _ContaEditorState createState() => _ContaEditorState();
}

class _ContaEditorState extends State<ContaEditor> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _formData;
  IconData _contaIcon;

  final int _minTitleLength = 3;
  final int _maxTitleLength = 20;
  final int _minDescriptionLength = 3;
  final int _maxDescriptionLength = 50;

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
    _formData = {'Title': '', 'Description': '', 'targetTime': ''};
    _contaIcon = Icons.account_balance;
    super.initState();
  }

  _chooseDate(BuildContext ctx) {
    DateTime currTime = DateTime.now();
    showDatePicker(
            context: context,
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

  _saveTodo() {
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
        Provider.of<Contas>(context, listen: false).add(_formData['Title'],
            _formData['Description'], _formData['targetTime'], _contaIcon);
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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text('Criando uma nova conta'),
            Row(
              children: [
                Expanded(
                  child: FormField<IconData>(
                    builder: (FormFieldState<IconData> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
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
                                  value: value, child: Icon(value));
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: _formData['Title'],
                    decoration: InputDecoration(labelText: 'Title'),
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      _formData['Title'] = value.trim();
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'The \'Title\' shouldn\'t be empty';
                      } else if (value.length < _minTitleLength ||
                          value.length > _maxTitleLength) {
                        return 'The \'Title\' should be between $_minTitleLength and $_maxTitleLength characters long';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              initialValue: _formData['Description'],
              decoration: InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.name,
              onSaved: (value) {
                _formData['Description'] = value.trim();
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'A \'descrição\' não deveria ser vazia';
                } else if (value.length < _minDescriptionLength ||
                    value.length > _maxDescriptionLength) {
                  return 'A \'descrição\' deveria ser no mínimo entre $_minDescriptionLength e $_maxDescriptionLength carateres de comprimento';
                }
                return null;
              },
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
            ElevatedButton(
                onPressed: _saveTodo, child: Text('Salvar \'Conta\'')),
          ],
        ),
      ),
    );
  }
}
