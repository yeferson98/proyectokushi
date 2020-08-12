part of 'promotions.model.dart';

PromotionsModel _$PromotionsModelFromJson(Map<String, dynamic> json) {
  return PromotionsModel(
      id: json['Pim_Codigo'] as int,
      name:json['Pim_Descripcion'],
      image: json['Pim_Imagen'] as String,
      dateInit: json['Pim_FechaIni'] as String,
      dateEnd: json['Pim_FechaFin'] as String,);
}

Map<String, dynamic> _$PromotionsModelToJson(PromotionsModel instance) =>
    <String, dynamic>{
      'Pim_Codigo': instance.id,
      'Pim_Descripcion':instance.name,
      'Pim_Imagen': instance.image,
      'Pim_FechaIni': instance.dateInit,
      'Pim_FechaFin': instance.dateEnd
    };
