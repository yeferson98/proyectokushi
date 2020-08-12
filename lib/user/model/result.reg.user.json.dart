
part of 'result.reg.user.model.dart';

ResultRegUser _$ResultRegUserFromJson(Map<String, dynamic> json) {
  return ResultRegUser(
     error: json['error'] as bool,
      message:  json['message'] as String,
      token:  json['token'] as String,
      tokenType:  json['token_type'] as String,
      expireToken:  json['expires_in'] as int,
      status:  json['status'] as int);
}

Map<String, dynamic> _$ResultRegUserToJson(ResultRegUser instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'token': instance.token,
      'token_type': instance.tokenType,
      'expires_in': instance.expireToken,
      'status': instance.status
    };
