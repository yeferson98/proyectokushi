import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/order.payment.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/screens/detail.order.dart';

// ignore: must_be_immutable
class OrderListItemWidget extends StatefulWidget {
  String heroTag;
  OrderPaymentModel order;
  VoidCallback onDismissed;
  int typeOrder;
  UserModel user;
  Business business;
  int stateNavigator = 0;
  OrderListItemWidget(
      {Key key,
      this.heroTag,
      this.order,
      this.onDismissed,
      this.typeOrder,
      @required this.user,
      @required this.business,
      @required this.stateNavigator})
      : super(key: key);

  @override
  _OrderListItemWidgetState createState() => _OrderListItemWidgetState();
}

class _OrderListItemWidgetState extends State<OrderListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        routeDetail(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
                tag: widget.heroTag + widget.order.codPayment.toString(),
                child: imgOrder()),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.order.businessRS,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .merge(TextStyle(fontSize: 13)),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.shopping_cart,
                              color: Theme.of(context).focusColor,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Nro. Orden:' +
                                  ' ' +
                                  widget.order.numberPayment.toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 10,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  UiIcons.calendar,
                                  color: Theme.of(context).focusColor,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Fecha Entr. :' +
                                      ' ' +
                                      widget.order.dateDelivery,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.timer,
                                  color: Theme.of(context).focusColor,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Hora Entrega:' +
                                      ' ' +
                                      widget.order.hourDelivery,
                                  style: Theme.of(context).textTheme.bodyText1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ],
                            ),
                          ],
//                            crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          'S/.' +
                              double.parse(widget.order.paymentAll)
                                  .toStringAsFixed(2),
                          style: Theme.of(context).textTheme.headline1),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget imgOrder() {
    if (widget.typeOrder == 1) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
              image: AssetImage('assets/img/pendiente.png'), fit: BoxFit.cover),
        ),
      );
    } else if (widget.typeOrder == 3) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
              image: AssetImage('assets/img/proceso.png'), fit: BoxFit.cover),
        ),
      );
    } else {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
              image: AssetImage('assets/img/finalizado.png'),
              fit: BoxFit.cover),
        ),
      );
    }
  }

  void routeDetail(BuildContext context) {
    if (widget.typeOrder == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: OrderdetailWidget(
              user: widget.user,
              order: widget.order,
              imageOrder: 'assets/img/pendiente.png',
              typeOrder: widget.typeOrder,
              business: widget.business,
              stateNavigator: widget.stateNavigator,
            ),
            bloc: ShopBloc(),
          ),
        ),
      );
    } else if (widget.typeOrder == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: OrderdetailWidget(
              user: widget.user,
              order: widget.order,
              imageOrder: 'assets/img/proceso.png',
              typeOrder: widget.typeOrder,
              business: widget.business,
              stateNavigator: widget.stateNavigator,
            ),
            bloc: ShopBloc(),
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: OrderdetailWidget(
              user: widget.user,
              order: widget.order,
              imageOrder: 'assets/img/finalizado.png',
              typeOrder: widget.typeOrder,
              business: widget.business,
              stateNavigator: widget.stateNavigator,
            ),
            bloc: ShopBloc(),
          ),
        ),
      );
    }
  }
}
