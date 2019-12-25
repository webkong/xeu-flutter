// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) {
  return Record(
    rid: json['rid'] as String,
    date: json['date'] as num,
    height: json['height'] as num,
    weight: json['weight'] as num,
    head: json['head'] as num,
  );
}

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'rid': instance.rid,
      'date': instance.date,
      'height': instance.height,
      'weight': instance.weight,
      'head': instance.head,
    };
