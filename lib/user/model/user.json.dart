part of 'user.model.dart';

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
      id: json['Usu_Codigo'] as int,
      idCliente: json['Cli_Codigo'] as int,
      phone: json['Usu_Celular'] as String,
      name: json['Usu_Nom'] as String,
      lastname: json['Usu_Ape'] as String,
      email: json['Usu_Email'] as String,
      urlImage: json['Usu_foto'] as String,
      ciudad: json['Ciu_Descripcion'] as String,
      idPais: json['Pais_Codigo'] as int);
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'Usu_Codigo': instance.id,
      'Cli_Codigo': instance.idCliente,
      'Usu_Celular': instance.phone,
      'Usu_Nom': instance.name,
      'Usu_Ape': instance.lastname,
      'Usu_Email': instance.email,
      'Usu_foto': instance.urlImage,
      'Ciu_Descripcion': instance.ciudad,
      'Pais_Codigo': instance.idPais
    };
