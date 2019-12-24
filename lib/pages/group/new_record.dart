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
  String _description, _title;
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
      body: Container(
        margin: EdgeInsets.only(
            left: Adapt.px(40), right: Adapt.px(40), top: Adapt.px(20)),
        child: Center(
          child: Form(
            key: _formRecord,
            child: buildNewRecord(),
          ),
        ),
      ),
    );
  }

  Widget buildNewRecord() {
    return Column(
      children: <Widget>[
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
        Container(
          child: buildTag(),
        ),
        Container(
          child: ListTile(
            leading: FlutterLogo(),
            title: Text('One-line with both widgets'),
            trailing: Icon(Icons.arrow_forward),
          ),
        ),
        Container(
          child: ListTile(
            leading: FlutterLogo(),
            title: Text('One-line with both widgets'),
            trailing: Icon(Icons.arrow_forward),
          ),
        ),
        Expanded(
          child: ListTile(
            leading: FlutterLogo(),
            title: Text('One-line with both widgets'),
            trailing: Icon(Icons.arrow_forward),
          ),
        ),
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
        })
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

  Widget buildTag() {
    int _value = 1;
    return Wrap(
      children: List<Widget>.generate(
        3,
        (int index) {
          return ChoiceChip(
            label: Text('Item $index'),
            selected: _value == index,
            onSelected: (bool selected) {
              setState(() {
                _value = selected ? index : null;
              });
            },
          );
        },
      ).toList(),
    );
  }

  save(BuildContext context) {}
}
