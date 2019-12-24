import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:collection';
import '../common/config.dart';

///http请求管理类，可单独抽取出来
class Http {
  static String baseUrl = Config.BASE_API_URL;
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  ///网络错误
  static const NETWORK_ERROR = -1;

  ///网络超时
  static const NETWORK_TIMEOUT = -2;

  ///网络返回数据格式化一次
  static const NETWORK_JSON_EXCEPTION = -3;

  static const SUCCESS = 200;

  static Map optionParams = {
    "timeoutMs": 15000,
    "token": null,
    "authorization": null,
  };

  static setBaseUrl(String baseUrl) {
    baseUrl = baseUrl;
  }

  static get(url, param) async {
    return await request(
        baseUrl + url, param, null, new Options(method: "GET"));
  }

  static post(url, param) async {
    print(url);
    print(param);
    print(baseUrl);
    return await request(
        baseUrl + url,
        param,
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(method: 'POST'));
  }

  static delete(url, param) async {
    return await request(
        baseUrl + url, param, null, new Options(method: 'DELETE'));
  }

  static put(url, param) async {
    return await request(baseUrl + url, param, null,
        new Options(method: "PUT", contentType: 'text/plain'));
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  static request(String url, params, Map<String, String> header, Options option,
      {noTip = false}) async {
    //没有网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return 'NETWORK_ERROR';
    }

    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    //授权码
    if (optionParams["authorization"] == null) {
      var authorization = await getAuthorization();
      if (authorization != null) {
        optionParams["authorization"] = authorization;
      }
    }

    headers["Authorization"] = optionParams["authorization"];
    // 设置 baseUrl

    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }

    ///超时
//    option.connectTimeout = 15000;

    Dio dio = new Dio();
    // 添加拦截器
    if (Config.DEBUG) {
      dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        print("\n================== 请求数据 ==========================");
        print("url = ${options.uri.toString()}");
        print("headers = ${options.headers}");
        print("params = ${options.data}");
        print("query = ${options.queryParameters}");
      }, onResponse: (Response response) {
        print("\n================== 响应数据 ==========================");
        print(response);
        print("code = ${response.statusCode}");
        print("data = ${response.data}");
        print("\n");
      }, onError: (DioError e) {
        print("\n================== 错误响应数据 ======================");
        print("type = ${e.type}");
        print("message = ${e.message}");
        print("\n");
      }));
    }

    Response response;
    try {
      if (option.method == 'GET') {
        response =
            await dio.request(url, queryParameters: params, options: option);
      } else {
        response = await dio.request(url, data: params, options: option);
      }
    } on DioError catch (e) {
      // 请求错误处理
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = NETWORK_TIMEOUT;
      }
      if (Config.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常 url: ' + url);
      }
      return new HttpException('请求异常');
    }

    try {
      if (option.contentType != null &&
          option.contentType.primaryType == "text") {
        return new ResultData(response.data, true, SUCCESS);
      } else {
        var responseJson = response.data;
        if (response.statusCode == 201 && responseJson["token"] != null) {
          // TODO: save token
          optionParams["authorization"] = 'Bearer ' + responseJson["token"];
        }
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResultData(response.data, true, SUCCESS,
            headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + url);
      return ResultData(response.data, false, response.statusCode,
          headers: response.headers);
    }
    return 'error is error';
  }

  ///清除授权
  static clearAuthorization() {
    optionParams["authorization"] = null;
  }

  ///获取授权token
  static getAuthorization() async {}
}

/// 网络结果数据
class ResultData {
  var data;
  bool result;
  int code;
  var headers;

  ResultData(this.data, this.result, this.code, {this.headers});
}
