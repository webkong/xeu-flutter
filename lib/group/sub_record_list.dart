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
//// 请求参数也可以通过对象传递，上面的代码等同于：
//response = await dio.get("/test", queryParameters: {"id": 12, "name": "wendu"});
//print(response.data.toString());
   List recordList;
  _getList() async {
    Response response;
    Dio dio = Dio();
    response = await dio.get("http://rap2api.taobao.org/app/mock/236857/list");
    this.recordList = response.data;
    Toast.show('111', context);
  }

  @override
  void initState() {
    super.initState();
    this._getList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: recordList.map((item) {
      return Container(child: Text(item.height.toString()));
    }).toList());
  }
}
