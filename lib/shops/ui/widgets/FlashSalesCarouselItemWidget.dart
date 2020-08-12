import 'package:flutter/material.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/routes/routes.arguments.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/user/model/user.model.dart';

// ignore: must_be_immutable
class FlashSalesCarouselItemWidget extends StatefulWidget {
  String heroTag;
  double marginLeft;
  ProductModel product;
  UserModel user;
  Business supermarkets;
  FlashSalesCarouselItemWidget(
      {Key key,
      this.heroTag,
      this.marginLeft,
      this.product,
      this.supermarkets,
      @required this.user})
      : super(key: key);

  @override
  _FlashSalesCarouselItemWidgetState createState() =>
      _FlashSalesCarouselItemWidgetState();
}

class _FlashSalesCarouselItemWidgetState
    extends State<FlashSalesCarouselItemWidget> {
  String priceTash = "";
  bool statusFavorite = true;
  bool removestatusFavorite = false;
  bool stopFuctionFavorite = false;
  String descripcionMarca = "";
  @override
  void initState() {
    if (widget.product.priceTash == null) {
      priceTash = "";
    } else {
      priceTash = widget.product.money + widget.product.priceTash;
    }
    verifyNullData();
    super.initState();
  }

  verifyNullData() {
    if (widget.product.idBrand == 1) {
      descripcionMarca = "";
    } else {
      if (widget.product.brandDescription == null) {
        descripcionMarca = "";
      } else {
        descripcionMarca = widget.product.brandDescription;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacementNamed('/Product',
            arguments: new RouteArgumentProd(argumentsList: [
              widget.product,
              widget.product.id,
              widget.user,
              widget.supermarkets,
              statusFavorite,
              removestatusFavorite,
            ], id: widget.product.idprod.toString()));
      },
      child: Container(
        margin: EdgeInsets.only(left: this.widget.marginLeft, right: 20),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Hero(
              tag: widget.heroTag + widget.product.id,
              child: Container(
                width: 160,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.product.imageList),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 6,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100)),
                    color: Theme.of(context).accentColor),
                alignment: AlignmentDirectional.topEnd,
                child: Text(
                  'Stock. ${double.parse(widget.product.stock).toInt()}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 190),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    children: <Widget>[
                      // The title of the product
                      Expanded(
                        child: Text(
                          '${widget.product.money}${widget.product.price}',
                          style: Theme.of(context).textTheme.bodyText1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                      Text(
                        '${priceTash.toString()}',
                        style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                                color: Theme.of(context).focusColor,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 10)),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  SizedBox(height: 7),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          descripcionMarca,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
