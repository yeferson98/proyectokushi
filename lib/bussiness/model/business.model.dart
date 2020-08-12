import 'package:json_annotation/json_annotation.dart';
part 'business.json.dart';

@JsonSerializable()
class Business {
  int uid;
  String name;
  String phone;
  String address;
  String image;
  int idRub;
  String descRubr;
  int idcity;
  String descCity;
  int idDistri;
  String desDistr;
  String cantMinPayment;
  String horaDelivery;
  String horaAtencion;
  String horaCierre;
  Business({
    this.uid,
    this.name,
    this.phone,
    this.address,
    this.image,
    this.idRub,
    this.descRubr,
    this.idcity,
    this.descCity,
    this.idDistri,
    this.desDistr,
    this.cantMinPayment,
    this.horaDelivery,
    this.horaAtencion,
    this.horaCierre
  });

  factory Business.formJson(Map<String, dynamic> json) =>
      _$BusinessFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessToJson(this);
}
