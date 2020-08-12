import 'package:json_annotation/json_annotation.dart';
part 'order.payment.json.dart';

@JsonSerializable()
class OrderPaymentModel {
  int codPayment;
  int numberPayment;
  String dateOperation;
  String hourOperation;
  String paymentAll;
  String dateDelivery;
  String hourDelivery;
  String methodPayment;
  String statusPayment;
  String businessRS;
  String descriptionPayment;
  int codBusiness;
  String mobileBusiness;
  String phoneBusiness;
  int codAddress;
  String descriptionAddress;
  String typePayment;

  OrderPaymentModel(
      {this.codPayment,
      this.numberPayment,
      this.dateOperation,
      this.hourOperation,
      this.paymentAll,
      this.dateDelivery,
      this.hourDelivery,
      this.methodPayment,
      this.statusPayment,
      this.businessRS,
      this.descriptionPayment,
      this.codBusiness,
      this.mobileBusiness,
      this.phoneBusiness,
      this.codAddress,
      this.descriptionAddress,
      this.typePayment});

  factory OrderPaymentModel.formJson(Map<String, dynamic> json) =>
      _$OrderPaymentModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderPaymentModelToJson(this);
}
