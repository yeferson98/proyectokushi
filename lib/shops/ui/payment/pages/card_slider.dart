import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/ui/payment/pages/checkout_Card.dart';
import 'package:kushi/shops/ui/payment/pages/method_payment.y.p.dart';
import 'dart:math';
import 'package:kushi/shops/ui/payment/pages/model/CreditCard_model.dart';
import 'package:kushi/shops/ui/payment/pages/data/CreditCard_data.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/shops/ui/payment/widgets/card_text.dart';
import 'package:kushi/shops/ui/screens/cartShop.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:provider/provider.dart';

class CardSlider extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final UserModel user;
  final Business business;
  final PaymetProductDetail payment;
  const CardSlider(
      {Key key,
      this.screenHeight,
      this.screenWidth,
      @required this.user,
      @required this.business,
      @required this.payment})
      : super(key: key);

  @override
  _CardSliderState createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  double positionYLine1;
  double positionYLine2;
  double _middleAreaheight;
  double _outsideCardInterval;
  double scrollOffsetY;
  ShopBloc shopBloc;
  @override
  void initState() {
    super.initState();
    positionYLine1 = 50;
    positionYLine2 = positionYLine1 + 200;

    _outsideCardInterval = 30.0;
    _middleAreaheight = positionYLine2 - positionYLine1;
    scrollOffsetY = 0;

    for (var i = 0; i < cardData.length; i++) {
      CardInfo cardInfo = cardData[i];
      if (i == 0) {
        cardInfo.positionY = positionYLine1;
        cardInfo.opacity = 1.0;
        cardInfo.scale = 1.0;
        cardInfo.rotate = 1.0;
      } else {
        cardInfo.positionY = positionYLine2 + (i - 1) * 30;
        cardInfo.opacity = 0.7 - (i - 1) * 0.1;
        cardInfo.scale = 0.9;
        cardInfo.rotate = -60;
      }
    }

    cardData = cardData.reversed.toList();
  }

  _updateCardPosition(double offsetY) {
    void updatePosition(
        CardInfo cardInfo, double firstCardAtAreaIdx, int cardIndex) {
      double currentCardAtAreaIdx = firstCardAtAreaIdx + cardIndex;
      if (currentCardAtAreaIdx < 0) {
        cardInfo.positionY =
            positionYLine1 + currentCardAtAreaIdx * _outsideCardInterval;

        cardInfo.rotate =
            -90 / _outsideCardInterval * (positionYLine1 - cardInfo.positionY);

        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;

        if (cardInfo.rotate < -90.0) cardInfo.rotate = -90.0;

        cardInfo.scale = 1.0 -
            0.2 / _outsideCardInterval * (positionYLine1 - cardInfo.positionY);

        if (cardInfo.scale < 0.8) cardInfo.scale = 0.8;

        if (cardInfo.scale > 1.0) cardInfo.scale = 1.0;

        cardInfo.opacity = 1.0 -
            0.7 / _outsideCardInterval * (positionYLine1 - cardInfo.positionY);

        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;

        if (cardInfo.opacity > 1.0) cardInfo.opacity = 1.0;
      } else if (currentCardAtAreaIdx >= 0 && currentCardAtAreaIdx < 1) {
        cardInfo.positionY =
            positionYLine1 + currentCardAtAreaIdx * _middleAreaheight;

        cardInfo.rotate = -60 /
            (positionYLine2 - positionYLine1) *
            (cardInfo.positionY - positionYLine1);

        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;

        if (cardInfo.rotate < -60.0) cardInfo.rotate = -60.0;

        cardInfo.scale = 1.0 -
            0.1 /
                (positionYLine2 - positionYLine1) *
                (cardInfo.positionY - positionYLine1);

        if (cardInfo.scale < 0.9) cardInfo.scale = 0.9;

        if (cardInfo.scale > 1.0) cardInfo.scale = 1.0;

        cardInfo.opacity = 1.0 -
            0.3 /
                (positionYLine2 - positionYLine1) *
                (cardInfo.positionY - positionYLine1);

        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;

        if (cardInfo.opacity > 1.0) cardInfo.opacity = 1.0;
      } else if (currentCardAtAreaIdx > 1) {
        cardInfo.positionY =
            positionYLine2 + (currentCardAtAreaIdx - 1) * _outsideCardInterval;

        cardInfo.rotate = -60.0;

        cardInfo.scale = 0.9;

        cardInfo.opacity = 0.7 - cardIndex * 0.1;
      }
    }

    scrollOffsetY += offsetY;

    double firstCardAtAreaIdx = scrollOffsetY / _middleAreaheight;

    for (var i = 0; i < cardData.length; i++) {
      CardInfo cardInfo = cardData[cardData.length - 1 - i];
      updatePosition(cardInfo, firstCardAtAreaIdx, i);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final double screenWidth = MediaQuery.of(context).size.width;
    shopBloc = BlocProvider.of(context);
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails d) {
        _updateCardPosition(d.delta.dy);
      },
      onVerticalDragEnd: (DragEndDetails d) {
        scrollOffsetY =
            (scrollOffsetY / _middleAreaheight).round() * _middleAreaheight;
        _updateCardPosition(0);
      },
      child: Container(
        width: screenWidth,
        //height: size.height * .2,
        child: valuecardOrientation(),
      ),
    );
  }

  Widget valuecardOrientation() {
    final size = MediaQuery.of(context).size;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    if (size.width > 500) {
      return Row(
        children: <Widget>[
          Container(
            width: 300,
            height: double.infinity,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      UiIcons.file,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      'Detalle de Pago',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    subtitle: Text(
                      'revise su monto a pagar',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Costo del producto:',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Costo del envio:',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Descuento:',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Total:',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'S/.${widget.payment.costoProd.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'S/.${widget.payment.costoEnv.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'S/.${widget.payment.descuento.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'S/.${widget.payment.total.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                //lista de targetas
                ...buildCards(screenWidth * .6, screenHeight * 1.9, context,
                    widget.payment, widget.user, widget.business, shopBloc),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: screenHeight * 0.15,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(0, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          //lista de targetas
          ...buildCards(screenWidth, screenHeight, context, widget.payment,
              widget.user, widget.business, shopBloc),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(0, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                    ]),
              ),
            ),
          ),
        ],
      );
    }
  }
}

