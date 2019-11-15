import 'package:flutter/material.dart';
import '../utils/toast.dart';
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

  Widget _list(){
    return ListView(
      children: recordList.map(
      (item) {
        return Container(child: Text(item['height'].toString()));
      },
    ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _list();
  }
}
