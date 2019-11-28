import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:device_info/device_info.dart';
part 'deviceInfo.g.dart';

@JsonSerializable()
class DeviceInfo {
  DeviceInfo();
  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
  static get() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print(androidInfo);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print(iosInfo);
    }
  }
}
