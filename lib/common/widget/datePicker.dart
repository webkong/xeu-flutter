import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  DatePickerField({Key key, this.onSave}) : super(key: key);
  final Function onSave;
  @override
  _DatePickerFieldState createState() {
    return _DatePickerFieldState(onSave: onSave);
  }
}

class _DatePickerFieldState extends State<DatePickerField> {
  _DatePickerFieldState({this.onSave});
  final Function onSave;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    textEditingController.text = _time;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var _time = '2018-04-09';
  _showDataPicker() async {
    Locale myLocale = Localizations.localeOf(context);
    var picker = await showDatePicker(
      context: context,
      initialDate: DateTime(2018),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: myLocale,
    );
    setState(() {
      _time = picker.toString().split(' ')[0];
      if (picker != null) {
        textEditingController.text = _time;
      }
    });
  }

  _showTimePicker() async {
    var picker =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    setState(() {
      _time = picker.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: '日期',
        prefixIcon: Icon(Icons.date_range),
      ),
      onTap: () {
        _showDataPicker();
      },
      onSaved: (value) {
        onSave(value);
      },
    );
  }
}
