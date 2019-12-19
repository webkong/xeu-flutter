import 'package:json_annotation/json_annotation.dart';

part 'memorabilia.g.dart';

@JsonSerializable()
class Memorabilia {
  Memorabilia({this.date, this.title, this.description, this.photo, this.tag, this.isExpanded = false});
  num date;
  String title;
  String description;
  String photo;
  String tag;
  bool isExpanded;
  factory Memorabilia.fromJson(Map<String, dynamic> json) => _$MemorabiliaFromJson(json);
  Map<String, dynamic> toJson() => _$MemorabiliaToJson(this);
}
