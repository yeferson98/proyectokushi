import 'package:json_annotation/json_annotation.dart';
part 'result.reg.user.json.dart';
@JsonSerializable()
class ResultRegUser {
  bool error;
  String message;
  String token;
  String tokenType;
  int expireToken;
  int status;

  ResultRegUser({this.error,this.message,this.token,this.tokenType,this.expireToken,this.status});

  factory ResultRegUser.formJson(Map<String, dynamic> json) =>
      _$ResultRegUserFromJson(json);
  Map<String, dynamic> toJson() => _$ResultRegUserToJson(this);
}