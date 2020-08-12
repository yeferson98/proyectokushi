part of 'response.model.userexist.dart';

MessageUserExist _$MessageUserExistFromJson(Map<String, dynamic> json) {
  return MessageUserExist(
      error: json['error'] as bool,
      message:  json['message'] as String,
      status:  json['status'] as int,
      register:  json['registered'] as bool);
}

Map<String, dynamic> _$MessageUserExistToJson(MessageUserExist instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'status': instance.status,
      'registered': instance.register
    };
