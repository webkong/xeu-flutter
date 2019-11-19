import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/adapt.dart';
import 'package:dio/dio.dart';

class SubRecordList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubRecordList();
  }
}

class _SubRecordList extends State<SubRecordList> {
  List recordList = <Map>[];
  Response response;
  Dio dio = Dio();
  _getList() async {
    response = await dio.get("http://rap2api.taobao.org/app/mock/236857/list");
    setState(() {
      recordList = response.data['data']['list'];
    });
  }

  @override
  void initState() {
    super.initState();
    _getList();
  }

  Widget _list() {
    return Container(
      child: RecordItemList(
        list: this.recordList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _list();
  }
}

class RecordItemList extends StatelessWidget {
  RecordItemList({this.list = const []}) : super();
  final List list;
  final format = new DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Container(
//          margin: EdgeInsets.only(top: index == 0 ? Adapt.px(20) : 0),
          height: Adapt.px(180.0),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(Adapt.px(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    format.format(new DateTime.fromMillisecondsSinceEpoch(
                        this.list[index]['date'])),
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
                              this.list[index]['weight'].toString(),
                              style: TextStyle(fontSize: Adapt.px(36)),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('身高：'),
                            Text(
                              this.list[index]['height'].toString(),
                              style: TextStyle(fontSize: Adapt.px(36)),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('头围：'),
                            Text(
                              this.list[index]['head'].toString(),
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
        );
      },
      scrollDirection: Axis.vertical,
      itemCount: this.list.length,
    );
  }
}
