import 'package:json_annotation/json_annotation.dart';
part 'time.attention.json.dart';

@JsonSerializable()
class TimeAttentionBusiness {
  int uid;
  String timeCode;
  String description;
  String hourInit;
  String hourEnd;
  String hourDelivery;
  String statusCode;
  TimeAttentionBusiness(
      {this.uid,
      this.timeCode,
      this.description,
      this.hourInit,
      this.hourEnd,
      this.hourDelivery,
      this.statusCode});

  factory TimeAttentionBusiness.formJson(Map<String, dynamic> json) =>
      _$TimeAttentionBusinessFromJson(json);
  Map<String, dynamic> toJson() => _$TimeAttentionBusinessToJson(this);
}

class Timedate {
  DateTime hora;
  DateTime fecha;
  Timedate(
      {this.hora,
      this.fecha});
}

class TimedateEnd {
  String hora;
  String fecha;
  TimedateEnd(
      {this.hora,
      this.fecha});
}
