import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:kushi/bussiness/repository/business.respository.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/CreditCard_model.dart';
import 'package:kushi/shops/ui/payment/pages/model/mediopago.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/shops/ui/payment/pages/payment.message.finish.dart';
import 'package:kushi/shops/ui/payment/widgets/card.payment.y.p.dart';
import 'package:kushi/shops/ui/payment/widgets/time.delivery.dart';
import 'package:kushi/shops/ui/widgets/ShoppingCartButtonWidget.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MethodPaymentYP extends StatefulWidget {
  UserModel userModel;
  Business business;
  PaymetProductDetail payment;
  CardInfo cardInfo;
  MedioPago methodpayment;
  MethodPaymentYP(
      {Key key,
      @required this.userModel,
      @required this.payment,
      @required this.business,
      @required this.cardInfo,
      @required this.methodpayment});
  @override
  _MethodPaymentYPState createState() => _MethodPaymentYPState();
}

class _MethodPaymentYPState extends State<MethodPaymentYP> {
  bool isTimeDelivery = false;
  bool butonPayment = false;
  GlobalKey<FormState> _formKeyDelivery = GlobalKey<FormState>();
  ShopBloc shopBloc;
  BusinessRepository _serviceKushiAPI;
  Future<List<TimeAttentionBusiness>> timeBusiness;
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '000 000 000');
  final formatDateU = DateFormat("yyyy-MM-dd");
  final formatTime = DateFormat("HH:mm");
  TimedateEnd dateresultDelivery;
  @override
  void initState() {
    if (widget.methodpayment.phone == null) {
      _cardNumberController.text = "000 000 000";
    } else {
      _cardNumberController.text = widget.methodpayment.phone;
    }

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
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Caja Online',
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
                    //Navigator.of(context).pushNamed('/Tabs', arguments: 1);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    UiIcons.credit_card,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    'Paga con ' + widget.cardInfo.cardCompanyimg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  subtitle: Text(
                    'Escanea su codigo ' + widget.cardInfo.cardCompanyimg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              SizedBox(height: 20),
              CardItemPaymentYP(
                cardInfo: widget.cardInfo,
                methodpayment: widget.methodpayment,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Image.asset(
                    widget.cardInfo.logopng,
                    height: 50,
                  ),
                  title: Text(
                    _cardNumberController.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  subtitle: Text(
                    'O paga al numero asociado',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
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
              Stack(
                fit: StackFit.loose,
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  SizedBox(
                    width: 320,
                    child: FlatButton(
                      onPressed: () {
                        //grabar producto
                        questionAlert();
                      },
                      padding: EdgeInsets.symmetric(vertical: 14),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Confirmar Pago',
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'S/.${widget.payment.total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headline4.merge(
                          TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  )
                ],
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
                    'Si',
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

  void questionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '¡Advertencia!',
            textAlign: TextAlign.center,
          ),
          content: Text('¿Esta seguro que desea confirmar esta compra?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'No',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            FlatButton(
              onPressed: () {
                if (butonPayment == true) {
                  List<ProductModel> getproduListInCart =
                      new List<ProductModel>();
                  getproduListInCart =
                      Provider.of<InterceptApp>(context).lista();
                  getproduListInCart =
                      Provider.of<InterceptApp>(context).lista();
                  Navigator.pop(context);
                  shopBloc
                      .saveShopProductBloc(
                          widget.methodpayment.cod.toString(),
                          '3',
                          '3',
                          widget.cardInfo.id.toString(),
                          widget.business,
                          dateresultDelivery,
                          widget.userModel,
                          widget.payment,
                          getproduListInCart)
                      .then(
                        (value) => {
                          if (value.status == null)
                            {errorSaveProduct()}
                          else
                            {
                              if (value.status == 401 ||
                                  value.status == 002 ||
                                  value.status == 500 ||
                                  value.status == 422 ||
                                  value.status == 403)
                                {errorSaveProduct()}
                              else if (value.status == 200)
                                {saveProductShop()}
                              else if (value.error == true)
                                {errorSaveProduct()}
                            }
                        },
                      );
                } else {
                  _showAlertDialogMessage(
                      'Error empresa sin horario de delivery.');
                }
              },
              child: Text(
                'Si',
                style: Theme.of(context).textTheme.bodyText2,
              ),
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

  getTimeBusiness() {
    timeBusiness = _serviceKushiAPI
        .fetchTimeBusinesRepository(widget.business.uid.toString());
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
