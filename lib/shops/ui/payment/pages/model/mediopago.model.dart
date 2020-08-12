import 'package:json_annotation/json_annotation.dart';
part 'mediopago.json.dart';
@JsonSerializable()
class MedioPago {
  int cod;
  String user;
  String password;
  String token;
  String phone;
  String urlImage;

  MedioPago({this.cod,this.user,this.token, this.password, this.phone, this.urlImage});

  factory MedioPago.formJson(Map<String, dynamic> json) =>
      _$MedioPagoFromJson(json);
  Map<String, dynamic> toJson() => _$MedioPagoToJson(this);
}