part of 'response.model.costo.dart';

RESPONSECOSTOMODEL _$RESPONSECOSTOMODELFromJson(Map<String, dynamic> json) {
  return RESPONSECOSTOMODEL(
      error: json['error'] as bool,
      message:  json['message'] as String,
      status:  json['status'] as int,
      errorCode:  json['error_code'] as String);
}

Map<String, dynamic> _$RESPONSECOSTOMODELToJson(RESPONSECOSTOMODEL instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'status': instance.status,
      'error_code': instance.errorCode
    };
