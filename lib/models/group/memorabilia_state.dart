import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xeu/common/config.dart';
import 'package:xeu/models/group/memorabilia.dart';
import '../../utils/http.dart';
import 'package:http_parser/http_parser.dart';

class MemorabiliaModel with ChangeNotifier {
  int _index = -1;
  List<Task> _tasks = [];
  List<Memorabilia> _memorabiliaUploadList = [];
  List get() => _memorabiliaUploadList;

  void add(item) {
    print(' into add ...............`');
    print(item);
    _tasks.add(new Task(memorabilia: item, status: 0));
    _upload();
    notifyListeners();
  }

  _upload() async {
    if (_index != -1) return null;
    var item = _tasks[0].memorabilia;
    var status = _tasks[0].status;
    print(' into upload ...............`');
    print(item.images);
    // TODO有多图，批次上传
    List<Future> files = [];
    int length = item.images.length;
    if (length > 0) {
      for (int i = 0; i < length; i++) {
        files.add(convertAssetToHttp(item.images[i]));
      }
    } else {
      return null;
    }
    try {
      var list = await Future.wait(files);
      await _updateMemorabilia(list, item);
      // 删除数组中的上传完毕的内容
      _memorabiliaUploadList.removeAt(0);
      _upload();
    } catch (e) {
      //设置状态
      _tasks[0].status = -1;
    }

//    notifyListeners();
  }

  _updateMemorabilia(List list, item) async {
    print('更新记录');
    List images = new List.generate(
        list.length, (int index) => {"url": list[index], "index": index});
    return Http.post(
        '/record/update', {"u_id": item.uid, "_id": item.mid, "images": images});
  }

  Future convertAssetToHttp(asset) async {
    Dio dio = new Dio();
    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    MultipartFile multipartFile = MultipartFile.fromBytes(
      imageData,
      filename: 'file.jpg',
      contentType: MediaType("image", "jpg"),
    );
    print('multipartFile $multipartFile');
    FormData formData = FormData.fromMap({
      "file": multipartFile,
    });
    var res = await dio.post(Config.BASE_API_URL + '/upload/file',
        data: formData, options: Options(contentType: "multipart/form-data"));
    return res.data;
  }
}

class Task {
  Task({this.memorabilia, this.status});
  Memorabilia memorabilia;
  int status; //0 未开始 1上传中 2 已完成 -1失败 3部分失败
}
