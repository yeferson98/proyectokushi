import 'package:json_annotation/json_annotation.dart';
part 'product.color.json.dart';

@JsonSerializable()
class ProductColorModel {
  int id;
  String idProduct = "";
  String name;
  String codR;
  String codG;
  String codB;
  String selected;
  String image;

  ProductColorModel(
      {this.id,
      this.idProduct,
      this.name,
      this.codR,
      this.codB,
      this.codG,
      this.selected,
      this.image});

  factory ProductColorModel.formJson(Map<String, dynamic> json) =>
      _$ProductColorModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductColorModelToJson(this);
}
