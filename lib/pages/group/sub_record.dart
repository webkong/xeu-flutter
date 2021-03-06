import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xeu/common/utils/memory.dart';
import 'package:xeu/common/utils/tools.dart';
import 'package:xeu/common/widget/ContentLoadStatus.dart';
import 'package:xeu/common/widget/chart.dart';
import 'package:xeu/models/group/record_state.dart';
import 'package:xeu/models/group/record.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/models/user/baby.dart';
import 'package:xeu/models/user/user_state.dart';

class SubRecordList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubRecordList();
  }
}

class _SubRecordList extends State<SubRecordList>
    with AutomaticKeepAliveClientMixin {
  List recordList = <Map>[];
  Map<String, List> chartsMapData = {
    "height": [],
    "weight": [],
    "head": [],
  };
  bool showLoading = true;
  Widget _contentLoad = ContentLoadStatus(
    flag: 'loading',
  );
  bool _pullData = false;
  _getList() async {
    String uid = await Memory.get('u_id');
    String bid = await Memory.get('b_id');
    var response = await Http().get("/record/list", {"u_id": uid, 'b_id': bid});

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

    return Scaffold(
      appBar: AppBar(
        title: Text('趋势图'),
      ),
      body: _buildContext(context),
    );
  }

  Widget _buildContext(BuildContext context) {
    if (!_pullData) {
      return _contentLoad;
    } else {
      return Consumer(
          builder: (BuildContext context, RecordModel record, child) {
        if (record.get()) {
          record.init();
          this._getList();
        }
        return _content(recordList);
      });
//      return _content(recordList);
    }
  }

  Widget _content(list) {
    return ListView(
      children: <Widget>[
        TrendChart(
          tag: 'boyHeight',
          data: chartsMapData['height'],
          displayName: '身高曲线',
          yAxis: '（单位：CM）',
        ),
        TrendChart(
          tag: 'boyWeight',
          data: chartsMapData['weight'],
          displayName: '体重曲线',
          yAxis: '（单位：Kg）',
        ),
//TODO: 头围相关
        //TODO：删除， 列表，record
//        TrendChart(
//          tag: 'boyHead',
//          data: chartsMapData['head'],
//          displayName: '头围曲线',
//          yAxis: '（单位：CM）',
//        ),
      ],
    );
  }

  // 构建Record List数据
  List<Record> _generateList(List array) {
    Baby _baby =
        Provider.of<UserModel>(context, listen: false).getDefaultBaby();
    int birthday = _baby.birthday;
    List<Record> _list = [];
    Map<String, List> _map = {
      "height": [],
      "weight": [],
      "head": [],
    };
    if (array.length == 0) return _list;
    print(array);
    array.forEach((elem) {
      print(elem);
      Record r = Record.fromJson(elem);

      print(r.toJson());
      _list.add(r);
      _map['height'].add([Tools.getMouth(birthday, r.date), r.height]);
      _map['weight'].add([Tools.getMouth(birthday, r.date), r.weight]);
      _map['head'].add([Tools.getMouth(birthday, r.date), r.head]);
    });
    setState(() {
      print(_map);
      chartsMapData.addAll(_map);
    });
    return _list;
  }
}
