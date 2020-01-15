import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:xeu/common/config/config.dart';
import 'package:xeu/common/widget/toast.dart';

import '../global.dart';

///http请求管理类，可单独抽取出来
class Http {
  BuildContext context;
  static String baseUrl = Config.BASE_API_URL;
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static const CONTENT_TYPE_MULTIPART = "multipart/form-data";

  ///网络错误
  static const NETWORK_ERROR = -1;

  ///网络超时
  static const NETWORK_TIMEOUT = -2;

  ///网络返回数据格式化一次
  static const NETWORK_JSON_EXCEPTION = -3;

  static const SUCCESS = 200;

  static Map optionParams = {
    "timeoutMs": 15000,
    "authorization": null,
  };

  setBaseUrl(String baseUrl) {
    baseUrl = baseUrl;
  }

  get(BuildContext context, url, param) async {
    return await request(
        context, baseUrl + url, param, null, new Options(method: "GET"));
  }

  post(BuildContext context, url, param) async {
    return await request(
        context, baseUrl + url, param, null, new Options(method: 'POST'));
  }

  file(BuildContext context, url, param) async {
    return await request(context, baseUrl + url, param, null,
        new Options(method: 'POST', contentType: CONTENT_TYPE_MULTIPART));
  }

  put(BuildContext context, url, param) async {
    return await request(context, baseUrl + url, param, null,
        new Options(method: "PUT", contentType: 'text/plain'));
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  request(BuildContext context, String url, params, Map<String, String> header,
      Options option,
      {noTip = false}) async {
    this.context = context;
    //没有网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Toast.show('网络不可用，请打开网络', context,duration: 10);
      return NETWORK_ERROR;
    }

    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
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
    option.sendTimeout = 15000;
    option.receiveTimeout = 15000;

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
      Toast.show('服务器繁忙', context, duration: 10000);
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (errorResponse.statusCode == 401) {
        Global().unAuth(context);
        return new HttpException('未授权');
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
      var responseJson = response.data;
      if (response.statusCode == 201 && responseJson["data"]["token"] != null) {
        print('set authorization');
        optionParams["authorization"] =
            'Bearer ' + responseJson["data"]["token"];
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResultData(response.data, true, SUCCESS,
            headers: response.headers);
      }
    } catch (e) {
      return ResultData(response.data, false, response.statusCode,
          headers: response.headers);
    }
//    return 'error is error';
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
