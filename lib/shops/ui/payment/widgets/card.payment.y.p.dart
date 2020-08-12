import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kushi/shops/ui/payment/pages/model/CreditCard_model.dart';
import 'package:kushi/shops/ui/payment/pages/model/mediopago.model.dart';

// ignore: must_be_immutable
class CardItemPaymentYP extends StatefulWidget {
  CardInfo cardInfo;
  MedioPago methodpayment;
  CardItemPaymentYP(
      {Key key, @required this.cardInfo, @required this.methodpayment});
  @override
  _CardItemPaymentYPState createState() => _CardItemPaymentYPState();
}

class _CardItemPaymentYPState extends State<CardItemPaymentYP> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              offset: Offset(0, 4),
              blurRadius: 9)
        ],
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            widget.cardInfo.leftColor,
            widget.cardInfo.rightColor,
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Image.asset(
            widget.cardInfo.logopng,
            height: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 210,
            decoration: BoxDecoration(color: Colors.white),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 16 / 16,
                        child: valuecodigoQr(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // ignore: missing_return
  Widget valuecodigoQr() {
    if (widget.cardInfo.id == 3) {
      if (widget.methodpayment.urlImage == null) {
        return Image(image: AssetImage('assets/img/notfoundQr.png'));
      } else {
        return CachedNetworkImage(
          placeholder: (context, url) => Center(
              child: Image.asset(
            'assets/img/gifcarrucel.gif',
            fit: BoxFit.fill,
          )),
          imageUrl: widget.methodpayment.urlImage,
          fit: BoxFit.fill,
        );
      }
    } else if (widget.cardInfo.id == 4) {
      return Image(
        image: AssetImage('assets/img/paymentplin.jpg'),
      );
    }
  }
}
