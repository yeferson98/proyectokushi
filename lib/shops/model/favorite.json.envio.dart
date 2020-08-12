part of 'favorite.model.dart';

FavoriteResultPost _$FavoriteResultPostFromJson(Map<String, dynamic> json) {
  return FavoriteResultPost(
      error: json['error'] as bool,
      message: json['message'] as String,
      status: json['status'] as int);
}

Map<String, dynamic> _$FavoriteResultPostToJson(FavoriteResultPost instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'status': instance.status,
    };
