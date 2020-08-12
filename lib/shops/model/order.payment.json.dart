part of 'order.payment.model.dart';

OrderPaymentModel _$OrderPaymentModelFromJson(Map<String, dynamic> json) {
  return OrderPaymentModel(
    codPayment: json['Com_Codigo'] as int,
    numberPayment: json['Com_NumCom_Emp'] as int,
    dateOperation: json['Fecha_Operacion'] as String,
    hourOperation: json['Hora_Operacion'] as String,
    paymentAll: json['Com_Total'] as String,
    dateDelivery: json['Com_Fecha_Atencion'] as String,
    hourDelivery: json['Com_Hora_Atencion'] as String,
    methodPayment: json['Com_FromaPago'] as String,
    statusPayment: json['Com_Estado'] as String,
    businessRS: json['Emp_RazonSocial'] as String,
    descriptionPayment: json['Tt_Descripcion'] as String,
    codBusiness: json['Emp_Codigo'] as int,
    mobileBusiness: json['Emp_Celular'] as String,
    phoneBusiness: json['Emp_Telefono'] as String,
    codAddress: json['Cdi_Codigo'] as int,
    descriptionAddress: json['Cdi_Direccion'] as String,
    typePayment: json['Tipo_Pago'] as String,
  );
}

Map<String, dynamic> _$OrderPaymentModelToJson(OrderPaymentModel instance) =>
    <String, dynamic>{
      'Com_Codigo': instance.codPayment,
      'Com_NumCom_Emp': instance.numberPayment,
      'Fecha_Operacion': instance.dateOperation,
      'Hora_Operacion': instance.hourOperation,
      'Com_Total': instance.paymentAll,
      'Com_Fecha_Atencion': instance.dateDelivery,
      'Com_Hora_Atencion': instance.hourDelivery,
      'Com_FromaPago': instance.methodPayment,
      'Con_Estado': instance.statusPayment,
      'Emp_RazonSocial': instance.businessRS,
      'Tt_Descripcion': instance.descriptionPayment,
      'Emp_Codigo': instance.codBusiness,
      'Emp_Celular': instance.mobileBusiness,
      'Emp_Telefono': instance.phoneBusiness,
      'Cdi_Codigo': instance.codAddress,
      'Cdi_Direccion': instance.descriptionAddress,
      'Tipo_Pago': instance.typePayment
    };
