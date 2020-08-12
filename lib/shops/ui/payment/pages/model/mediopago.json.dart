part of 'mediopago.model.dart';

MedioPago _$MedioPagoFromJson(Map<String, dynamic> json) {
  return MedioPago(
      cod: json['ETar_Codigo'] as int,
      user: json['Etar_UsuarioMP'] as String,
      password: json['Etar_PassMP'] as String,
      token: json['Etar_TokenMP'] as String,
      phone: json['Etar_NumTelef'] as String,
      urlImage: json['Etar_Imagen']as String);
}

Map<String, dynamic> _$MedioPagoToJson(MedioPago instance) =>
    <String, dynamic>{
      'ETar_Codigo': instance.cod,
      'Etar_UsuarioMP': instance.user,
      'Etar_PassMP': instance.password,
      'Etar_TokenMP': instance.token,
      'Etar_NumTelef': instance.phone,
      'Etar_Imagen': instance.urlImage
    };
