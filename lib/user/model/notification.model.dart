import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'notification.json.dart';

@JsonSerializable()
class NotificationModel {
  dynamic keyDocument;
  int id;
  String name;
  String description;
  String date;
  int typeNotification;
  String iconNotification;
  String bussines;
  String sound;
  String image;
  String click;
  int view;
  int viewItem;
  int idBusiness;
  int codData;

  NotificationModel(
      {this.id,
      this.name,
      this.description,
      this.date,
      this.typeNotification,
      this.iconNotification,
      this.bussines,
      this.image,
      this.click,
      this.sound,
      this.view,
      this.viewItem,
      this.idBusiness,
      this.codData});

  factory NotificationModel.formJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel.fomSnapshot(DocumentSnapshot snapshot)
      : keyDocument = snapshot.documentID,
        name = snapshot['titulo'],
        description = snapshot['cuerpo'],
        date = snapshot['fecha'],
        typeNotification = snapshot['redireccion'],
        iconNotification = snapshot['icono'],
        bussines = snapshot['subtitulo'],
        image = snapshot['imagen'],
        view = snapshot['leido'],
        viewItem = snapshot['leido_detalle'],
        idBusiness = snapshot['Emp_Codigo'],
        click = snapshot['click_action'],
        sound = snapshot['sound'],
        codData = snapshot['dato'];
}
