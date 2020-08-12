import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';  
part 'product.json.dart';

@JsonSerializable()
class ProductModel {
  String id = UniqueKey().toString();
  int idprod;
  String name;
  String desciptionOne;
  String descriptionTwo;
  String imageList;
  String imageDetail;
  String price;
  String money;
  String isoDinner;
  String priceTash;
  String size;
  int unidMed;
  String uniMedDesc;
  String stock;
  String brandDescription;
  int isfavorite;
  int ismultiColors;
  int quantity;
  int idBrand;
  int idCategory;
  int idBusiness;
  String idCol;/*color */
  String codR;
  String codG;
  String codB;/*fin color */
  int idSize;/*tallas */
  String nameSize;/*tallas fin */
  String catidadSize;
  ProductModel({
    this.idprod,
    this.name,
    this.desciptionOne,
    this.descriptionTwo,
    this.imageList,
    this.imageDetail,
    this.price,
    this.money,
    this.isoDinner,
    this.priceTash,
    this.size,
    this.unidMed,
    this.uniMedDesc,
    this.stock,
    this.brandDescription,
    this.isfavorite,
    this.ismultiColors,
    this.quantity,
    this.idBrand,
    this.idCategory,
    this.idBusiness,
    this.idCol,
    this.codR,
    this.codB,
    this.codG,
  });

  factory ProductModel.formJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
