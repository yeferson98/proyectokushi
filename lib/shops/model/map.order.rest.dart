import 'package:kushi/shops/model/order.payment.model.dart';

class OrdersPaymentProduct {
  List<OrderPaymentModel> pendiente;
  List<OrderPaymentModel> proceso;
  List<OrderPaymentModel> finalizado;
  int code;

  OrdersPaymentProduct(
      {this.pendiente, this.proceso, this.finalizado, this.code});

  factory OrdersPaymentProduct.fromJson(Map<String, dynamic> parsedJson) {
    List<OrderPaymentModel> mapListpendiente;
    List<OrderPaymentModel> mapListproceso;
    List<OrderPaymentModel> mapListfinalizado;
    if (parsedJson == null) {
      mapListpendiente = [];
      mapListproceso = [];
      mapListfinalizado = [];
    } else {
      var pendiente = parsedJson['1'] as List;
      var proceso = parsedJson['2'] as List;
      var finalizado = parsedJson['3'] as List;
      if (pendiente == null) {
        mapListpendiente = [];
      } else {
        mapListpendiente =
            pendiente.map((i) => OrderPaymentModel.formJson(i)).toList();
      }
      if (proceso == null) {
        mapListproceso = [];
      } else {
        mapListproceso =
            proceso.map((i) => OrderPaymentModel.formJson(i)).toList();
      }
      if (finalizado == null) {
        mapListfinalizado = [];
      } else {
        mapListfinalizado =
            finalizado.map((i) => OrderPaymentModel.formJson(i)).toList();
      }
    }

    return OrdersPaymentProduct(
        pendiente: mapListpendiente,
        proceso: mapListproceso,
        finalizado: mapListfinalizado);
  }
}
