// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memorabilia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Memorabilia _$MemorabiliaFromJson(Map<String, dynamic> json) {
  return Memorabilia(
    uid: json['uid'] as String,
    mid: json['mid'] as String,
    date: json['date'] as num,
    title: json['title'] as String,
    description: json['description'] as String,
    images: json['images'] as List,
    video: json['video'] as String,
    scope: json['scope'] as List,
    location: json['location'] as String,
  );
}

Map<String, dynamic> _$MemorabiliaToJson(Memorabilia instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'mid': instance.mid,
      'date': instance.date,
      'title': instance.title,
      'description': instance.description,
      'images': instance.images,
      'video': instance.video,
      'scope': instance.scope,
      'location': instance.location,
    };
