import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order.detail.product.json.dart';

@JsonSerializable()
class OrderDetailProduct {
  String id = UniqueKey().toString();
  int idprod;
  String idProduct = "";
  String quantity;
  String price;
  String descAll;
  String nameProduct;
  String descCorta;
  String urlimage;
  String brandDescription;
  int idBrand;

  OrderDetailProduct(
      {this.idprod,
      this.idProduct,
      this.quantity,
      this.price,
      this.descAll,
      this.nameProduct,
      this.descCorta,
      this.urlimage,
      this.brandDescription,
      this.idBrand});

  factory OrderDetailProduct.formJson(Map<String, dynamic> json) =>
      _$OrderDetailProductFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailProductToJson(this);
}
