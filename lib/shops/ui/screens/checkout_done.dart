import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:kushi/bussiness/repository/business.respository.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/shops/ui/payment/pages/payment.message.finish.dart';
import 'package:kushi/shops/ui/payment/widgets/time.delivery.dart';
import 'package:provider/provider.dart';
import 'package:kushi/configs/app_config.dart' as config;
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/ui/widgets/ShoppingCartButtonWidget.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CheckoutDoneWidget extends StatefulWidget {
  UserModel userModel;
  PaymetProductDetail payment;
  String titleView;
  Business business;
  CheckoutDoneWidget(
      {Key key,
      @required this.userModel,
      @required this.payment,
      @required this.business,
      @required this.titleView});
  @override
  _CheckoutDoneWidgetState createState() => _CheckoutDoneWidgetState();
}

class _CheckoutDoneWidgetState extends State<CheckoutDoneWidget> {
  bool confirmpaymet = false;
  ShopBloc shopBloc;
  bool statebutton = true;
  bool butonPayment = false;
  TimedateEnd dateresultDelivery;
  Future<List<TimeAttentionBusiness>> timeBusiness;
  GlobalKey<FormState> _formKeyDelivery = GlobalKey<FormState>();
  BusinessRepository _serviceKushiAPI;
  @override
  void initState() {
    _serviceKushiAPI = Ioc.get<BusinessRepository>();
    getTimeBusiness();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    shopBloc = BlocProvider.of(context);
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(UiIcons.return_icon,
                color: Theme.of(context).hintColor),
            onPressed: () async {
              SharedPreferences _preferences =
                  await SharedPreferences.getInstance();
              Provider.of<InterceptApp>(context).descRemoveDouble();
              _preferences.remove('cupon');
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.titleView,
            style: Theme.of(context).textTheme.headline3,
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                supermarkets: widget.business,
                userData: widget.userModel,
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor),
            Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(300),
                  onTap: () {
                    // Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.userModel.urlImage),
                  ),
                )),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              FutureBuilder<List<TimeAttentionBusiness>>(
                future: timeBusiness,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return Center(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Text('Revisa tu conexión a internet'),
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
                    return Text('Procesando...');
                  }
                },
              ),
              Container(
                alignment: AlignmentDirectional.center,
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: config.App(context).appHeight(60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Theme.of(context).accentColor,
                                    !confirmpaymet
                                        ? Colors.orangeAccent
                                        : Colors.greenAccent,
                                    Theme.of(context)
                                        .accentColor
                                        .withOpacity(0.2),
                                  ])),
                          child: Icon(
                            confirmpaymet ? Icons.check : Icons.warning,
                            color: Theme.of(context).primaryColor,
                            size: 70,
                          ),
                        ),
                        Positioned(
                          right: -30,
                          bottom: -50,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(150),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -20,
                          top: -50,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(150),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Column(
                      children: <Widget>[
                        Text(
                          !confirmpaymet
                              ? widget.userModel.name +
                                  ', ¿Estas seguro que deseas hacer este pago?'
                              : 'Hecho, pago realizado exitosamente',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Text(
                          !confirmpaymet
                              ? 'Monto a pagar: ' +
                                  'S/.' +
                                  widget.payment.total.toStringAsFixed(2)
                              : 'Monto pagado:' +
                                  ' S/.' +
                                  widget.payment.total.toStringAsFixed(2),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    statebutton
                        ? FlatButton(
                            onPressed: () {
                              if (!confirmpaymet) {
                                if (butonPayment == true) {
                                  getStcok();
                                } else {
                                  _showAlertDialogMessage(
                                      'Error empresa sin horario de delivery.');
                                }
                              } else {
                                //Navigator.of(context).pushNamed('/Orders');
                              }
                            },
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 30),
                            color:
                                Theme.of(context).focusColor.withOpacity(0.15),
                            shape: StadiumBorder(),
                            child: Text(
                              !confirmpaymet ? 'Confirmar' : 'Ver mis ordenes',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          )
                        : Image.asset(
                            'assets/img/loaderStock.gif',
                            width: 150,
                            height: 150,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Salir'),
              content: Text('¿Esta seguro que desea salir de la aplicación?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                FlatButton(
                  onPressed: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                  child: Text(
                    'Yes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  getTimeBusiness() {
    timeBusiness = _serviceKushiAPI
        .fetchTimeBusinesRepository(widget.business.uid.toString());
  }

  void getStcok() {
    List<ProductModel> getproduListInCart = new List<ProductModel>();
    getproduListInCart = Provider.of<InterceptApp>(context).lista();
    setState(() => statebutton = false);
    shopBloc.getStockExistBloc(getproduListInCart).then(
      (value) {
        if (value == null) {
          print('error producto no existe');
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
            getproduListInCart = Provider.of<InterceptApp>(context).lista();
            shopBloc
                .saveShopProductBloc(
                    '',
                    '1',
                    '4',
                    widget.payment.typeOptionPayment.toString(),
                    widget.business,
                    dateresultDelivery,
                    widget.userModel,
                    widget.payment,
                    getproduListInCart)
                .then(
                  (value) => {
                    if (value.status == null)
                      {
                        setState(() {
                          statebutton = false;
                          confirmpaymet = false;
                        }),
                        errorSaveProduct()
                      }
                    else
                      {
                        if (value.status == 401 ||
                            value.status == 002 ||
                            value.status == 500 ||
                            value.status == 422 ||
                            value.status == 403)
                          {
                            setState(() {
                              statebutton = false;
                              confirmpaymet = false;
                            }),
                            errorSaveProduct()
                          }
                        else if (value.status == 200)
                          {saveProductShop()}
                        else if (value.error == true)
                          {
                            setState(() {
                              statebutton = false;
                              confirmpaymet = false;
                            }),
                            errorSaveProduct()
                          }
                      }
                  },
                );
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
            Navigator.of(context).pop();
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
          ..then<void>(
            (_) {
              Provider.of<InterceptApp>(context).removeAllProductCart();
              setState(() {
                confirmpaymet = false;
              });
              setState(() => statebutton = true);
              removeNotePreference();
              Navigator.pop(context);
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
            },
          );
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
    setState(() {
      confirmpaymet = false;
      statebutton = true;
    });
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
