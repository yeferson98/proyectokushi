import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/model/order.payment.model.dart';

// ignore: must_be_immutable
class OrderSubDetailTabWidget extends StatefulWidget {
  OrderPaymentModel order;
  int typeOrder = 0;
  OrderSubDetailTabWidget({this.order, @required this.typeOrder});

  @override
  OrderSubDetailTabWidgetState createState() => OrderSubDetailTabWidgetState();
}

class OrderSubDetailTabWidgetState extends State<OrderSubDetailTabWidget> {
  String descripcionMarca = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("HH:mm");
    DateTime dateDelivery = DateTime.parse(widget.order.dateDelivery);
    DateTime operationdate = DateTime.parse(widget.order.dateOperation);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.order.businessRS,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Chip(
                padding: EdgeInsets.all(0),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Nro.${widget.order.numberPayment}',
                        style: Theme.of(context).textTheme.bodyText2.merge(
                            TextStyle(color: Theme.of(context).primaryColor))),
                  ],
                ),
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                shape: StadiumBorder(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  'S/.' +
                      double.parse(widget.order.paymentAll).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline2),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.15),
                  blurRadius: 5,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Detalle de delivery',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).focusColor,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            widget.order.descriptionAddress,
                            style: Theme.of(context).textTheme.bodyText1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                      ],
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
                          'Fecha de entrega :' +
                              ' ' +
                              formatDate(
                                  dateDelivery, [dd, '/', mm, '/', yyyy]),
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
                          'Hora de entrega: ' +
                              ' ' +
                              formatDate(
                                  format.parse(
                                      widget.order.hourDelivery + ':' + '00'),
                                  [hh, ':', nn, ' ', am]),
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
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.15),
                  blurRadius: 5,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Detalle de compra ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    verifyNullDataPhone(),
                    Row(
                      children: <Widget>[
                        Icon(
                          UiIcons.calendar,
                          color: Theme.of(context).focusColor,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Fecha de compra:' +
                              ' ' +
                              formatDate(
                                  operationdate, [dd, '/', mm, '/', yyyy]),
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
                          'Hora de compra: ' +
                              ' ' +
                              formatDate(
                                  format.parse(widget.order.hourOperation),
                                  [hh, ':', nn, ' ', am]),
                          style: Theme.of(context).textTheme.bodyText1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ],
                    ),
                    widget.order.typePayment.isNotEmpty
                        ? Row(
                            children: <Widget>[
                              Icon(
                                Icons.credit_card,
                                color: Theme.of(context).focusColor,
                                size: 20,
                              ),
                              SizedBox(width: 10), //descriptionPayment
                              Text(
                                'Medio de Pago: ' +
                                    ' ' +
                                    widget.order.typePayment,
                                style: Theme.of(context).textTheme.bodyText1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ],
                          )
                        : Container(),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          color: Theme.of(context).focusColor,
                          size: 20,
                        ),
                        SizedBox(width: 10), //descriptionPayment
                        statusPayment()
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget verifyNullDataPhone() {
    if (widget.order.phoneBusiness == null ||
        widget.order.phoneBusiness == "") {
      if (widget.order.mobileBusiness != null ||
          widget.order.phoneBusiness != "") {
        return Row(
          children: <Widget>[
            Icon(
              Icons.phone_iphone,
              color: Theme.of(context).focusColor,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Celular:' + ' ' + widget.order.mobileBusiness,
              style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ],
        );
      } else {
        return Container();
      }
    } else {
      return Row(
        children: <Widget>[
          Icon(
            Icons.phone,
            color: Theme.of(context).focusColor,
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            'Telefono:' + ' ' + descripcionMarca,
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ],
      );
    }
  }

  Widget statusPayment() {
    if (widget.order.descriptionPayment != null ||
        widget.order.descriptionPayment == "" ||
        widget.order.descriptionPayment == " ") {
      return Text(
        'Estado de compra: ' + widget.order.descriptionPayment,
        style: Theme.of(context).textTheme.bodyText1,
        overflow: TextOverflow.fade,
        softWrap: false,
      );
    } else {
      return Text(
        'Estado de compra: ' + 'Not found',
        style: Theme.of(context).textTheme.bodyText1,
        overflow: TextOverflow.fade,
        softWrap: false,
      );
    }
  }
}
