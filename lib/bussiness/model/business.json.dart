part of 'business.model.dart';

Business _$BusinessFromJson(Map<String, dynamic> json) {
  return Business(
      uid: json['Emp_Codigo'] as int,
      name: json['Emp_RazonSocial'] as String,
      phone: json['Emp_Celular'] as String,
      address: json['Emp_Direccion'] as String,
      image: json['Emp_FotoPrin'] as String,
      cantMinPayment: json['Emp_CompraMinima'] as String,
      idRub: json['Rub_Codigo'] as int,
      descRubr: json['Rub_Desc'] as String,
      idcity: json['Ciu_Codigo'] as int,
      descCity: json['Ciu_Descripcion'] as String,
      idDistri: json['Dist_cod'] as int,
      desDistr: json['Dist_Desc'] as String,
      horaDelivery: json['Emp_HoraDelivery'] as String);
}

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
      'Emp_Codigo': instance.uid,
      'Emp_RazonSocial': instance.name,
      'Emp_Celular': instance.phone,
      'Emp_Direccion': instance.address,
      'Emp_FotoPrin': instance.image,
      'Emp_CompraMinima': instance.cantMinPayment,
      'Rub_Codigo': instance.idRub,
      'Rub_Desc': instance.descRubr,
      'Ciu_Codigo': instance.idcity,
      'Ciu_Descripcion': instance.descCity,
      'Dist_cod': instance.idDistri,
      'Dist_Desc': instance.desDistr,
      'Emp_HoraDelivery': instance.horaDelivery,
    };
