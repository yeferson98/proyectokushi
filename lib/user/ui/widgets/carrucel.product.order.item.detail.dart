import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kushi/shops/model/order.detail.product.model.dart';

// ignore: must_be_immutable
class FlashOrderCarouselItemWidget extends StatefulWidget {
  String heroTag;
  double marginLeft;
  OrderDetailProduct product;
  ValueChanged<String> onChangedImage;
  FlashOrderCarouselItemWidget(
      {Key key,
      this.heroTag,
      this.marginLeft,
      this.product,
      this.onChangedImage})
      : super(key: key);

  @override
  _FlashOrderCarouselItemWidgetState createState() =>
      _FlashOrderCarouselItemWidgetState();
}

class _FlashOrderCarouselItemWidgetState
    extends State<FlashOrderCarouselItemWidget> {
  String descripcionMarca = "";
  @override
  void initState() {
    verifyNullData();
    super.initState();
  }

  verifyNullData() {
    if (widget.product.idBrand == 1 || widget.product.idBrand == null) {
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
        if (widget.product.urlimage == null ||
            widget.product.urlimage == "" ||
            widget.product.urlimage == " ") {
          _showAlertDialogStock('Este producto no tiene imagen para mostrar');
        } else {
          setState(() {
            widget.onChangedImage(widget.product.urlimage);
          });
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: this.widget.marginLeft, right: 20),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Hero(
                tag: widget.heroTag + widget.product.id.toString(),
                child: imageProduct()),
            Positioned(
              top: 10,
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
                  'Unidades: ${double.parse(widget.product.quantity).toInt()}',
                  style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 11)),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 140),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              width: 160,
              height: 130,
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
                  nameproduct(),
                  Row(
                    children: <Widget>[
                      // The title of the product
                      Expanded(
                        child: Text(
                          'Costo del producto por unidad \n S/.${double.parse(widget.product.price).toStringAsFixed(2)} ',
                          style: Theme.of(context).textTheme.bodyText1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  SizedBox(height: 3),
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
                  /*Text(
                    '${product.available} Available',
                    style: Theme.of(context).textTheme.body1,
                    overflow: TextOverflow.ellipsis,
                  ),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget imageProduct() {
    if (widget.product.urlimage == null ||
        widget.product.urlimage == "" ||
        widget.product.urlimage == " ") {
      return Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Theme.of(context).primaryColor,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/img/notFountDataService.png'),
            ),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.15),
                  offset: Offset(0, 3),
                  blurRadius: 10)
            ]),
      );
    } else {
      return Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Theme.of(context).primaryColor,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(widget.product.urlimage),
            ),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.15),
                  offset: Offset(0, 3),
                  blurRadius: 10)
            ]),
      );
    }
  }

  Widget nameproduct() {
    if (widget.product.nameProduct == null ||
        widget.product.nameProduct == "") {
      if (widget.product.descCorta != null || widget.product.descCorta != "") {
        return Text(
          widget.product.descCorta,
          style: Theme.of(context).textTheme.bodyText2,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
        );
      } else {
        return Container();
      }
    } else {
      return Text(
        widget.product.nameProduct,
        style: Theme.of(context).textTheme.bodyText2,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.fade,
      );
    }
  }

  void _showAlertDialogStock(String message) {
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
}
