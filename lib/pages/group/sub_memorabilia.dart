import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xeu/common/widget/ContentLoadStatus.dart';
import 'package:xeu/models/group/memorabilia_state.dart';
import 'package:xeu/common/utils/adapt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/utils/tools.dart';
import 'package:xeu/models/group/memorabilia.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/models/user/baby.dart';
import 'package:xeu/models/user/user_state.dart';

class SubMemorabilia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubMemorabilia();
  }
}

class _SubMemorabilia extends State<SubMemorabilia>
    with AutomaticKeepAliveClientMixin {
  List<Memorabilia> _memorabiliaList = <Memorabilia>[];
  Widget _contentLoad = ContentLoadStatus(
    flag: 'loading',
  );
  bool _pullData = false;
  String bid;
  _getList() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String uid = pres.getString("u_id");
    var response = await Http()
        .get(context, '/memorabilia/list', {"u_id": uid, "b_id": bid});
    if (response == -1) {
      setState(() {
        _contentLoad = ContentLoadStatus(
          flag: 'noNetwork',
        );
      });
    } else {
      setState(() {
        var list = generateItems(response.data['data']['list']);
        if (list.length == 0) {
          _contentLoad = ContentLoadStatus(
            flag: 'noContent',
          );
        } else {
          _memorabiliaList = list;
          _pullData = true;
        }
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Baby baby = Provider.of<UserModel>(context, listen: true).getDefaultBaby();
    bid = baby.bid;
    if (!_pullData) {
      return _contentLoad;
    } else {
      return Column(
        children: <Widget>[
          Consumer<MemorabiliaModel>(
            builder: (BuildContext context, MemorabiliaModel memorabiliaModel,
                child) {
              Widget prefixWidget;
              Map queue = memorabiliaModel.get();
              if (queue['tasks'].length > 0) {
                prefixWidget = _buildUploadingWidget(queue['tasks']);
              } else {
                prefixWidget = Container();
                if (memorabiliaModel.isDone() == 3) {
                  print('拉取');
                  memorabiliaModel.init();
                  this._getList();
                }
              }
              return prefixWidget;
            },
          ),
          Expanded(
            child: _buildMemorabiliaList(),
          ),
        ],
      );
    }
  }

  Widget _buildUploadingWidget(tasks) {
    var item = new Memorabilia(
        title: '上传中',
        images: tasks[0].memorabilia.images,
        date: DateTime.now().millisecondsSinceEpoch);
    return Container(
      child: _buildItemWidget(item, isLoading: true),
    );
  }

  Widget _buildUploadingCard(item) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(Adapt.px(30)),
            child: CircularProgressIndicator(),
            height: Adapt.px(60),
            width: Adapt.px(60),
          ),
          Text(item.title)
        ],
      ),
    );
  }

// 循环创建列表
  Widget _buildMemorabiliaList() {
    return RefreshIndicator(
      onRefresh: () async {
        _memorabiliaList.clear();
        _getList();
      },
      child: ListView.builder(
        itemCount: _memorabiliaList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItemWidget(_memorabiliaList[index]);
        },
      ),
    );
  }

// 创建 List 的item card
  Widget _buildItemWidget(Memorabilia item, {isLoading = false}) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: Adapt.px(20.0), top: Adapt.px(60.0)),
          child: isLoading
              ? _buildUploadingCard(item)
              : GestureDetector(
                  child: Card(
                    margin: EdgeInsets.all(Adapt.px(10.0)),
                    child: Container(
                      width: double.infinity,
                      height: Adapt.px(300.0),
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: Adapt.px(300),
                              width: Adapt.px(450),
                              child: CachedNetworkImage(
                                imageUrl: item.images.length > 0
                                    ? item.images[0]['url']
                                    : 'https://dummyimage.com/300x200/efefef',
                                placeholder: (context, url) =>
                                    Image.memory(kTransparentImage),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                fadeInCurve: Curves.easeIn,
                                filterQuality: FilterQuality.low,
                                height: Adapt.px(300),
                                width: Adapt.px(450),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  item.description != null
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              left: Adapt.px(10),
                                              right: Adapt.px(10)),
                                          child: Text(
                                            item.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      : Container(),
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
                  onTap: () {
                    Navigator.pushNamed(context, '/memorabiliaDetail',
                        arguments: {"mid": item.mid, "item": item});
                  },
                ),
        ),
        Positioned(
          top: Adapt.px(14.0),
          bottom: 0.0,
          left: Adapt.px(30.0),
          child: Column(
            children: <Widget>[
              item.date != null
                  ? Text(
                      Tools.formatDate(item.date, format: 'yyyy-MM-dd'),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    )
                  : Container(),
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
  }

// 构建Memorabilia List数据
  List<Memorabilia> generateItems(List array) {
    List<Memorabilia> list = [];
    if (array.length == 0) return list;
    array.forEach((elem) {
      list.add(Memorabilia.fromJson(elem));
    });
    return list;
  }
}
// date: DateTime.parse(elem['create_at']).millisecondsSinceEpoch,
