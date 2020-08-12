import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/ui/payment/pages/model/CreditCard_model.dart';
import 'package:kushi/shops/ui/payment/pages/model/mediopago.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/shops/ui/payment/widgets/CreditCardsWidget.dart';
import 'package:kushi/shops/ui/widgets/ShoppingCartButtonWidget.dart';
import 'package:kushi/user/model/user.model.dart';

// ignore: must_be_immutable
class CheckoutCardWidget extends StatefulWidget {
  UserModel userModel;
  Business business;
  PaymetProductDetail payment;
  CardInfo cardInfo;
  MedioPago methodpayment;
  CheckoutCardWidget(
      {Key key,
      @required this.userModel,
      @required this.payment,
      @required this.business,
      @required this.cardInfo,
      @required this.methodpayment});
  @override
  _CheckoutCardWidgetState createState() => _CheckoutCardWidgetState();
}

class _CheckoutCardWidgetState extends State<CheckoutCardWidget> {
  @override
  Widget build(BuildContext context) {
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
            'Pago En linea',
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
                    'Targeta ' + widget.cardInfo.cardCompanyimg,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  subtitle: Text(
                    'Llene todos los campos',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              SizedBox(height: 20),
              CreditCardsWidget(
                cardInfo: widget.cardInfo,
                business: widget.business,
                userModel: widget.userModel,
                payment: widget.payment,
                methodpayment: widget.methodpayment,
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
}
