part of 'product.size.model.dart';

ProductSizeModel _$ProductSizeModelFromJson(Map<String, dynamic> json) {
  return ProductSizeModel(
      id: json['Tpr_Codigo'] as int,
      name:json['Tpr_Descripcion'] as String,
      selected: json['Tpr_Seleccion'] as String,// enviamelo una cadena vacíare
      cantStock: json['Cot_Cantidad'] as String
      );
}

Map<String, dynamic> _$ProductSizeModelToJson(ProductSizeModel instance) =>
    <String, dynamic>{
      'Tpr_Codigo': instance.id,
      'Tpr_Descripcion':instance.name,
      'Tpr_Seleccion': instance.selected,
      'Cot_Cantidad': instance.cantStock
    };
