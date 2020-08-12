part of 'verify.code.dart';

VERIFICODE _$VERIFICODEFromJson(Map<String, dynamic> json) {
  return VERIFICODE(
     error: json['error'] as bool,
      message:  json['message'] as String,
      token:  json['token'] as String,
      status:  json['status'] as int);
}

Map<String, dynamic> _$VERIFICODEToJson(VERIFICODE instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'token': instance.token,
      'status': instance.status,
    };
