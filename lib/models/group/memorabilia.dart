class Memorabilia {
  Memorabilia(
      {this.uid,
      this.mid,
      this.date,
      this.title,
      this.description,
      this.images,
      this.video = '',
      this.scope = const [],
      this.location = ''});
  String uid;
  String mid;
  num date;
  String title;
  String description;
  List images;
  String video;
  List scope;
  String location;
  factory Memorabilia.fromJson(Map<String, dynamic> json) =>
      _$MemorabiliaFromJson(json);
  Map<String, dynamic> toJson() => _$MemorabiliaToJson(this);
}

Memorabilia _$MemorabiliaFromJson(Map<String, dynamic> json) {
  return Memorabilia(
    uid: json['u_id'] as String,
    mid: json['_id'] as String,
    date: DateTime.parse(json['create_at']).millisecondsSinceEpoch,
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
      'u_id': instance.uid,
      '_id': instance.mid,
      'title': instance.title,
      'description': instance.description,
      'images': instance.images,
      'video': instance.video,
      'scope': instance.scope,
      'location': instance.location,
    };
