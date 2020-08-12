import 'dart:ui';

class CardInfo {
  int id;
  Color leftColor;
  Color rightColor;
  String cardNumber;
  String cardName;
  String cardCompanyimg;
  String cardCompany;
  String logopng;
  String cardCategory;
  double positionY = 0;
  double rotate = 0;
  double opacity = 0;
  double scale = 0;

  CardInfo({
    this.id,
    this.leftColor,
    this.rightColor,
    this.cardNumber,
    this.cardName,
    this.cardCompanyimg,
    this.cardCompany,
    this.logopng,
    this.cardCategory,
    this.positionY,
    this.rotate,
    this.opacity,
    this.scale,
  });
}

class CreditCardModel {
  String cardNumber = '';
  String expiryYear = "";
  String expiryMonth = "";
  String cardHolderName = '';
  String cvvCode = '';
  String email = '';

  bool isCvvFocused = false;

  CreditCardModel(
      {this.cardNumber,
      this.expiryYear,
      this.expiryMonth,
      this.cardHolderName,
      this.cvvCode,
      this.email});
}
