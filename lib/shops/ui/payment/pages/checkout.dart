import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/ui/payment/pages/card_slider.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CheckoutWidget extends StatefulWidget {
  UserModel userModel;
  Business business;
  PaymetProductDetail payment;
  CheckoutWidget(
      {Key key,
      @required this.userModel,
      @required this.payment,
      @required this.business});
  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKeyCajaOnline =
      GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKeyCajaOnline,
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
            'Caja Online',
            style: Theme.of(context).textTheme.headline3,
          ),
          actions: <Widget>[
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: AppBarNotificatios(
                user: widget.userModel,
                scaffoldKey: _scaffoldKeyCajaOnline,
              ),
            ),
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
                    'Metos de pago',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  subtitle: Text(
                    'Seleccione su metodo de pago',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: screenHeight * 0.6,
                  child: CardSlider(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    user: widget.userModel,
                    business: widget.business,
                    payment: widget.payment,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'KUSHI APP',
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: 20),
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
}
