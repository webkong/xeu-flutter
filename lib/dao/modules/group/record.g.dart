// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) {
  return Record(
    json['date'] as num,
    json['height'] as num,
    json['weight'] as num,
    json['head'] as num,
  );
}

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      'date': instance.date,
      'height': instance.height,
      'weight': instance.weight,
      'head': instance.head,
    };
