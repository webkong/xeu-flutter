// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memorabilia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Memorabilia _$MemorabiliaFromJson(Map<String, dynamic> json) {
  return Memorabilia(
    date: json['date'] as num,
    title: json['title'] as String,
    description: json['description'] as String,
    photo: json['photo'] as String,
    tag: json['tag'] as String,
    isExpanded: json['isExpanded'] as bool,
  );
}

Map<String, dynamic> _$MemorabiliaToJson(Memorabilia instance) =>
    <String, dynamic>{
      'date': instance.date,
      'title': instance.title,
      'description': instance.description,
      'photo': instance.photo,
      'tag': instance.tag,
      'isExpanded': instance.isExpanded,
    };
