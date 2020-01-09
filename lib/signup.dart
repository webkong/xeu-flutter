import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {

  var _image ;

  _getImage()async{
     var image = await MultiImagePicker.pickImages(
      maxImages: 1,
      enableCamera: true,
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
     print(image);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('signUpPage'),
      ),
      body: Container(),
    );
  }

  final cropKey = GlobalKey<CropState>();

  Widget _buildCropImage() {

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(20.0),
      child: Crop(
        key: cropKey,
        image: AssetImage('assets/images/01.png'),
        aspectRatio: 4.0 / 4.0,
      ),
    );
  }
}
