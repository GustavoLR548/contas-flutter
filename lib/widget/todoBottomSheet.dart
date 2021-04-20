import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/provider/contas.dart';
import 'package:provider/provider.dart';

class TodoBottomSheet extends StatefulWidget {
  @override
  _TodoBottomSheetState createState() => _TodoBottomSheetState();
}

class _TodoBottomSheetState extends State<TodoBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _formData;

  static const int _minTitleLength = 3;
  static const int _maxTitleLength = 20;
  static const int _minDescriptionLength = 3;
  static const int _maxDescriptionLength = 50;

  void initState() {
    _formData = {'Title': '', 'Description': '', 'targetTime': ''};
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
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        Provider.of<Contas>(context, listen: false).add(_formData['Title'],
            _formData['Description'], _formData['targetTime']);
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
            const Text('Creating a Todo'),
            TextFormField(
              initialValue: _formData['Title'],
              decoration: InputDecoration(labelText: 'Title'),
              keyboardType: TextInputType.name,
              onSaved: (value) {
                _formData['Title'] = value;
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
            TextFormField(
              initialValue: _formData['Description'],
              decoration: InputDecoration(labelText: 'Description'),
              keyboardType: TextInputType.name,
              onSaved: (value) {
                _formData['Description'] = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'The \'Description\' shouldn\'t be empty';
                } else if (value.length < _minDescriptionLength ||
                    value.length > _maxDescriptionLength) {
                  return 'The \'Description\' should be between $_minDescriptionLength and $_maxDescriptionLength characters long';
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
            ElevatedButton(onPressed: _saveTodo, child: Text('Save \'Todo\'')),
          ],
        ),
      ),
    );
  }
}
