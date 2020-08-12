part of 'address.client.model.dart';

AddressClient _$AddressClientFromJson(Map<String, dynamic> json) {
  return AddressClient(
    id: json['Cdi_Codigo'] as int,
    idClient: json['Cli_Codigo'] as int,
    predeterminada: json['Cdi_Predeterminada'] as String,
    nameAdrres: json['Cdi_Titulo'] as String,
    address: json['Cdi_Direccion'] as String,
    addressAdd: json['Cdi_DireAdicional'] as String,
    reference: json['Cdi_Referencial'] as String,
    latitud: json['Cdi_Y'] as String,
    longitud: json['Cdi_X'] as String,
    codCountry: json['Pais_Codigo'] as int,
  );
}

Map<String, dynamic> _$AddressClientToJson(AddressClient instance) =>
    <String, dynamic>{
      'Cdi_Codigo': instance.id,
      'Cli_Codigo': instance.idClient,
      'Cdi_Predeterminada': instance.predeterminada,
      'Cdi_Titulo': instance.nameAdrres,
      'Cdi_Direccion': instance.address,
      'Cdi_DireAdicional': instance.addressAdd,
      'Cdi_Referencial': instance.reference,
      'Cdi_Y': instance.latitud,
      'Cdi_X': instance.longitud,
      'Pais_Codigo': instance.codCountry,
    };
