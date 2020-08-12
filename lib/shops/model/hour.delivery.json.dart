part of 'hour.delivery.model.dart';

HourDeliveryModel _$HourDeliveryModelFromJson(Map<String, dynamic> json) {
  return HourDeliveryModel(
    atencion: json['atencion'] as String,
    fecha: json['fecha'] as String,
  );
}

Map<String, dynamic> _$HourDeliveryModelToJson(HourDeliveryModel instance) =>
    <String, dynamic>{
      'atencion': instance.atencion,
      'fecha': instance.fecha,
    };
