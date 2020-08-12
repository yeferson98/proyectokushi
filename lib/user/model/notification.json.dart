part of 'notification.model.dart';

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
      name: json['titulo'] as String,
      description: json['cuerpo'] as String,
      date: json['fecha'] as String,
      typeNotification: json['redireccion'] as int,
      iconNotification: json['icono'] as String,
      bussines: json['subtitulo'] as String,
      image: json['imagen'] as String,
      click: json['click_action'] as String,
      sound: json['sound'] as String,
      view: json['leido'] as int,
      idBusiness: json['Emp_Codigo'] as int,
      codData: json['dato'] as int);
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'titulo': instance.name,
      'cuerpo': instance.description,
      'fecha': instance.date,
      'redireccion': instance.typeNotification,
      'icono': instance.iconNotification,
      'subtitulo': instance.bussines,
      'imagen': instance.image,
      'click_action': instance.click,
      'sound': instance.sound,
      'leido': instance.view,
      'leido_detalle': instance.viewItem,
      'Emp_Codigo': instance.idBusiness,
      'dato': instance.codData
    };
