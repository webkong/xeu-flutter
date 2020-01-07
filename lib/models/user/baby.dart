//import 'package:json_annotation/json_annotation.dart';
//
//part 'baby.g.dart';
//
//@JsonSerializable()
class Baby {
  Baby({
    this.bid,
    this.uid,
    this.nickName,
    this.name,
    this.gender,
    this.birthday,
    this.blood,
    this.avatar,
    this.inviteCode,
    this.family,
  });
  String bid;
  String uid;
  String nickName;
  String name;
  int gender; // 0男 1女
  int birthday; // 时间戳
  String blood; // A B AB O
  String avatar;
  String inviteCode; // 邀请码
  List family;
  factory Baby.fromJson(Map<String, dynamic> json) => _$BabyFromJson(json);
  Map<String, dynamic> toJson() => _$BabyToJson(this);
}

Baby _$BabyFromJson(Map<String, dynamic> json) {
  return Baby(
    bid: json['b_id'] as String,
    uid: json['u_id'] as String,
    nickName: json['nick_name'] as String,
    name: json['name'] as String,
    gender: json['gender'] as int,
    birthday: json['birthday'] as int,
    blood: json['blood'] as String,
    avatar: json['avatar'] as String,
    inviteCode: json['invite_code'] as String,
    family: json['family'] as List,
  );
}

Map<String, dynamic> _$BabyToJson(Baby instance) => <String, dynamic>{
      'b_id': instance.bid,
      'u_id': instance.uid,
      'nick_name': instance.nickName,
      'name': instance.name,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'blood': instance.blood,
      'avatar': instance.avatar,
      'invite_code': instance.inviteCode,
      'family': instance.family,
    };
