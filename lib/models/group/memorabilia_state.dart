import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:xeu/main.dart';
import 'package:xeu/models/group/memorabilia.dart';
import '../../common/utils/http.dart';
import 'package:http_parser/http_parser.dart';

class MemorabiliaModel with ChangeNotifier {
  BuildContext context;
  int _taskStatus = 0; // 0 没有任务 2 任务进行中 3 任务结束  -1 任务存在失败情况
  List<Task> _tasks = [];
  List<Task> _succeedTasks = [];
  List<Task> _failTasks = [];
  Map get() => {"tasks": _tasks, "fail": _failTasks};
  void init() {
    _tasks.clear();
    _taskStatus = 0;
    _succeedTasks.clear();
    _failTasks.clear();
  }

  int isDone() {
    return _taskStatus;
  }

  del() async {
    _taskStatus = 3;
    notifyListeners();
    return true;
  }

  void add(context, item) async {
    this.context = context;
    print(' into add ...............`');
    print(item);
    //添加数组
    _tasks.add(new Task(memorabilia: item, status: 0));
    //设置任务状态
    _taskStatus = 2;
    notifyListeners();
    await _upload();
  }

  _upload() async {
    if (_tasks.length == 0) return;
    var item = _tasks[0].memorabilia;
    print(' into upload ...............`');
    print(item.images);
    // TODO有多图，批次上传
    List<Future> files = [];
    int length = item.images.length;
    if (length > 0) {
      for (int i = 0; i < length; i++) {
        files.add(convertAssetToHttp(item.images[i], item.uid));
      }
    } else {
      return null;
    }
    try {
      var list = await Future.wait(files);
      var res = await _updateMemorabilia(list, item);
      print(res);
      //TODO：上传失败
      // 删除数组中的上传完毕的内容,并添加success list
      _succeedTasks.add(_tasks.removeAt(0));
      // 根据任务情况查看
      if (_tasks.length == 0) {
        logger.info(('task status 3'));
        _taskStatus = 3;
        notifyListeners();
      } else {
        _upload();
      }
    } catch (e) {
      Task failTask = _tasks.removeAt(0);
      failTask.status = -1;
      _failTasks.add(failTask);
      if (_tasks.length > 0) {
        _upload();
      }
    }
  }

  _updateMemorabilia(List list, item) async {
    print('更新记录');
    List images = new List.generate(
        list.length, (int index) => {"url": list[index], "index": index});
    return Http().post('/memorabilia/update', {
      "u_id": item.uid,
      'b_id': item.bid,
      "m_id": item.mid,
      "images": images
    });
  }

  Future convertAssetToHttp(Asset asset, String uid) async {
    String name = asset.name;
    String suffix = name.split('.').removeLast();
    logger.info(name);
    logger.info(suffix);
//    logger.info(asset.identifier);
//    logger.info(await asset.metadata);
    ByteData byteData = await asset.getByteData();
    List<int> imageDataList = byteData.buffer.asUint8List();
    try {
      List<int> imageData = await FlutterImageCompress.compressWithList(
        imageDataList,
//      minHeight: 1920,
//      minWidth: 1080,
        quality: 80,
//      rotate: 180,
      );
      logger.info(imageData);

      MultipartFile multipartFile = MultipartFile.fromBytes(
        imageData,
        filename: name,
        contentType: MediaType("image", suffix),
      );
      print('multipartFile $multipartFile');
      FormData formData = FormData.fromMap({
        "file": multipartFile,
      });
      print('upload file');
      var res = await Http().file('/upload/file?u_id=' + uid, formData);
      return res.data;
    } catch (e) {
      logger.warning(e);
    }
  }
}

class Task {
  Task({this.memorabilia, this.status});
  Memorabilia memorabilia;
  int status; //0 未开始 1上传中 2 已完成 -1失败 3部分失败
}
