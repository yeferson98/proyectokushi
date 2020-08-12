import 'package:json_annotation/json_annotation.dart';
part 'sms.json.envio.dart';
@JsonSerializable()
class SMSENVIO {
  String number;
  bool error;
  String message;
  int status;
  int smsCode;

  SMSENVIO({this.number,this.error,this.message,this.status,this.smsCode});

  factory SMSENVIO.formJson(Map<String, dynamic> json) =>
      _$SMSENVIOFromJson(json);
  Map<String, dynamic> toJson() => _$SMSENVIOToJson(this);
}