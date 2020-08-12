import 'package:json_annotation/json_annotation.dart';
part 'address.client.json.dart';

@JsonSerializable()
class AddressClient {
  int id;
  String predeterminada;
  String nameAdrres;
  String address;
  String addressAdd;
  String reference;
  String longitud;
  String latitud;
  int codCountry;
  int idClient;
  String descriptionDis;
  String descriptionProv;
  String descriptionDepa;


  AddressClient({
    this.id,
    this.predeterminada,
    this.nameAdrres,
    this.address,
    this.addressAdd,
    this.reference,
    this.latitud,
    this.longitud,
    this.codCountry,
    this.idClient,
    this.descriptionDis,
    this.descriptionProv,
    this.descriptionDepa
  });

  factory AddressClient.formJson(Map<String, dynamic> json) =>
      _$AddressClientFromJson(json);
  Map<String, dynamic> toJson() => _$AddressClientToJson(this);
}
