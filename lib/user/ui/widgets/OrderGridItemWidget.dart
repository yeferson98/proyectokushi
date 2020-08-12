import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/order.payment.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/screens/detail.order.dart';

class OrderGridItemWidget extends StatelessWidget {
  const OrderGridItemWidget(
      {Key key,
      @required this.order,
      @required this.heroTag,
      @required this.typeOrder,
      @required this.user,
      @required this.business,
      @required this.stateNavigator})
      : super(key: key);

  final OrderPaymentModel order;
  final String heroTag;
  final int typeOrder;
  final UserModel user;
  final Business business;
  final int stateNavigator;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        routeDetail(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).hintColor.withOpacity(0.10),
                offset: Offset(0, 4),
                blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: this.heroTag + order.codPayment.toString(),
              child: Stack(
                children: <Widget>[imgOrder(), orderPayment(context)],
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                order.businessRS,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'S/.' + double.parse(order.paymentAll).toStringAsFixed(2),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Wrap(
                spacing: 10,
                children: <Widget>[
                  Text(
                    'Fecha entrega',
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        UiIcons.calendar,
                        color: Theme.of(context).focusColor,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        order.dateDelivery,
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ],
                  ),
                  Text(
                    'Hora entrega',
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
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
                        order.hourDelivery,
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    ],
                  ),
                ],
//                            crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget imgOrder() {
    if (typeOrder == 1) {
      return Image.asset('assets/img/pendiente.png');
    } else if (typeOrder == 3) {
      return Image.asset('assets/img/proceso.png');
    } else {
      return Image.asset('assets/img/finalizado.png');
    }
  }

  Widget orderPayment(BuildContext context) {
    if (typeOrder == 1) {
      return Positioned(
        top: 100,
        right: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  topLeft: Radius.circular(100)),
              color: Colors.orange),
          alignment: AlignmentDirectional.topEnd,
          child: Text(
            'Nro. Orden: ${order.numberPayment}',
            style: Theme.of(context).textTheme.bodyText2.merge(
                  TextStyle(color: Theme.of(context).primaryColor),
                ),
          ),
        ),
      );
    } else if (typeOrder == 3) {
      return Positioned(
        top: 100,
        right: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  topLeft: Radius.circular(100)),
              color: Colors.green),
          alignment: AlignmentDirectional.topEnd,
          child: Text(
            'Nro. Orden: ${order.numberPayment}',
            style: Theme.of(context).textTheme.bodyText2.merge(
                  TextStyle(color: Theme.of(context).primaryColor),
                ),
          ),
        ),
      );
    } else {
      return Positioned(
        top: 100,
        right: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  topLeft: Radius.circular(100)),
              color: Theme.of(context).accentColor),
          alignment: AlignmentDirectional.topEnd,
          child: Text(
            'Nro. Orden: ${order.numberPayment}',
            style: Theme.of(context).textTheme.bodyText2.merge(
                  TextStyle(color: Theme.of(context).primaryColor),
                ),
          ),
        ),
      );
    }
  } //OrderdetailWidget

  void routeDetail(BuildContext context) {
    if (typeOrder == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: OrderdetailWidget(
              user: user,
              order: order,
              imageOrder: 'assets/img/pendiente.png',
              typeOrder: typeOrder,
              business: business,
              stateNavigator: stateNavigator,
            ),
            bloc: ShopBloc(),
          ),
        ),
      );
    } else if (typeOrder == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: OrderdetailWidget(
              user: user,
              order: order,
              imageOrder: 'assets/img/proceso.png',
              typeOrder: typeOrder,
              business: business,
              stateNavigator: stateNavigator,
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
              user: user,
              order: order,
              imageOrder: 'assets/img/finalizado.png',
              typeOrder: typeOrder,
              business: business,
              stateNavigator: stateNavigator,
            ),
            bloc: ShopBloc(),
          ),
        ),
      );
    }
  }
}
