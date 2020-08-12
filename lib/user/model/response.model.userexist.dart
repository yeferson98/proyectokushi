import 'package:json_annotation/json_annotation.dart';
part 'response.json.userexist.dart';
@JsonSerializable()
class MessageUserExist {
  bool error;
  String message;
  int status;
  bool register;

  MessageUserExist({this.error,this.message,this.status,this.register});

  factory MessageUserExist.formJson(Map<String, dynamic> json) =>
      _$MessageUserExistFromJson(json);
  Map<String, dynamic> toJson() => _$MessageUserExistToJson(this);
}