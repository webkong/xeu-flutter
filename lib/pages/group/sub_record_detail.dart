import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xeu/common/utils/adapt.dart';
import 'package:dio/dio.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/common/utils/memory.dart';
import 'package:xeu/common/utils/tools.dart';
import 'package:xeu/common/widget/contentLoadStatus.dart';
import 'package:xeu/models/group/record.dart';
import 'package:xeu/models/group/record_state.dart';
import 'package:xeu/pages/group/sub_record.dart';

class SubRecordListDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubRecordListDetail();
  }
}

class _SubRecordListDetail extends State<SubRecordListDetail> {
  List recordList = <Map>[];
  Response response;
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
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    if (!_pullData) {
      return _contentLoad;
    } else {
      return Column(
        children: <Widget>[
          Container(
              height: 60,
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.show_chart,
                    color: Theme.of(context).accentColor,
                  ),
                  title: Text(
                    '查看趋势图',
                    textAlign: TextAlign.center,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).accentColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => SubRecordList(),
                      ),
                    );
                  },
                ),
              )),
          Expanded(
            child: Consumer(
              builder: (BuildContext context, RecordModel record, child) {
                if (record.get()) {
                  record.init();
                  this._getList();
                }
                return _content(recordList);
              },
            ),
          ),
        ],
      );
    }
  }

  // 构建record List数据
  List<Record> _generateList(List array) {
    List<Record> list = [];
    if (array.length == 0) return list;
    print(array);
    array.forEach((elem) {
      list.add(Record.fromJson(elem));
    });
    return list;
  }

  Widget _content(list) {
    return Container(
      child: ListView(
        children: <Widget>[
          ..._generateRecordList(list),
        ],
      ),
    );
  }

// 记录列表
  List<Widget> _generateRecordList(List list) {
    List<Widget> recordList = [];
    list.forEach((elem) {
      recordList.add(Container(
//          margin: EdgeInsets.only(top: index == 0 ? Adapt.px(20) : 0),
        height: Adapt.px(180.0),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(Adapt.px(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Tools.formatDate(elem.date),
                  style: TextStyle(color: Colors.black54),
                ),
                Container(
                  padding: EdgeInsets.only(top: Adapt.px(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('体重：'),
                          Text(
                            elem.weight.toString(),
                            style: TextStyle(fontSize: Adapt.px(36)),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('身高：'),
                          Text(
                            elem.height.toString(),
                            style: TextStyle(fontSize: Adapt.px(36)),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('头围：'),
                          Text(
                            elem.head.toString(),
                            style: TextStyle(fontSize: Adapt.px(36)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    });
    return recordList;
  }
}
