import 'package:culqi_flutter/culqi_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:kushi/bussiness/repository/business.respository.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/CreditCard_model.dart';
import 'package:kushi/shops/ui/payment/pages/model/mediopago.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/shops/ui/payment/pages/payment.message.finish.dart';
import 'package:kushi/shops/ui/payment/widgets/time.delivery.dart';
import 'package:kushi/shops/ui/screens/cartShop.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CreditCardsWidget extends StatefulWidget {
  CardInfo cardInfo;
  UserModel userModel;
  Business business;
  PaymetProductDetail payment;
  MedioPago methodpayment;
  CreditCardsWidget(
      {Key key,
      @required this.cardInfo,
      @required this.userModel,
      @required this.payment,
      @required this.business,
      @required this.methodpayment})
      : super(key: key);

  @override
  _CreditCardsWidgetState createState() => _CreditCardsWidgetState();
}

class _CreditCardsWidgetState extends State<CreditCardsWidget> {
  String cardNumber = "**** **** **** ****";
  String expiryMonth = "00";
  String expiryYear = "00";
  String cardHolderName;
  String cvvCode = "000";
  bool isCvvFocused = false;
  bool isTimeDelivery = false;
  bool butonPayment = false;
  Color themeColor;
  ShopBloc shopBloc;
  bool messagecarga = false;
  String messageProgressRegUser = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyDelivery = GlobalKey<FormState>();
  CreditCardModel creditCardModel;
  Future<List<TimeAttentionBusiness>> timeBusiness;
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryYearController =
      MaskedTextController(mask: '00');
  final TextEditingController _expiryMonthController =
      MaskedTextController(mask: '00');
  final TextEditingController _emailUserController = TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '000');
  final formatDateU = DateFormat("yyyy-MM-dd");
  final formatTime = DateFormat("HH:mm");
  FocusNode cvvFocusNode = FocusNode();
  BusinessRepository _serviceKushiAPI;
  TimedateEnd dateresultDelivery;
  @override
  void initState() {
    _serviceKushiAPI = Ioc.get<BusinessRepository>();
    getTimeBusiness();
    super.initState();
    creditCardModel = CreditCardModel();
  }

  @override
  Widget build(BuildContext context) {
    shopBloc = BlocProvider.of(context);
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 0),
              width: 300,
              height: 195,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    widget.cardInfo.leftColor,
                    widget.cardInfo.rightColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    imageCard(),
                    /* Image.asset(
                      'img/visa.png',
                      height: 22,
                      width: 70,
                    ),*/
                    SizedBox(height: 20),
                    Text(
                      'NUMERO DE TARGETA',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .merge(TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 5),
                    Text(
                      cardNumber,
                      style: Theme.of(context).textTheme.bodyText2.merge(
                          TextStyle(letterSpacing: 1.4, color: Colors.white)),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'VENCE FIN DE',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .merge(TextStyle(color: Colors.white)),
                        ),
                        Text(
                          'CVV',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .merge(TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          expiryMonth + '/' + expiryYear,
                          style: Theme.of(context).textTheme.bodyText2.merge(
                              TextStyle(
                                  letterSpacing: 1.4, color: Colors.white)),
                        ),
                        Text(
                          cvvCode,
                          style: Theme.of(context).textTheme.bodyText2.merge(
                              TextStyle(
                                  letterSpacing: 1.4, color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        FutureBuilder<List<TimeAttentionBusiness>>(
            future: timeBusiness,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Center(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text('Revisa tu conección a internet'),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    getTimeBusiness();
                                  }),
                              Text('Reintentar')
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  if (snapshot.data.length == 0) {
                    butonPayment = false;
                    return Text('empresa sin horario');
                  } else {
                    butonPayment = true;
                    return TimeDelivery(
                      business: widget.business,
                      listHours: snapshot.data,
                      formKey: _formKeyDelivery,
                      onChangedHoursDelivery: (value) {
                        dateresultDelivery = value;
                      },
                    );
                  }
                }
              } else {
                return Text('Prosesando');
              }
            }),
        Theme(
          data: ThemeData(
            textTheme:
                TextTheme(bodyText2: Theme.of(context).textTheme.bodyText2),
            primaryColor: Theme.of(context).accentColor,
            accentIconTheme: IconThemeData(
                color: Theme.of(context).hintColor.withOpacity(0.5)),
            primaryColorDark: Theme.of(context).hintColor.withOpacity(0.5),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: TextFormField(
                      controller: _cardNumberController,
                      cursorColor: Theme.of(context).accentColor,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.credit_card,
                            color:
                                Theme.of(context).hintColor.withOpacity(0.5)),
                        border: OutlineInputBorder(),
                        labelText: 'Número de Trajeta',
                        hintText: 'xxxx xxxx xxxx xxxx',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => creditCardModel.cardNumber = value,
                      onChanged: (String text) {
                        if (text.length < 20) {
                          setState(() {
                            cardNumber = text;
                          });
                        } else {
                          setState(() {
                            cardNumber = cardNumber;
                          });
                        }
                      },
                      validator: _validateNumberTarget),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 9.0),
                  margin: const EdgeInsets.only(left: 10, top: 16, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 120.0,
                        child: TextFormField(
                          controller: _expiryMonthController,
                          cursorColor: Theme.of(context).accentColor,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.date_range,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.5),
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'xx',
                            labelText: 'Mes',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) =>
                              creditCardModel.expiryMonth = value,
                          onChanged: (String text) {
                            if (text.length < 3) {
                              setState(() {
                                expiryMonth = text;
                              });
                            } else {
                              setState(() {
                                expiryMonth = expiryMonth;
                              });
                            }
                          },
                          validator: _validateMonthTarget,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Container(
                        width: 85.0,
                        child: TextFormField(
                          controller: _expiryYearController,
                          cursorColor: Theme.of(context).accentColor,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'xx',
                            labelText: 'Año',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) =>
                              creditCardModel.expiryYear = value,
                          onChanged: (String text) {
                            if (text.length < 3) {
                              setState(() {
                                expiryYear = text;
                              });
                            } else {
                              setState(() {
                                expiryYear = expiryYear;
                              });
                            }
                          },
                          validator: _validateYearTarget,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Container(
                        width: 85.0,
                        child: TextFormField(
                          focusNode: cvvFocusNode,
                          controller: _cvvCodeController,
                          cursorColor: Theme.of(context).accentColor,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) => creditCardModel.cvvCode = value,
                          onChanged: (String text) {
                            if (text.length < 4) {
                              setState(() {
                                cvvCode = text;
                              });
                            } else {
                              setState(() {
                                cvvCode = cvvCode;
                              });
                            }
                          },
                          validator: _validateCVVTarget,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                  child: TextFormField(
                      controller: _emailUserController,
                      cursorColor: Theme.of(context).accentColor,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.email,
                            color:
                                Theme.of(context).hintColor.withOpacity(0.5)),
                        border: OutlineInputBorder(),
                        labelText: 'Correo Electrónico',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => creditCardModel.email = value,
                      validator: _validateEmailTarget),
                ),
                SizedBox(
                  height: 10,
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
                SizedBox(
                  height: 10,
                ),
                SizedBox(height: 10),
                !messagecarga
                    ? Stack(
                        fit: StackFit.loose,
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          SizedBox(
                            width: 320,
                            child: FlatButton(
                              onPressed: () {
                                if (butonPayment == true) {
                                  getStcok();
                                } else {
                                  _showAlertDialogMessage(
                                      'Error empresa sin horario de delivery.');
                                }
                              },
                              padding: EdgeInsets.symmetric(vertical: 14),
                              color: Theme.of(context).accentColor,
                              shape: StadiumBorder(),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Confirmar Pago',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'S/.${widget.payment.total.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          )
                        ],
                      )
                    : Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              messageProgressRegUser,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .merge(TextStyle(fontSize: 16)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }

  /*validaciones del formulario */
  String _validateNumberTarget(String value) {
    if (value.isEmpty) {
      return 'Número de targeta requerido';
    }
    CCard card = CCard(
      cardNumber: value,
    );
    if (!card.isCardNumberValid()) {
      return 'Número de tarjeta no valido';
    }
    return null;
  }

  String _validateMonthTarget(String value) {
    if (value.isEmpty) {
      return '';
    }
    CCard card = CCard(
      expirationMonth: int.parse(value),
    );
    if (!card.isMonthValid()) {
      return '';
    }
    return null;
  }

  String _validateYearTarget(String value) {
    if (value.isEmpty) {
      return '';
    }
    CCard card = CCard(
      expirationYear: int.parse(value),
    );
    if (!card.isYearValid()) {
      return '';
    }
    return null;
  }

  String _validateCVVTarget(String value) {
    if (value.isEmpty) {
      return '';
    }
    CCard card = CCard(
      cvv: value,
    );
    if (!card.isCcvValid()) {
      return '';
    }
    return null;
  }

  String _validateEmailTarget(String value) {
    if (value.isEmpty) {
      return 'El email es requerido';
    }
    CCard card = CCard(
      email: value,
    );
    if (!card.isEmailValid()) {
      return 'Ingrese un email valido';
    }
    return null;
  }

  /* en form validate */
  void getTimeBusiness() {
    timeBusiness = _serviceKushiAPI
        .fetchTimeBusinesRepository(widget.business.uid.toString());
  }

  Widget imageCard() {
    if (widget.cardInfo.cardCompany == "visa") {
      return Container(
        color: Colors.white,
        child: SvgPicture.asset(
          widget.cardInfo.cardCategory,
          height: 22,
          width: 70,
        ),
      );
    } else {
      return SvgPicture.asset(
        widget.cardInfo.cardCategory,
        height: 22,
        width: 70,
      );
    }
  }

  void getStcok() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        messageProgressRegUser = 'Procesando...';
        messagecarga = true;
      });
      List<ProductModel> getproduListInCart = new List<ProductModel>();
      getproduListInCart = Provider.of<InterceptApp>(context).lista();
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
                        Navigator.of(context).pop();
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
                        height: 220.0,
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
              //grabar producto
              validaCard();
            }
          }
        },
      );
    }
  }

  void validaCard() {
    setState(() {
      messageProgressRegUser = 'Verificando targeta de credito..';
      messagecarga = true;
    });
    CCard card = CCard(
      cardNumber: creditCardModel.cardNumber,
      expirationMonth: int.parse(creditCardModel.expiryMonth),
      expirationYear: int.parse(creditCardModel.expiryYear),
      cvv: creditCardModel.cvvCode,
      email: creditCardModel.email,
    );
    switch (card.getBrand()) {
      case CCard.VISA:
        if (widget.cardInfo.cardCompany == "visa") {
          getApiKey(card);
        } else {
          setState(() {
            messageProgressRegUser = '';
            messagecarga = false;
          });
          _showAlertDialogMessage('Profavor ingrese una tagerta MasterCard');
        }
        break;
      case CCard.MASTER_CARD:
        if (widget.cardInfo.cardCompany == "mastercard") {
          getApiKey(card);
        } else {
          setState(() {
            messageProgressRegUser = '';
            messagecarga = false;
          });
          _showAlertDialogMessage('Profavor ingrese una tagerta Visa');
        }
        break;
      default:
        break;
    }
  }

  void getApiKey(CCard card) {
    shopBloc.getApikeyTargetBloc().then((response) {
      if (response.error == true) {
        generateToken(card, response.token);
      } else {
        setState(() {
          messageProgressRegUser = '';
          messagecarga = false;
        });
        _showAlertDialogMessage('Kushi no pudo obtener la llave del servidor');
      }
    });
  }

  void generateToken(CCard card, String apiKey) {
    createToken(card: card, apiKey: apiKey).then(
      (CToken token) {
        guardarCompra(token);
      },
    ).catchError((error) {
      try {
        setState(() {
          messageProgressRegUser = '';
          messagecarga = false;
        });
        _showAlertDialogMessage(
            'Kushi no puede comunicarse con su pasarela de pago');
        print(error);
      } on CulqiBadRequestException catch (ex) {
        setState(() {
          messageProgressRegUser = '';
          messagecarga = false;
        });
        _showAlertDialogMessage(
            'Kushi no puede comunicarse con su pasarela de pago');
        print(ex.cause);
      } on CulqiUnknownException catch (ex) {
        setState(() {
          messageProgressRegUser = '';
          messagecarga = false;
        });
        _showAlertDialogMessage('Error al procesar su targeta ');
        //codigo de error del servidor
        print(ex.cause);
      }
    });
  }

  void guardarCompra(CToken token) {
    List<ProductModel> getproduListInCart = new List<ProductModel>();
    getproduListInCart = Provider.of<InterceptApp>(context).lista();
    setState(() {
      messageProgressRegUser = 'Procesando compra...';
      messagecarga = true;
    });
    widget.userModel.emailTarget = token.email;
    shopBloc
        .saveShopProductTargetBloc(
            widget.methodpayment.cod.toString(),
            '2',
            '1',
            widget.cardInfo.id.toString(),
            widget.business,
            dateresultDelivery,
            widget.userModel,
            widget.payment,
            getproduListInCart,
            token.id)
        .then(
          (value) => {
            if (value.status == null)
              {
                setState(() {
                  messageProgressRegUser = '';
                  messagecarga = false;
                }),
                if (value.userMessage != null)
                  {_showAlertDialogMessage(value.userMessage)}
                else if (value.merchantMessage != null)
                  {
                    _showAlertDialogMessage(
                        'Kushi no pudo procesar su targeta ${widget.cardInfo.cardCompany}')
                  }
                else
                  {
                    _showAlertDialogMessage(
                        'Kushi no pudo procesar su targeta ${widget.cardInfo.cardCompany}')
                  }
              }
            else
              {
                if (value.status == 401 || value.status == 002)
                  {
                    setState(() {
                      messageProgressRegUser = '';
                      messagecarga = false;
                    }),
                    errorSaveProduct()
                  }
                else if (value.status == 200)
                  {
                    setState(() {
                      messageProgressRegUser = '';
                      messagecarga = false;
                    }),
                    saveProductShop()
                  }
              }
          },
        );
  }

  void suceessRemoveProductCart() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        Future<void>.delayed(const Duration(seconds: 2))
          ..then<void>((_) {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CartWidget(
                  supermarkets: widget.business,
                  userData: widget.userModel,
                ),
              ),
            );
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
                  "assets/img/giflStock.gif",
                  height: 150,
                  width: 150,
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

  void saveProductShop() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        Future<void>.delayed(const Duration(seconds: 2))
          ..then<void>((_) {
            Provider.of<InterceptApp>(context).removeAllProductCart();
            removeNotePreference();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext contex) => BlocProvider(
                  child: PaymentSuccessfulWidget(
                      business: widget.business,
                      payment: widget.payment,
                      userModel: widget.userModel,
                      dateresultDelivery: dateresultDelivery),
                  bloc: ShopBloc(),
                ),
              ),
            );
          });
        return Center(
          child: Container(
            width: 250.0,
            height: 210.0,
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
                  'Compra realizada con éxito. \n ' + 'redireccionando...',
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

  void errorSaveProduct() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            'Error al Procesar Compra',
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Aceptar'),
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
            'Sin acceso a internet, revice su conexión',
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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

  void removeNotePreference() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('notePaymentUser');
  }
}
