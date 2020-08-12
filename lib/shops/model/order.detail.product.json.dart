part of 'order.detail.product.model.dart';
OrderDetailProduct _$OrderDetailProductFromJson(Map<String, dynamic> json) {
  return OrderDetailProduct(
      idprod: json['Prod_Codigo'] as int,
      quantity: json['Dco_Cantidad'] as String,
      price:json['Dco_Precio'] as String,
      descAll: json['Dco_Totaldet'] as String,
      nameProduct: json['Prod_Nombre'] as String,
      descCorta: json['Prod_Desc_Corta'] as String,
      urlimage: json['Prod_Imagen_Lista'] as String,
      brandDescription: json['Mar_Descri'] as String,
      idBrand: json['Cod_Marca'] as int,
      );
}

Map<String, dynamic> _$OrderDetailProductToJson(OrderDetailProduct instance) =>
    <String, dynamic>{
      'Prod_Codigo': instance.idprod,
      'Dco_Cantidad': instance.quantity,
      'Dco_Precio':instance.price,
      'Dco_Totaldet': instance.descAll,
      'Prod_Nombre': instance.nameProduct,
      'Prod_Desc_Corta': instance.descCorta,
      'Prod_Imagen_Lista': instance.urlimage,
      'Mar_Descri': instance.urlimage,
      'Cod_Marca': instance.idBrand
    };