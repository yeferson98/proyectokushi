part of 'category.model.dart';

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return CategoryModel(
      uid: json['Grup_Codigo'] as int,
      name: json['Grup_Desc'] as String,
      selected: json['Cat_Seleccion']
          as String, // agrega  este campo en la tabla categorias y enviamelo como false, el primer item que se llame todos como nombre de categoria  con valor true como Cat_ select
      icon: json['Cat_Url_Icon'] as String,
      fontFamily: json['Cat_Tipo_Dx'] as String);
}

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'Grup_Codigo': instance.uid,
      'Grup_Desc': instance.name,
      'Cat_Seleccion': instance.selected,
      'Cat_Url_Icon': instance.icon,
    };
