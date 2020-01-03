import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:xeu/common/constant/index.dart';
import 'package:xeu/common/utils/adapt.dart';

class TrendChart extends StatelessWidget {
  TrendChart({Key key, this.tag, this.data, this.displayName = ''})
      : super(key: key);

  final List data;
  final String tag;
  final String displayName;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _generateChart(tag, data),
        Positioned(
          child: Text(this.displayName),
          top: 0,
          left: 0,
        ),
        Positioned(
          child: Text(this.displayName),
          bottom: -10,
          right: 0,
        ),
      ],
    );
  }
}

List<double> defaultX = [
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
    child: charts.LineChart(
      seriesList,
      animate: false,
      defaultRenderer: new charts.LineRendererConfig(
        includeArea: true,
        stacked: true,
      ),
      customSeriesRenderers: [
        new charts.LineRendererConfig(
          customRendererId: 'customPoint',
        ),
      ],
      behaviors: [
        new charts.PanBehavior(),
      ],
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          updatedListener: (charts.SelectionModel model) {
            print(model.selectedSeries);
          },
        ),
      ],
    ),
  );
}

/// Create one series with sample hard coded data.
List<charts.Series<LinearSales, double>> _createSampleData(
    String tag, List list) {
  Map defaultData = BodyConstants.getByTag(tag);

  Map seriesMap = generateLine(list, defaultData);

  return [
    new charts.Series<LinearSales, double>(
      id: 'low',
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
    new charts.Series<LinearSales, double>(
      id: 'data',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      areaColorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault.lighter,
      domainFn: (LinearSales sales, _) => sales.mouth,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: seriesMap['data'],
    )..setAttribute(charts.rendererIdKey, 'customPoint'),
    new charts.Series<LinearSales, double>(
      id: 'high',
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
  for (int i = 0; i < min(list.length, 35); i++) {
//    _list.add(LinearSales(defaultX[i], list[i]));
    _list.add(LinearSales(double.parse(list[i][0].toString()),
        double.parse(list[i][1].toString())));
    _minList.add(LinearSales(defaultX[i], defaultMap['min'][i]));
    _maxList.add(LinearSales(defaultX[i], defaultMap['max'][i]));
  }
  return {"max": _maxList, "min": _minList, "data": _list};
}

/// Sample linear data type.
class LinearSales {
  final double mouth;
  final double sales;

  LinearSales(this.mouth, this.sales);
}
