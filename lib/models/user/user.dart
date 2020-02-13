//import 'package:json_annotation/json_annotation.dart';
//
//part 'user.g.dart';
//
//@JsonSerializable()

class User {
  User({
    this.uid,
    this.token,
    this.phone,
    this.nickName,
    this.deviceInfo,
    this.location,
    this.avatar,
    this.country,
    this.defaultBaby,
    this.babies,
  });
  String uid;
  String token;
  String phone;
  String nickName;
  Map deviceInfo;
  Map location;
  String avatar;
  String country;
  String defaultBaby;
  List babies;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    uid: json['_id'] as String,
    token: json['token'] as String,
    phone: json['phone'] as String,
    nickName: json['nick_name'] as String,
    deviceInfo: json['device_info'] as Map<String, dynamic>,
    location: json['location'] as Map<String, dynamic>,
    avatar: json['avatar'] as String,
    country: json['country'] as String,
    defaultBaby: json['default_baby'] as String,
    babies: json['babies'] as List,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.uid,
      'token': instance.token,
      'phone': instance.phone,
      'nick_name': instance.nickName,
      'device_info': instance.deviceInfo,
      'location': instance.location,
      'avatar': instance.avatar,
      'country': instance.country,
      'default_baby': instance.defaultBaby,
      'babies': instance.babies,
    };
