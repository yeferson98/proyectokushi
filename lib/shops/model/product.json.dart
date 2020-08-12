part of 'product.model.dart';

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return ProductModel(
      idprod: json['Prod_Codigo'] as int,
      name:json['Prod_Nombre'],
      desciptionOne: json['Prod_Desc_Corta'] as String,
      descriptionTwo: json['Prod_Desc_Larga'] as String,
      imageList: json['Prod_Imagen_Lista'] as String,
      imageDetail: json['Prod_Imagen_Detalle'] as String,
      price: json['Prod_Precio'] as String,
      money: json['Tmon_Simbolo'] as String,
      isoDinner: json['Tmon_ISO'] as String,
      priceTash: json['Prod_PrecioTach'] as String,
      size: json['Prod_Tamaño'] as String,
      unidMed: json['Umed_Codigo'] as int,
      uniMedDesc: json['Umed_Descripcion'] as String,
      stock: json['Prod_Stock'] as String,
      brandDescription: json['Mar_Descri'] as String,
      isfavorite: json['Es_Favorito'] as int,
      ismultiColors: json['Es_Multicolor'] as int,
      quantity: json['Prod_cantidad_Ayuda'] as int,// agrega este campo a la base de datos  lo necesito para el conteo de la cantidad individual  de los productos
      idBrand: json['Cod_Marca'] as int,
      idCategory: json['Cod_Categoria'] as int,
      idBusiness: json['Cod_Empresa'] as int);
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'Prod_Codigo': instance.idprod,
      'Prod_Nombre':instance.name,
      'Prod_Desc_Corta': instance.desciptionOne,
      'Prod_Desc_Larga': instance.descriptionTwo,
      'Prod_Imagen_Lista': instance.imageList,
      'Prod_Imagen_Detalle': instance.imageDetail,
      'Prod_Precio': instance.price,
      'Tmon_Simbolo': instance.money,
      'Tmon_ISO': instance.isoDinner,
      'Prod_PrecioTach': instance.priceTash,
      'Prod_Tamaño': instance.size,
      'Umed_Codigo': instance.unidMed,
      'Umed_Descripcion': instance.uniMedDesc,
      'Prod_Stock': instance.stock,
      'Mar_Descri': instance.brandDescription,
      'Es_Favorito': instance.isfavorite,
      'Es_Multicolor': instance.ismultiColors,
      'Prod_cantidad_Ayuda': instance.quantity,
      'Cod_Marca': instance.idBrand,
      'Cod_Categoria': instance.idCategory,
      'Cod_Empresa': instance.idBusiness
    };
