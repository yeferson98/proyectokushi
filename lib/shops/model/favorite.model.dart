import 'package:json_annotation/json_annotation.dart';
part 'favorite.json.envio.dart';
@JsonSerializable()
class FavoriteResultPost {
  bool error;
  String message;
  int status;

  FavoriteResultPost({this.error,this.message,this.status});

  factory FavoriteResultPost.formJson(Map<String, dynamic> json) =>
      _$FavoriteResultPostFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteResultPostToJson(this);
}