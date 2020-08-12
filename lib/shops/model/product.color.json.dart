part of 'product.color.model.dart';

ProductColorModel _$ProductColorModelFromJson(Map<String, dynamic> json) {
  return ProductColorModel(
      id: json['Pco_Codigo'] as int,
      name: json['Pco_Descripcion'] as String,
      codR: json['Pco_CodR'] as String,
      codG: json['Pco_CodG'] as String,
      codB: json['Pco_CodB'] as String,
      selected: json['Pco_Seleccion'] as String, // enviamelo con valor vacio
      image: json['Cot_ImagenColor'] as String);
}

Map<String, dynamic> _$ProductColorModelToJson(ProductColorModel instance) =>
    <String, dynamic>{
      'Pco_Codigo': instance.id,
      'Pco_Descripcion': instance.name,
      'Pco_CodR': instance.codR,
      'Pco_CodG': instance.codG,
      'Pco_CodB': instance.codB,
      'Pco_Seleccion': instance.selected,
      'Cot_ImagenColor': instance.image
    };
