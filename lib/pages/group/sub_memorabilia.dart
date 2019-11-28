import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../utils/tools.dart';
import '../../models/group/memorabilia.dart';
import 'package:dio/dio.dart';

class SubMemorabilia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubMemorabilia();
  }
}

class _SubMemorabilia extends State<SubMemorabilia> {
  List<Memorabilia> memorabiliaList = <Memorabilia>[];

  Response response;
  Dio dio = Dio();
  bool showLoading = true;

  _getList() async {
    response = await dio
        .get("http://rap2api.taobao.org/app/mock/236857/memorabilia/list");
    setState(() {
      memorabiliaList = generateItems(response.data['data']['list']);
      showLoading = false;
    });
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
      return _memorabiliaList(memorabiliaList);
    }

  }
}

Widget _memorabiliaList(memorabiliaList){
 return new ListView.builder(
      itemCount: memorabiliaList.length,
      itemBuilder: (BuildContext context, int index) {
        return new Stack(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 45.0),
              child: new Card(
                margin: new EdgeInsets.all(5.0),
                child: new Container(
                  width: double.infinity,
                  height: 80.0,
                  child: Center(
                    child: ListTile(
                      leading: Image.network(memorabiliaList[index].photo),
                      title: Text(
                        memorabiliaList[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        memorabiliaList[index].description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            new Positioned(
              top: 3.0,
              bottom: 0.0,
              left: 0.0,
              child: Column(
                  children: <Widget>[
                    Text(
                      Tools.formatDate(memorabiliaList[index].date, format: 'yyyy'),
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      Tools.formatDate(memorabiliaList[index].date, format: 'MM'),
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
            ),
            new Positioned(
              top: 0.0,
              bottom: 0.0,
              left: 25.0,
              child: new Container(
                height: double.infinity,
                width: 1.0,
                color: Theme.of(context).accentColor,
              ),
            ),
            new Positioned(
              top: 30.0,
              left: 7.0,
              child: new Container(
                height: 36.0,
                width: 36.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: new Container(
                  margin: new EdgeInsets.all(5.0),
                  height: 30.0,
                  width: 30.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor,
                  ),
                  child: Center(
                    child: Text(Tools.formatDate(memorabiliaList[index].date, format: 'dd')),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
}

// 构建Memorabilia List数据
List<Memorabilia> generateItems(List array) {
  List<Memorabilia> list = [];
  if (array.length == 0) return list;
  print(array);
  array.forEach((elem) {
    list.add(Memorabilia(
        date: int.parse(elem['date']),
        title: elem['title'],
        description: elem['description'],
        photo: elem['photo'],
        tag: elem['tag'],
        isExpanded: false));
  });
  return list;
}
/*
*
*
*
* */

/*
* SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            memorabiliaList[index].isExpanded = !isExpanded;
          });
        },
        children: memorabiliaList.map<ExpansionPanel>((item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.description),
              );
            },
            body: ListTile(
                title: Text(item.tag),
                onTap: () {
                  setState(() {
                    memorabiliaList
                        .removeWhere((currentItem) => item == currentItem);
                  });
                }),
            isExpanded: item.isExpanded,
          );
        }).toList(),
      ),
    );
* */
