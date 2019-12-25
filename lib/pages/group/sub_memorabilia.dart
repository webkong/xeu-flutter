import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xeu/models/group/memorabilia_state.dart';
import 'package:xeu/utils/adapt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/tools.dart';
import '../../models/group/memorabilia.dart';
import '../../utils/http.dart';

class SubMemorabilia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubMemorabilia();
  }
}

class _SubMemorabilia extends State<SubMemorabilia> {
  List<Memorabilia> _memorabiliaList = <Memorabilia>[];
  bool showLoading = true;
  _getList() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String uid = pres.getString("u_id");
    var response = await Http.get('/record/list', {"u_id": uid});
    setState(() {
      _memorabiliaList = generateItems(response.data['data']['list']);
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
        child: Container(
          child: CircularProgressIndicator(),
          height: Adapt.px(60),
          width: Adapt.px(60),
        ),
      );
    } else {
      return Consumer(
        builder: (BuildContext context, MemorabiliaModel memorabiliaUploadList,
            child) {
          Widget prefixWidget;
          print('list List<dynamic> listName');
          print(memorabiliaUploadList.get());
          if (memorabiliaUploadList.get().length > 0) {
            prefixWidget = _buildUploading();
          } else {
            print(000000000000000000);
          }
          return Column(
            children: <Widget>[
              Container(
                child: Text('1111'),
              ),
              Expanded(
                child: _buildMemorabiliaList(),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildUploading() {}

  Widget _buildMemorabiliaList() {
    return ListView.builder(
      itemCount: _memorabiliaList.length,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(left: Adapt.px(20.0), top: Adapt.px(60.0)),
              child: Card(
                margin: EdgeInsets.all(Adapt.px(10.0)),
                child: Container(
                  width: double.infinity,
                  height: Adapt.px(300.0),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Image(
                          image: NetworkImage(
                              _memorabiliaList[index].images[0]['url']),
                          height: Adapt.px(300),
                          width: Adapt.px(450),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                _memorabiliaList[index].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: Adapt.px(10), right: Adapt.px(10)),
                                child: Text(
                                  _memorabiliaList[index].description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Adapt.px(14.0),
              bottom: 0.0,
              left: Adapt.px(30.0),
              child: Column(
                children: <Widget>[
                  Text(
                    Tools.formatDate(_memorabiliaList[index].date,
                        format: 'yyyy-MM-dd'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              bottom: 0.0,
              left: Adapt.px(10.0),
              child: Container(
                height: double.infinity,
                width: 1.0,
                color: Theme.of(context).accentColor,
              ),
            ),
            Positioned(
              top: Adapt.px(20.0),
              left: 0.0,
              child: Container(
                height: Adapt.px(20.0),
                width: Adapt.px(20.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Container(
//                  margin: new EdgeInsets.all(5.0),
                  height: Adapt.px(20.0),
                  width: Adapt.px(20.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor,
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
      list.add(
        Memorabilia(
            uid: elem['u_id'],
            mid: elem['_id'],
            date: DateTime.parse(elem['create_at']).millisecondsSinceEpoch,
            title: elem['title'],
            description: elem['description'],
            images: elem['images'],
            scope: elem['scope'],
            location: elem['location']),
      );
    });
    print(list);
    return list;
  }
}
