import 'package:json_annotation/json_annotation.dart';
part 'response.costo.json.envio.dart';
@JsonSerializable()
class RESPONSECOSTOMODEL {
  bool error;
  String message;
  double valueCupon;
  int status;
  String errorCode;

  RESPONSECOSTOMODEL({this.error,this.message,this.status,this.errorCode, this.valueCupon});

  factory RESPONSECOSTOMODEL.formJson(Map<String, dynamic> json) =>
      _$RESPONSECOSTOMODELFromJson(json);
  Map<String, dynamic> toJson() => _$RESPONSECOSTOMODELToJson(this);
}