List buildCards(
    double screenWidth,
    double screenHeight,
    BuildContext context,
    PaymetProductDetail payment,
    UserModel user,
    Business business,
    ShopBloc shopBloc) {
  List widgetList = [];
  void error() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            'Este medio de pago no esta disponible, pruebe con otro medio de pago.',
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Aceptar',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void errorinternet() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            'Sin acceso a internet, revise su conexión.',
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Aceptar',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//============================redirecciona al carrito removiendo la lista de productos en el provider =============================================////
  void suceessRemoveProductCart() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        Future<void>.delayed(const Duration(seconds: 2))
          ..then<void>((_) {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CartWidget(
                  supermarkets: business,
                  userData: user,
                ),
              ),
            );
          });
        return Center(
          child: Container(
            width: 250.0,
            height: 200.0,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/img/gifproducts.gif",
                  height: 100,
                  width: 100,
                ),
                Text(
                  "Termidado. redireccionando al carrito...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: 15),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //============================fin=============================================////
  //============================Cosulta stock y redirecciona segun criterio, yape y plin=============================================////
  void getStcok(CardInfo cardInfoSt) {
    List<ProductModel> getproduListInCart = new List<ProductModel>();
    getproduListInCart = Provider.of<InterceptApp>(context).lista();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        Future<void>.delayed(const Duration(seconds: 2))
          ..then<void>((_) {
            shopBloc.getStockExistBloc(getproduListInCart).then(
              (value) {
                if (value == null) {
                  errorinternet();
                } else {
                  if (value.length > 0) {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) {
                          Future<void>.delayed(const Duration(seconds: 2))
                            ..then<void>((_) {
                              Navigator.pop(context);
                              Provider.of<InterceptApp>(context)
                                  .removeProductStockSop(value)
                                  .then((value) {
                                if (value == true) {
                                  suceessRemoveProductCart();
                                }
                              });
                            });
                          return Center(
                            child: Container(
                              width: 250.0,
                              height: 230.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/img/loaderStock.gif",
                                    height: 100,
                                    width: 100,
                                  ),
                                  Text(
                                    "Removiendo algunos productos del carrito, ya que  el stock se agoto",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    if (cardInfoSt.id == 3) {
                      shopBloc
                          .queryMethodPaymentRepository(
                              cardInfoSt.id.toString(), business)
                          .then((data) {
                        if (data.cod == 404) {
                          error();
                        } else if (data.cod == 500) {
                          error();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => BlocProvider(
                                child: MethodPaymentYP(
                                    userModel: user,
                                    payment: payment,
                                    business: business,
                                    cardInfo: cardInfoSt,
                                    methodpayment: data),
                                bloc: ShopBloc(),
                              ),
                            ),
                          );
                        }
                      });
                    } else if (cardInfoSt.id == 4) {
                      shopBloc
                          .queryMethodPaymentRepository(
                              cardInfoSt.id.toString(), business)
                          .then((data) {
                        if (data.cod == 404) {
                          error();
                        } else if (data.cod == 500) {
                          error();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => BlocProvider(
                                child: MethodPaymentYP(
                                  userModel: user,
                                  payment: payment,
                                  business: business,
                                  cardInfo: cardInfoSt,
                                  methodpayment: data,
                                ),
                                bloc: ShopBloc(),
                              ),
                            ),
                          );
                        }
                      });
                    }
                  }
                }
              },
            );
            Navigator.pop(context);
          });
        return Center(
          child: Container(
            width: 250.0,
            height: 200.0,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/img/gifproducts.gif",
                  height: 100,
                  width: 100,
                ),
                Text(
                  "Preparando metodo de pago...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: 15),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //============================fin de funcion=============================================////
  //============================Verfica payment order, yape y plin=============================================////
  void _showAlertDialogMessage(String message) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Aceptar',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void verifyShopPayment(CardInfo cardInfo) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        Future<void>.delayed(const Duration(seconds: 2))
          ..then<void>((_) {
            shopBloc
                .verifyShopPaymetBloc(
                    user.idCliente.toString(), business.uid.toString())
                .then((value) {
              if (value == 404 || value == 500) {
                Navigator.pop(context);
                _showAlertDialogMessage(
                    'Ocurrio un error al habilitar este metodo de pago');
              } else if (value == 1) {
                Navigator.pop(context);
                _showAlertDialogMessage(
                    'Usted cuenta con una compra pendiente de pago, \n no se permite tener dos compras en el mismo estado.');
              } else if (value == 0) {
                Navigator.pop(context);
                getStcok(cardInfo);
              }
            });
          });
        return Center(
          child: Container(
            width: 250.0,
            height: 160.0,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/img/gifproducts.gif",
                  height: 100,
                  width: 100,
                ),
                Text(
                  "Preparando ${cardInfo.cardCompany}...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: 15),
                )
              ],
            ),
          ),
        );
      },
    );
  }

