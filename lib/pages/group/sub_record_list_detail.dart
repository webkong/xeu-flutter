import 'package:flutter/material.dart';
import '../../utils/adapt.dart';
import 'package:dio/dio.dart';
import '../../utils/tools.dart';
import '../../models/group/record.dart';

class SubRecordListDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubRecordListDetail();
  }
}

class _SubRecordListDetail extends State<SubRecordListDetail> {
  List recordList = <Map>[];
  Response response;
  Dio dio = Dio();
  bool showLoading = true;
  _getList() async {
    response =
        await dio.get("http://rap2api.taobao.org/app/mock/236857/record/list");
    setState(() {
      recordList = _generateList(response.data['data']['list']);
      showLoading = false;
    });
  }

  // 构建Memorabilia List数据
  List<Record> _generateList(List array) {
    List<Record> list = [];
    if (array.length == 0) return list;
    print(array);
    array.forEach((elem) {
      list.add(Record(
          date: int.parse(elem['date']),
          weight: elem['weight'],
          height: elem['height'],
          head: elem['head']));
    });
    return list;
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    if (showLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return _content(recordList);
    }
  }
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
