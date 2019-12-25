import 'package:flutter/material.dart';
import 'package:xeu/utils/adapt.dart';
import 'package:xeu/utils/toast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class NewRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewRecord();
  }
}

class _NewRecord extends State<NewRecord> {
  final _formRecord = GlobalKey<FormState>();
  String _description, _title, _tag;
  String prefix = '身高';
  List<Asset> _photoList = List<Asset>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          leading: CloseButton(),
          centerTitle: true,
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Toast.show('保存成功', context);
                _formRecord.currentState.save();
                save();
                //TODO 保存到全局上传任务中，并给上一个页面传递本次record的内容作为临时展示。
              },
              child: Text(
                '添加',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
      ),
      body: WillPopScope(
          child: Container(
            margin: EdgeInsets.only(
                left: Adapt.px(40), right: Adapt.px(40), top: Adapt.px(20)),
            child: Center(
              child: Form(
                key: _formRecord,
                child: buildNewRecord(),
              ),
            ),
          ),
          onWillPop: () async {
            var _flag;
            await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text('保留此次编辑？'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('保留'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            _flag = false;
                          },
                        ),
                        FlatButton(
                          child: Text('不保留'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            _flag = true;
                          },
                        ),
                      ],
                    ),
                barrierDismissible: false);
            print(_flag);
            return _flag;
          }),
    );
  }

  Widget buildNewRecord() {
    return Column(
      children: <Widget>[
        Container(
          child: buildTitle(),
        ),
        Container(
          margin: EdgeInsets.only(bottom: Adapt.px(10)),
          child: TextFormField(
            maxLength: 200,
            maxLines: 4,
            decoration: InputDecoration(
                hintText: '宝宝在笑、在跑，还是在发呆...', border: InputBorder.none),
            onSaved: (String value) => _description = value,
          ),
        ),
        Expanded(
          child: buildPhoto(),
        ),
//        Container(
//          child: ListTile(
//            leading: FlutterLogo(),
//            title: Text('所在位置'),
//            trailing: Icon(Icons.arrow_forward),
//          ),
//        )
      ],
    );
  }

// 构建 图片
  Widget buildPhoto() {
    return GridView.count(
      crossAxisSpacing: Adapt.px(10),
      mainAxisSpacing: Adapt.px(10),
      crossAxisCount: 5,
      children: <Widget>[
        _addPhotoButton(),
        ...List.generate(_photoList.length, (index) {
          Asset asset = _photoList[index];
          return _buildPhotoItem(asset);
        }).toList(),
      ],
    );
  }

  Widget _buildPhotoItem(Asset photo) {
    return Container(
      height: Adapt.px(80),
      width: Adapt.px(80),
      child: AssetThumb(
        asset: photo,
        width: 80,
        height: 80,
      ),
      decoration: BoxDecoration(color: Colors.black12),
    );
  }

  Widget _addPhotoButton() {
    return GestureDetector(
        child: Container(
          height: Adapt.px(80),
          width: Adapt.px(80),
          child: Icon(Icons.camera_alt),
          decoration: BoxDecoration(color: Colors.black12),
        ),
        onTap: getImage);
  }

  Future<void> getImage() async {
    List<Asset> images;
    images = await MultiImagePicker.pickImages(
      maxImages: 8,
      enableCamera: true,
      selectedAssets: _photoList,
      materialOptions: MaterialOptions(
        actionBarTitle: "Action bar",
        allViewTitle: "All view title",
        actionBarColor: "#FFBF00",
        actionBarTitleColor: "#FFFFFF",
        lightStatusBar: false,
        statusBarColor: '#FFBF00',
        startInAllView: true,
        selectCircleStrokeColor: "#FFFFFF",
        selectionLimitReachedText: "You can't select any more.",
      ),
    );
    print(images);
    if (!mounted) return;
    setState(() {
      _photoList = images;
    });
  }

  Widget buildTitle() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10),
          child: Text(
            prefix,
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: TextFormField(
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(),
            onSaved: (value) {
              setState(() {
                _tag = value;
                _title = prefix + value;
              });
            },
          ),
        ),
      ],
    );
  }

  save() {
    print("tiltle: $_title, description: $_description, ");
    print("images: $_photoList");
    Navigator.of(context).pop({"title": _title, "description": _description, "photo": _photoList});
  }
}