//============================Carrucel de targetas=============================================////
  for (CardInfo cardInfo in cardData) {
    widgetList.add(
      Positioned(
        top: cardInfo.positionY,
        child: Container(
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(pi / 180 * cardInfo.rotate)
              ..scale(cardInfo.scale),
            alignment: Alignment.topCenter,
            child: Opacity(
              opacity: cardInfo.opacity,
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: screenHeight * 0.015,
                        offset: Offset(5, 10),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(screenHeight * 0.015),
                    color: Colors.red,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        cardInfo.leftColor,
                        cardInfo.rightColor,
                      ],
                    ),
                  ),
                  width: screenWidth * 0.75,
                  height: screenHeight * 0.225,
                  child: Stack(
                    children: <Widget>[
                      //Card Company
                      Positioned(
                        left: screenWidth * 0.025,
                        top: screenHeight * 0.005,
                        child: Container(
                          width: screenHeight * 3.120,
                          height: screenHeight * 0.075,
                          child: Text(
                            cardInfo.cardCompanyimg,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: screenHeight * 0.12,
                        left: screenWidth * 0.05,
                        child: InkWell(
                          child: Text(
                            'Monto a pagar S/.${payment.total.toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //Card Number
                      cardText(
                          screenHeight * 0.05,
                          screenWidth * 0.05,
                          Colors.white,
                          FontWeight.w500,
                          cardInfo.cardNumber,
                          screenHeight * 0.08),
                      //Card name
                      cardText(
                          screenHeight * 0.02,
                          screenWidth * 0.05,
                          Colors.white,
                          FontWeight.w600,
                          cardInfo.cardName,
                          screenHeight * 0.1),
                      //Card logo
                      Positioned(
                        right: screenWidth * 0.025,
                        bottom: screenHeight * 0.005,
                        child: Container(
                          width: screenHeight * 0.075,
                          height: screenHeight * 0.075,
                          child: cardInfo.cardCategory.isNotEmpty
                              ? SvgPicture.asset(cardInfo.cardCategory)
                              : Image.asset(cardInfo.logopng),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (cardInfo.cardCompany == "visa") {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        Future<void>.delayed(const Duration(seconds: 2))
                          ..then<void>((_) {
                            shopBloc
                                .queryMethodPaymentRepository(
                                    cardInfo.id.toString(), business)
                                .then((data) {
                              if (data.cod == 404) {
                                error();
                              } else if (data.cod == 500) {
                                error();
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlocProvider(
                                      child: CheckoutCardWidget(
                                          userModel: user,
                                          payment: payment,
                                          business: business,
                                          cardInfo: cardInfo,
                                          methodpayment: data),
                                      bloc: ShopBloc(),
                                    ),
                                  ),
                                );
                              }
                            });
                            Navigator.pop(context);
                          });
                        return Center(
                          child: Container(
                            width: 250.0,
                            height: 200.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/img/gifproducts.gif",
                                  height: 100,
                                  width: 100,
                                ),
                                Text(
                                  "Preparando metodo de pago...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (cardInfo.cardCompany == "mastercard") {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        Future<void>.delayed(const Duration(seconds: 2))
                          ..then<void>((_) {
                            shopBloc
                                .queryMethodPaymentRepository(
                                    cardInfo.id.toString(), business)
                                .then((data) {
                              if (data.cod == 404) {
                                error();
                              } else if (data.cod == 500) {
                                error();
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BlocProvider(
                                      child: CheckoutCardWidget(
                                          userModel: user,
                                          payment: payment,
                                          business: business,
                                          cardInfo: cardInfo,
                                          methodpayment: data),
                                      bloc: ShopBloc(),
                                    ),
                                  ),
                                );
                              }
                            });
                            Navigator.pop(context);
                          });
                        return Center(
                          child: Container(
                            width: 250.0,
                            height: 200.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/img/gifproducts.gif",
                                  height: 100,
                                  width: 100,
                                ),
                                Text(
                                  "Preparando metodo de pago...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (cardInfo.cardCompany == "yape") {
                    verifyShopPayment(cardInfo);
                  } else if (cardInfo.cardCompany == "plin") {
                    verifyShopPayment(cardInfo);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  //============================fin de carrucel=============================================////

  return widgetList;
}
