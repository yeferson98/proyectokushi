import 'package:json_annotation/json_annotation.dart';
part 'category.json.dart';

@JsonSerializable()
class CategoryModel {
  int uid;
  String name;
  String selected;
  String icon;
  String fontFamily;
  CategoryModel({
    this.uid,
    this.name,
    this.selected,
    this.icon,
    this.fontFamily,
  });

  factory CategoryModel.formJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
