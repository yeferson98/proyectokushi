import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/utils/utils.route.images.dart';

class PaymentOptions {
  String description, photo;
  int typePayment;
  String name;

  PaymentOptions({this.name, this.description, this.photo, this.typePayment});
}

class DataDetailPayment {
  PaymentOptions paymentOptions;
  UserModel userModel;
  Business business;
  double costoProducto;
  double costoEnvio;
  double descuento;
  double total;
  DataDetailPayment(
      {this.paymentOptions,
      this.userModel,
      this.business,
      this.costoProducto,
      this.costoEnvio,
      this.descuento,
      this.total});
}

List<PaymentOptions> paymentItems = [
  PaymentOptions(
    name: 'Efectivo',
    description: "",
    photo: AppImagesKushi.efectivo,
    typePayment: 5,
  ),
  PaymentOptions(
    name: 'POS',
    description: "",
    photo: AppImagesKushi.pago_POS,
    typePayment: 6,
  ),
  PaymentOptions(
    name: 'Tarjeta',
    description: "",
    photo: AppImagesKushi.targeta,
    typePayment: 7,
  ),
];
