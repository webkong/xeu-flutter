import 'package:json_annotation/json_annotation.dart';

part 'memorabilia.g.dart';

@JsonSerializable()
class Memorabilia {
  Memorabilia({this.date, this.title, this.description, this.images, this.video = '', this.scope = const [], this.location = ''});
  num date;
  String title;
  String description;
  List images;
  String video;
  List scope;
  String location;
  factory Memorabilia.fromJson(Map<String, dynamic> json) => _$MemorabiliaFromJson(json);
  Map<String, dynamic> toJson() => _$MemorabiliaToJson(this);
}
