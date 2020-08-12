import 'dart:ui';

import 'package:kushi/shops/ui/payment/pages/model/CreditCard_model.dart';

List<CardInfo> cardData = [
  CardInfo(
      id:1 ,
      cardName: "Confirmar",
      cardNumber: "**** *** **** **** ",
      cardCompanyimg: "Visa.",
      cardCompany:'visa',
      leftColor: Color.fromRGBO(0, 65, 146, 1.0),
      rightColor: Color.fromRGBO(0, 65, 146, 1.0),
      cardCategory: "assets/cardImage/visa.svg",
      logopng: ""),
  CardInfo(
      id:2,
      cardName: "Confirmar",
      cardNumber: "**** *** **** ****",
      cardCompanyimg: "MasterCard.",
      cardCompany:'mastercard',
      leftColor: Color.fromRGBO(234, 94, 96, 1.0),
      rightColor: Color.fromRGBO(244, 63, 92, 1.0),
      cardCategory: "assets/cardImage/mastercard.svg",
      logopng: ""),
  CardInfo(
      id:3,
      cardName: "Confirmar",
      cardNumber: "Yapea ya",
      cardCompanyimg:"Yape.",
      cardCompany:'yape',
      leftColor: Color.fromRGBO(125, 31, 157, 1.0),
      rightColor: Color.fromRGBO(125, 31, 157, 1.0),
      cardCategory: "",
      logopng: "assets/img/logoyape.png"),
  CardInfo(
      id:4,
      cardName: "Confimar",
      cardNumber: "Paga con plin",
      cardCompany: "plin",
      cardCompanyimg:"Plin.",
      leftColor: Color.fromRGBO(1, 153, 233, 1.0),
      rightColor: Color.fromRGBO(0, 161, 161, 1.0),
      cardCategory: "",
      logopng: "assets/img/logoplin.png"),
];
