import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xeu/common/config/config.dart';
import 'package:xeu/models/group/memorabilia.dart';
import '../../common/utils/http.dart';
import 'package:http_parser/http_parser.dart';

class MemorabiliaModel with ChangeNotifier {
  int _taskStatus = 0; // 0 没有任务 2 任务进行中 3 任务结束  -1 任务存在失败情况
  List<Task> _tasks = [];
  List<Task> _succeedTasks = [];
  List<Task> _failTasks = [];
  Map get() => {"tasks": _tasks, "fail": _failTasks};
  void init(){
    _tasks.clear();
    _taskStatus = 0;
    _succeedTasks.clear();
    _failTasks.clear();
  }
  int isDone() {
    return _taskStatus;
  }

  void add(item) {
    print(' into add ...............`');
    print(item);
    //添加数组
    _tasks.add(new Task(memorabilia: item, status: 0));
    //设置任务状态
    _taskStatus = 2;
    _upload();
    notifyListeners();
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
        files.add(convertAssetToHttp(item.images[i]));
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
        print('set _stat');
        _taskStatus = 3;
        print('notify start');
        notifyListeners();
        print('notify end');
//        init();
        print('init ');
      } else {
        _upload();
      }
    } catch (e) {
      Task failTask = _tasks.removeAt(0);
      failTask.status = -1;
      _failTasks.add(failTask);
      if(_tasks.length > 0){
        _upload();
      }
    }
  }

  _updateMemorabilia(List list, item) async {
    print('更新记录');
    List images = new List.generate(
        list.length, (int index) => {"url": list[index], "index": index});
    return Http.post('/memorabilia/update',
        {"u_id": item.uid, "m_id": item.mid, "images": images});
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
