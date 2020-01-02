import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:xeu/common/constant/index.dart';

class TrendChart extends StatelessWidget {
  TrendChart({Key key, this.tag, this.data}) : super(key: key);

  final List data;
  final String tag;

  @override
  Widget build(BuildContext context) {
     var middleData = [
    new LinearSales(0, 6),
    new LinearSales(1, 7),
    new LinearSales(2, 8),
    new LinearSales(3, 9),
    new LinearSales(4, 9.3),
    new LinearSales(5, 9.4),
    new LinearSales(6, 9.7),
  ];
    return _generateChart(tag, middleData);
  }
}

List<num> defaultX = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  15,
  18,
  21,
  24,
  27,
  30,
  33,
  36,
  39,
  42,
  45,
  48,
  51,
  54,
  57,
  60,
  63,
  66,
  69,
  72,
  75,
  78,
  81,
];

//图表
Widget _generateChart(String tag, List list) {
  List<charts.Series> seriesList = _createSampleData(tag, list) ?? [];

  return Container(
    height: 300,
    width: 400,
    child: new charts.LineChart(
      seriesList,
      animate: false,
      defaultRenderer: new charts.LineRendererConfig(
        includeArea: true,
        stacked: true,
      ),
      customSeriesRenderers: [
        new charts.LineRendererConfig(
            customRendererId: 'customPoint', includePoints: true),
      ],
      behaviors: [
        new charts.PanBehavior(),
      ],
    ),
  );
}

/// Create one series with sample hard coded data.
List<charts.Series<LinearSales, int>> _createSampleData(String tag, List list) {

  Map defaultData = BodyConstants.getByTag(tag);

  Map seriesMap = generateLine(list, defaultData);

  return [
    new charts.Series<LinearSales, int>(
      id: 'lowWeight',
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.lighter,
      strokeWidthPxFn: (_, __) => 1.0,
      dashPatternFn: (_, __) => [2, 2],
      areaColorFn: (_, __) => charts.MaterialPalette.white,
      domainFn: (LinearSales sales, int index) {
        return sales.mouth;
      },
      measureFn: (LinearSales sales, int index) => sales.sales,
      data: seriesMap['min'],
    ),
    new charts.Series<LinearSales, int>(
      id: 'weight',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      areaColorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault.lighter,
      domainFn: (LinearSales sales, _) => sales.mouth,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: seriesMap['data'],
    )..setAttribute(charts.rendererIdKey, 'customPoint'),
    new charts.Series<LinearSales, int>(
      id: 'highWeight',
      colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.lighter,
      strokeWidthPxFn: (_, __) => 1.0,
      dashPatternFn: (_, __) => [2, 2],
      areaColorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.lighter,
      domainFn: (LinearSales sales, _) => sales.mouth,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: seriesMap['max'],
    ),
  ];
}

Map generateLine(List list, Map defaultMap) {
  print(list);
  List<LinearSales> _list = [];
  List<LinearSales> _minList = [];
  List<LinearSales> _maxList = [];
  for (int i = 0; i < list.length; i++) {
//    _list.add(LinearSales(defaultX[i], list[i]));
    _list.add( list[i]);
    _minList.add(LinearSales(defaultX[i], defaultMap['min'][i]));
    _maxList.add(LinearSales(defaultX[i], defaultMap['max'][i]));
  }
  return {"max": _maxList, "min": _minList, "data":_list};
}

/// Sample linear data type.
class LinearSales {
  final int mouth;
  final double sales;

  LinearSales(this.mouth, this.sales);
}
