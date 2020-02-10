import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/main.dart';
import 'package:xeu/models/group/memorabilia.dart';
import 'package:xeu/common/utils/adapt.dart';
import 'package:xeu/common/utils/tools.dart';
import 'package:xeu/models/group/memorabilia_state.dart';
import 'package:xeu/models/user/user_state.dart';

class MemorabiliaDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemorabiliaDetail();
  }
}

class _MemorabiliaDetail extends State<MemorabiliaDetail> {
  Memorabilia _memorabilia =
      new Memorabilia(images: [], title: '', description: '');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map routeParams = ModalRoute.of(context).settings.arguments;
    print(routeParams);
    _memorabilia = routeParams['item'];
    logger.info(_memorabilia.toJson());
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          MaterialButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    children: <Widget>[
                      ListTile(
                        title: Text('删除'),
                        onTap: () {
                          _deleteMemorabilia(context, _memorabilia);
                        },
                      ),
                      Container(
                        height: Adapt.px(1),
                        color: Colors.grey,
                      ),
                      ListTile(
                        title: Text('取消'),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.more_horiz),
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(239, 239, 239, 1),
      body: Container(
//        margin: EdgeInsets.all(Adapt.px(30)),
        child: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                    left: Adapt.px(20),
                    top: Adapt.px(20),
                    bottom: Adapt.px(30)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      _memorabilia.title,
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: Adapt.px(20)),
                      child: Text(
                        Tools.formatDate(_memorabilia.date),
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                )),
            ..._photoList(_memorabilia.images),
            _memorabilia.description != null
                ? Text(_memorabilia.description)
                : null
          ],
        ),
      ),
    );
  }

  _deleteMemorabilia(BuildContext context, memorabilia) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '确认删除?',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: () async {

                  await Http().post(context, '/memorabilia/del',
                      {"u_id": memorabilia.uid, "b_id": memorabilia.bid, "m_id": memorabilia.mid});
                  Provider.of<MemorabiliaModel>(context, listen: false)
                      .del();
                  Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                },
              ),
            ],
          );
        },);
  }


  List _photoList(images) {
    return List.generate(images.length, (index) {
      return Container(
        margin: EdgeInsets.only(
            left: Adapt.px(20),
            right: Adapt.px(20),
            top: Adapt.px(10),
            bottom: Adapt.px(10)),
        child: CachedNetworkImage(
          imageUrl: images[index]['url'],
          placeholder: (context, url) => Image.memory(kTransparentImage),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
          fadeInCurve: Curves.easeIn,
          filterQuality: FilterQuality.low,
        ),
      );
    }).toList();
  }
}
