import 'package:json_annotation/json_annotation.dart';
part 'hour.delivery.json.dart';

@JsonSerializable()
class HourDeliveryModel {
  String atencion;
  String fecha;
  int status;

  HourDeliveryModel({this.atencion, this.fecha, this.status});

  factory HourDeliveryModel.formJson(Map<String, dynamic> json) =>
      _$HourDeliveryModelFromJson(json);
  Map<String, dynamic> toJson() => _$HourDeliveryModelToJson(this);
}
