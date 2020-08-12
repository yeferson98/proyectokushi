part of 'post.json.cost.env.dart';

GetProductEnStock _$GetProductEnStockFromJson(Map<String, dynamic> json) {
  return GetProductEnStock(
      codProduct: json['Cod_Prod'] as String,
      codColor:json['Pco_Codigo'] as int,
      codTalla: json['Tpr_Codigo'] as int,
      disponible: json['Disponible'] as String,
      );
}

Map<String, dynamic> _$GetProductEnStockToJson(GetProductEnStock instance) =>
    <String, dynamic>{
      'Cod_Prod': instance.codProduct,
      'Pco_Codigo':instance.codColor,
      'Tpr_Codigo': instance.codTalla,
      'Disponible': instance.disponible,
    };
