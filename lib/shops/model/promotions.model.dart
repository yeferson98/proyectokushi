import 'package:json_annotation/json_annotation.dart';
part 'promotions.json.dart';
@JsonSerializable()
class PromotionsModel {
  int id;
  String name;
  String image;
  String dateInit;
  String dateEnd;

  PromotionsModel(
      {this.id,
      this.name,
      this.image,
      this.dateInit,
      this.dateEnd});

  factory PromotionsModel.formJson(Map<String, dynamic> json) =>
      _$PromotionsModelFromJson(json);
  Map<String, dynamic> toJson() => _$PromotionsModelToJson(this);
}
