part of 'time.attention.model.dart';

TimeAttentionBusiness _$TimeAttentionBusinessFromJson(Map<String, dynamic> json) {
  return TimeAttentionBusiness(
      uid: json['Eho_Item'] as int,
      timeCode: json['Eho_DiaCod'] as String,
      description: json['Tt_Descripcion'] as String,
      hourInit: json['Eho_HoraIni'] as String,
      hourDelivery: json['Emp_HoraDelivery'] as String,
      hourEnd: json['Eho_HoraFin'] as String,);
}

Map<String, dynamic> _$TimeAttentionBusinessToJson(TimeAttentionBusiness instance) => <String, dynamic>{
      'Eho_Item': instance.uid,
      'Eho_DiaCod': instance.timeCode,
      'Tt_Descripcion': instance.description,
      'Eho_HoraIni': instance.hourInit,
      'Emp_HoraDelivery':instance.hourDelivery,
      'Eho_HoraFin': instance.hourEnd
    };
