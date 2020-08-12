import 'package:flutter/cupertino.dart';

class PaymetProductDetail {
  String desCupon;
  double costoProd;
  double costoEnv;
  double descuento;
  double total;
  int typeOptionPayment;
  PaymetProductDetail(
      {@required this.desCupon,
      @required this.costoProd,
      @required this.costoEnv,
      @required this.descuento,
      @required this.total,
      @required this.typeOptionPayment});
  // ignore: non_constant_identifier_names
  Map<String, dynamic> TojsonData() {
    var map = new Map<String, dynamic>();
    map["Desc_Cupon"] = desCupon;
    map["Cost_Prod"] = costoProd;
    map["Cost_Env"] = costoEnv;
    map["Descuento"] = descuento;
    map["total"] = total;
    return map;
  }
}
