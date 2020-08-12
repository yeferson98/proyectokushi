part of 'cities.model.dart';

Cities _$CitiesFromJson(Map<String, dynamic> json) {
  return Cities(
     uid: json['Ciu_Codigo'] as int,
      name:  json['Ciu_Descripcion'] as String,);
}

Map<String, dynamic> _$CitiesToJson(Cities instance) =>
    <String, dynamic>{
      'Ciu_Codigo': instance.uid,
      'Ciu_Descripcion': instance.name,
    };
