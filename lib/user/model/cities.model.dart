import 'package:json_annotation/json_annotation.dart';
part 'cities.json.dart';

@JsonSerializable()
class Cities {
  int uid;
  String name;

  Cities({
    this.uid,
    this.name,
  });

  factory Cities.formJson(Map<String, dynamic> json) =>
      _$CitiesFromJson(json);
  Map<String, dynamic> toJson() => _$CitiesToJson(this);
}
