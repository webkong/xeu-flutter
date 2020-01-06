class Record {
  Record({this.rid, this.uid, this.date, this.height, this.weight, this.head});
  String rid;
  String uid;
  num date;
  num height;
  num weight;
  num head;
  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);
  Map<String, dynamic> toJson() => _$RecordToJson(this);
}

Record _$RecordFromJson(Map<String, dynamic> json) {
  return Record(
    rid: json['_id'] as String,
    date: DateTime.parse(json['create_at']).millisecondsSinceEpoch,
    height: json['height'] as num,
    weight: json['weight'] as num,
    head: json['head'] as num,
    uid: json['u_id'] as String,
  );
}

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
      '_id': instance.rid,
      'u_id': instance.uid,
      'height': instance.height,
      'weight': instance.weight,
      'head': instance.head,
    };
