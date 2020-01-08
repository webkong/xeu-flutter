import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/widget/datePicker.dart';
import 'package:xeu/models/group/record_state.dart';
import 'package:xeu/common/utils/adapt.dart';
import 'package:xeu/common/widget/toast.dart';
import 'package:xeu/common/utils/http.dart';

class NewRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewRecord();
  }
}

class _NewRecord extends State<NewRecord> {
  final _formRecord = GlobalKey<FormState>();
  Map<String, num> data = {"height": 0, "weight": 0, "head": 0, "date": 0};
  Map<String, Map> config = {
    "height": {
      "label": "身高",
      "unit": "CM",
      "icon": Icon(Icons.straighten),
      "hint": "宝宝长高啦"
    },
    "weight": {
      "label": "体重",
      "unit": "Kg",
      "icon": Icon(Icons.trending_up),
      "hint": "宝宝长大啦"
    },
    "head": {
      "label": "头围",
      "unit": "CM",
      "icon": Icon(Icons.face),
      "hint": "宝宝头围"
    },
  };

  TextEditingController _dateEditing = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          leading: CloseButton(),
          centerTitle: true,
          actions: <Widget>[
            MaterialButton(
              onPressed: () async {
                if (_formRecord.currentState.validate()) {
                  Toast.show('保存成功', context);
                  _formRecord.currentState.save();
                  SharedPreferences pres =
                      await SharedPreferences.getInstance();
                  String uid = pres.getString('u_id');
                  Map<String, dynamic> params = Map.from(data);
                  params['u_id'] = uid;
                  var res = await Http.post('/record/new', params);
                  if (res.code == 200) {
                    Provider.of<RecordModel>(context, listen: false)
                        .add(params);
                    Navigator.of(context).pop();
                  }
                  print(data);
                }
              },
              child: Text(
                '添加',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
      ),
      body: WillPopScope(
          child: Container(
            margin: EdgeInsets.all(Adapt.px(60)),
            child: Form(
              key: _formRecord,
              child: buildNewRecord(),
            ),
          ),
          onWillPop: () async {
            var _flag;
            if (data['height'] != 0 ||
                data['weight'] != 0 ||
                data['head'] != 0) {
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('保留此次编辑？'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('保留'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        _flag = false;
                      },
                    ),
                    FlatButton(
                      child: Text('不保留'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        _flag = true;
                      },
                    ),
                  ],
                ),
                barrierDismissible: false,
              );
            } else {
              _flag = true;
            }
            return _flag;
          }),
    );
  }

  Widget buildNewRecord() {
    return Column(
      children: <Widget>[
        buildInputItem('height'),
        buildInputItem('weight'),
        buildInputItem('head'),
        TextFormField(
          controller: _dateEditing,
          decoration: InputDecoration(
            labelText: '日期',
            prefixIcon: Icon(Icons.date_range),
          ),
          onTap: () async {
            String _time = await DatePickerCustom.show(context);
            String _date = _time.split(' ')[0];
            setState(() {
              _dateEditing.text = _date;
              data['date'] = DateTime.parse(_time).millisecondsSinceEpoch;
            });
          },
        ),
      ],
    );
  }

  Widget buildInputItem(key) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
//            initialValue: data[key].toString(),
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: config[key]['label'],
              prefixIcon: config[key]['icon'],
              suffixText: config[key]['unit'],
              hintText: config[key]['hint'],
//              helperText: config[key]['hint'],
            ),
            onSaved: (value) {
              setState(() {
                print('onsaev');
                print(value);
                if (value != '') {
                  data[key] = double.parse(value);
                } else {
                  data[key] = 0;
                }
              });
            },
            validator: (String value) {
              print('value $value');
              if (value == '') return null;
              RegExp input = new RegExp(r"\d+$");
              if (!input.hasMatch(value)) {
                return '必须是数字哦';
              } else {
                return null;
              }
            },
          ),
        ),
      ],
    );
  }
}
