import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/widget/ContentLoadStatus.dart';
import 'package:xeu/common/widget/chart.dart';
import 'package:xeu/models/group/record_state.dart';
import 'package:xeu/models/group/record.dart';
import 'package:xeu/common/utils/http.dart';

class SubRecordList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubRecordList();
  }
}

class _SubRecordList extends State<SubRecordList>
    with AutomaticKeepAliveClientMixin {
  List recordList = <Map>[];
  String uid;
  bool showLoading = true;
  Widget _contentLoad = ContentLoadStatus(
    flag: 'loading',
  );
  bool _pullData = false;
  _getList() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    uid = pres.getString('u_id');
    var response = await Http.get("/record/list", {"u_id": uid});

    if (response == -1) {
      print(response);
      setState(() {
        _contentLoad = ContentLoadStatus(
          flag: 'noNetwork',
        );
      });
    } else {
      print('response for memorabilia $response');
      setState(() {
        var list = _generateList(response.data['data']['list']);
        if (list.length == 0) {
          _contentLoad = ContentLoadStatus(
            flag: 'noContent',
          );
        } else {
          recordList = list;
          _pullData = true;
        }
      });
    }
  }

  // 构建Memorabilia List数据
  List<Record> _generateList(List array) {
    List<Record> list = [];
    if (array.length == 0) return list;
    print(array);
    array.forEach((elem) {
      list.add(Record.fromJson(elem));
    });
    return list;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_pullData) {
      return _contentLoad;
    } else {
//      return Consumer(
//          builder: (BuildContext context, RecordModel record, child) {
//        if (record.get()) {
//          record.init();
//          this._getList();
//        }
//        return _content(recordList);
//      });
      return _content(recordList);
    }
  }
}

Widget _content(list) {
  return Column(
    children: <Widget>[
      TrendChart(
        tag: 'boyHeight',
        data: list,
      ),
    ],
  );
}
