import 'package:json_annotation/json_annotation.dart';
part 'product.size.json.dart';

@JsonSerializable()
class ProductSizeModel {
  int id;
  String idProduct="";
  String name;
  String selected="";
  String cantStock;

  ProductSizeModel({this.id,this.idProduct,this.name, this.selected, this.cantStock});

  factory ProductSizeModel.formJson(Map<String, dynamic> json) =>
      _$ProductSizeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSizeModelToJson(this);
}
