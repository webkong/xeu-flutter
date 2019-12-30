import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:xeu/models/group/memorabilia.dart';
import 'package:xeu/utils/adapt.dart';
import 'package:xeu/utils/tools.dart';

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
    return Scaffold(
      appBar: AppBar(),
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
}

List _photoList(images) {
  return List.generate(images.length, (index) {
    return Column(
      children: <Widget>[
        Container(
          height: 5,
        ),
        CachedNetworkImage(
          imageUrl: images[index]['url'],
          placeholder: (context, url) => Image.memory(kTransparentImage),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
          fadeInCurve: Curves.easeIn,
          filterQuality: FilterQuality.low,
        ),
        Container(
          height: 5,
        ),
      ],
    );
  }).toList();
}
