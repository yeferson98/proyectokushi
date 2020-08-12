part of 'result.model.visa.shop.dart';

RESULTTARGET _$RESULTTARGETFromJson(Map<String, dynamic> json) {
  return RESULTTARGET(
      object: json['object'] as String,
      type: json['type'] as String,
      chargeID: json['charge_id'] as String,
      code: json['code'] as String,
      declineCode: json['decline_code'] as String,
      merchantMessage: json['merchant_message'] as String,
      userMessage: json['user_message'] as String,
      param: json['param'] as String);
}

Map<String, dynamic> _$RESULTTARGETToJson(RESULTTARGET instance) =>
    <String, dynamic>{
      'object': instance.object,
      'type': instance.type,
      'charge_id': instance.chargeID,
      'code': instance.code,
      'decline_code': instance.declineCode,
      'merchant_message': instance.merchantMessage,
      'user_message': instance.userMessage,
      'param': instance.param,
    };
