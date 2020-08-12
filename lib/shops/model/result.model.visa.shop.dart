import 'package:json_annotation/json_annotation.dart';
part 'result.json.visa.dart';

@JsonSerializable()
class RESULTTARGET {
  String object;
  String type;
  String chargeID;
  String code;
  String declineCode;
  String merchantMessage;
  String userMessage;
  String param;
  int status;

  RESULTTARGET(
      {this.object,
      this.type,
      this.chargeID,
      this.code,
      this.declineCode,
      this.merchantMessage,
      this.userMessage,
      this.param,
      this.status});

  factory RESULTTARGET.formJson(Map<String, dynamic> json) =>
      _$RESULTTARGETFromJson(json);
  Map<String, dynamic> toJson() => _$RESULTTARGETToJson(this);
}
