import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/models/group/record_state.dart';
import 'package:xeu/common/utils/adapt.dart';
import 'package:xeu/common/utils/tools.dart';
import 'package:xeu/models/group/record.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:xeu/common/utils/http.dart';

class SubRecordList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubRecordList();
  }
}

class _SubRecordList extends State<SubRecordList> {
  List recordList = <Map>[];
  String uid;
  bool showLoading = true;

  _getList() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    uid = pres.getString('u_id');
    var res = await Http.get("/record/list", {"u_id": uid});
    setState(() {
      recordList = _generateList(res.data['data']['list']);
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
          date: DateTime.parse(elem['create_at']).millisecondsSinceEpoch,
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
      return Consumer(
          builder: (BuildContext context, RecordModel record, child) {
        if (record.get()) {
          print('舒心');
          record.init();
          this._getList();
        }
        return _content(recordList);
      });
    }
  }
}

Widget _content(list) {
  return Column(
    children: <Widget>[
      _generateChart(list),
    ],
  );
}

//图表
Widget _generateChart(List list) {
  List<charts.Series> seriesList = _createSampleData(list) ?? [];
  bool animate = true;

  return Container(
    height: 100,
    width: 1000,
    child: new charts.LineChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.LineRendererConfig(
        includeArea: true,
        stacked: true,
      ),
      customSeriesRenderers: [
        new charts.LineRendererConfig(
            customRendererId: 'customPoint', includePoints: true),
      ],
    ),
  );
}

/// Create one series with sample hard coded data.
List<charts.Series<LinearSales, int>> _createSampleData(List list) {
  List<LinearSales> data = [];
  var middleData = [
    new LinearSales(0, 6),
    new LinearSales(1, 7),
    new LinearSales(2, 8),
    new LinearSales(3, 9),
    new LinearSales(4, 9.2),
    new LinearSales(5, 9.4),
    new LinearSales(6, 9.5),
  ];
  var lowData = [
    new LinearSales(0, 4),
    new LinearSales(1, 6),
    new LinearSales(2, 6.5),
    new LinearSales(3, 7),
    new LinearSales(4, 7.5),
    new LinearSales(5, 8),
    new LinearSales(6, 8.5),
  ];

  var highData = [
    new LinearSales(0, 7),
    new LinearSales(1, 8),
    new LinearSales(2, 9),
    new LinearSales(3, 10),
    new LinearSales(4, 10.5),
    new LinearSales(5, 10.8),
    new LinearSales(6, 11),
  ];
//  for (int i = 0; i < 8; i++) {
//    data.add(new LinearSales(
//        int.parse(Tools.formatDate(list[i].date, format: 'dd')),
//        list[i].weight));
//  }
  return [
    new charts.Series<LinearSales, int>(
      id: 'highWeight',
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.lighter,
      strokeWidthPxFn: (_, __) => 1.0,
      dashPatternFn: (_, __) => [2, 2],
      areaColorFn: (_, __) => charts.MaterialPalette.white,
      domainFn: (LinearSales sales, _) => sales.day,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: lowData,
    ),
    new charts.Series<LinearSales, int>(
      id: 'weight',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      areaColorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault.lighter,
      domainFn: (LinearSales sales, _) => sales.day,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: middleData,
    )..setAttribute(charts.rendererIdKey, 'customPoint'),
    new charts.Series<LinearSales, int>(
      id: 'lowWeight',
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.lighter,
      strokeWidthPxFn: (_, __) => 1.0,
      dashPatternFn: (_, __) => [2, 2],
      areaColorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault.lighter,
      domainFn: (LinearSales sales, _) => sales.day,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: highData,
    ),
  ];
}

/// Sample linear data type.
class LinearSales {
  final int day;
  final double sales;

  LinearSales(this.day, this.sales);
}
