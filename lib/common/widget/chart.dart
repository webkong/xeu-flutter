import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:xeu/common/constant/chart/index.dart';
import 'package:xeu/main.dart';

class TrendChart extends StatelessWidget {
  TrendChart(
      {Key key,
      this.tag,
      this.data,
      this.displayName = '',
      this.xAxis = '(单位：月)',
      this.yAxis = ''})
      : super(key: key);

  final List data;
  final String tag;
  final String displayName;
  final String xAxis;
  final String yAxis;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: _generateChart(tag, data),
        ),
        Center(
          child: Text(this.displayName),
        ),
        Positioned(
          child: Text(
            this.yAxis,
            style: TextStyle(color: Colors.lightBlue, fontSize: 12),
          ),
          top: 0,
          left: 0,
        ),
        Positioned(
          child: Text(
            this.xAxis,
            style: TextStyle(color: Colors.lightBlue, fontSize: 12),
          ),
          bottom: 0,
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
//        includeArea: true,
//        stacked: true,
          ),
      customSeriesRenderers: [
        new charts.LineRendererConfig(
            customRendererId: 'customPoint',
            includeArea: false,
            includePoints: true),
        new charts.LineRendererConfig(
          customRendererId: 'low',
          includeArea: true,
          stacked: false,
        ),
        new charts.LineRendererConfig(
            customRendererId: 'high', includeArea: true),
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
  logger.info(tag);
  logger.info(list);
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
    )..setAttribute(charts.rendererIdKey, 'low'),
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
    )..setAttribute(charts.rendererIdKey, 'high'),
  ];
}

Map generateLine(List list, Map defaultMap) {
  logger.info(list);
  List<LinearSales> _list = [];
  List<LinearSales> _minList = [];
  List<LinearSales> _maxList = [];
  for (int i = 0; i < list.length; i++) {
    _list.add(LinearSales(double.parse(list[i][0].toString()),
        double.parse(list[i][1].toString())));
  }
  for (int i = 0; i < 35; i++) {
    _minList.add(LinearSales(defaultX[i], defaultMap['min'][i]));
    _maxList.add(LinearSales(defaultX[i], defaultMap['max'][i]));
  }
  logger.info({"max": _maxList, "min": _minList, "data": _list});
  return {"max": _maxList, "min": _minList, "data": _list};
}

/// Sample linear data type.
class LinearSales {
  final double mouth;
  final double sales;

  LinearSales(this.mouth, this.sales);

  toJson(LinearSales linearSales) {
    return {'mouth': linearSales.mouth, 'sales': linearSales.sales};
  }
}
