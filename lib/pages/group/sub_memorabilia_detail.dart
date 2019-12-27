import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/models/group/memorabilia.dart';
import 'package:xeu/utils/http.dart';

class MemorabiliaDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemorabiliaDetail();
  }
}

class _MemorabiliaDetail extends State<MemorabiliaDetail> {
  Memorabilia _memorabilia;
  bool showLoading = false;
  _getList() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String uid = pres.getString("u_id");
    Map routeParams = ModalRoute.of(context).settings.arguments;
    print(routeParams);
    var response =
        await Http.get('/memorabilia/getOne', {"u_id": uid, "m_id": routeParams['mid']});
    setState(() {
      _memorabilia = Memorabilia.fromJson(response.data['data']);
      showLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
//     print( ModalRoute.of(context));
    _getList();
  }

  @override
  Widget build(BuildContext context) {
    if (showLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(),
        body: _photoList(_memorabilia),
      );
    }
  }
}

Widget _photoList(memorabilia) {
  return new ListView.builder(
    itemCount: memorabilia.images.length,
    itemBuilder: (BuildContext context, int index) {
      return Image.network(memorabilia.images[index]['url']);
    },
  );
}
