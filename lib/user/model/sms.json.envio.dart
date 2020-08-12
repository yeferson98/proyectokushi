part of 'smsEnvio.dart';

SMSENVIO _$SMSENVIOFromJson(Map<String, dynamic> json) {
  return SMSENVIO(
     error: json['error'] as bool,
      message:  json['message'] as String,
      status:  json['status'] as int,
      smsCode:  json['sms_code'] as int);
}

Map<String, dynamic> _$SMSENVIOToJson(SMSENVIO instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'status': instance.status,
      'sms_code': instance.status
    };
