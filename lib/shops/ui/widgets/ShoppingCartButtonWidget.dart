import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/ui/screens/cartShop.dart';
import 'package:kushi/user/model/user.model.dart';

class ShoppingCartButtonWidget extends StatelessWidget {
  const ShoppingCartButtonWidget({
    this.iconColor,
    this.labelColor,
    this.labelCount = 0,
    this.supermarkets,
    this.userData,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;
  final int labelCount;
  final UserModel userData;
  final Business supermarkets;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Provider.of<InterceptApp>(context).costRemoveDouble();
        Provider.of<InterceptApp>(context).descRemoveDouble();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext contex) => CartWidget(
                supermarkets: this.supermarkets,
                userData: this.userData,
              ),
            ));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              UiIcons.shopping_cart,
              color: this.iconColor,
              size: 28,
            ),
          ),
          Consumer<InterceptApp>(
              builder: (context, InterceptApp value, Widget child) {
            return Container(
              child: Text(
                value.lista().length.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption.merge(
                      TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 9),
                    ),
              ),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  color: this.labelColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              constraints: BoxConstraints(
                  minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
            );
          }),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
