import 'package:json_annotation/json_annotation.dart';
part 'verificode.json.dart';

@JsonSerializable()
class VERIFICODE {
  String num1;
  String num2;
  String num3;
  String num4;
  String num5;
  String num6;
  bool error;
  String message;
  String token;
  int status;

  VERIFICODE({
    this.num1,
    this.num2,
    this.num3,
    this.num4,
    this.num5,
    this.num6,
    this.error,
    this.message,
    this.token,
    this.status,
  });

  factory VERIFICODE.formJson(Map<String, dynamic> json) =>
      _$VERIFICODEFromJson(json);
  Map<String, dynamic> toJson() => _$VERIFICODEToJson(this);
}
