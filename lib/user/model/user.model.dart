import 'package:json_annotation/json_annotation.dart';
part 'user.json.dart';

@JsonSerializable()
class UserModel {
  int id;
  int idCliente;
  String phone;
  String name;
  String lastname;
  String email;
  String emailTarget;
  String urlImage;
  String ciudad;
  int idPais;
  int idAdrres = 0;
  String descriptionNote;

  UserModel(
      {this.id,
      this.idCliente,
      this.phone,
      this.name,
      this.lastname,
      this.email,
      this.emailTarget,
      this.urlImage,
      this.ciudad,
      this.idPais});

  factory UserModel.formJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

class AddressSeach {
  String address;
  AddressSeach({this.address});
}
