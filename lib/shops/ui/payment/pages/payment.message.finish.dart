import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/configs/app_config.dart' as config;
import 'package:kushi/shops/ui/screens/shop.List.Prod.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PaymentSuccessfulWidget extends StatefulWidget {
  UserModel userModel;
  PaymetProductDetail payment;
  Business business;
  TimedateEnd dateresultDelivery;
  PaymentSuccessfulWidget(
      {Key key,
      @required this.userModel,
      @required this.payment,
      @required this.business,
      @required this.dateresultDelivery});
  @override
  _PaymentSuccessfulWidgetState createState() =>
      _PaymentSuccessfulWidgetState();
}

class _PaymentSuccessfulWidgetState extends State<PaymentSuccessfulWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKeyPaymentFinish =
      GlobalKey<ScaffoldState>();
  DateFormat formatDateUP = DateFormat("yyyy-MM-dd");
  bool confirmpaymet = false;
  ShopBloc shopBloc;
  bool statebutton = true;
  String horaresult = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    horaresult = formatDate(formatDateUP.parse(widget.dateresultDelivery.fecha),
        [dd, '/', mm, '/', yyyy]);
    shopBloc = BlocProvider.of(context);
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKeyPaymentFinish,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Detalle de compra',
            style: Theme.of(context).textTheme.headline2,
          ),
          actions: <Widget>[
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: AppBarNotificatios(
                user: widget.userModel,
                scaffoldKey: _scaffoldKeyPaymentFinish,
              ),
            ),
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
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.center,
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: config.App(context).appHeight(60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: AlignmentDirectional.center,
                      child: Image.asset(
                          'assets/images/image_successful_payment.png'),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          'Muchas  gracias por su compra, estamos procesando su pedido en \n ${widget.business.name}, entrega aproximada: ${widget.dateresultDelivery.hora}, ${horaresult.toString()}, por el monto de S/.${widget.payment.total.toStringAsFixed(2)}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext contex) => BlocProvider(
                        child: ShopsProduct(
                          supermarkets: widget.business,
                          userData: widget.userModel,
                        ),
                        bloc: ShopBloc(),
                      ),
                    ),
                  );
                },
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                color: Theme.of(context).focusColor.withOpacity(0.15),
                shape: StadiumBorder(),
                child: Text(
                  'Aceptar',
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
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

  void removeNotePreference() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('notePaymentUser');
  }
}
