import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/shops/model/product.model.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatefulWidget {
  String heroTag;
  ProductModel product;
  int quantity;
  VoidCallback onDismissed;

  CartItemWidget(
      {Key key,
      this.product,
      this.heroTag,
      this.quantity = 0,
      this.onDismissed})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(this.widget.product.hashCode.toString()),
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
        Provider.of<InterceptApp>(context)
            .removeCostoEnvio(widget.product.idprod.toString());
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).accentColor,
            content:
                Text("${widget.product.name} se elimino del carro de compras "),
          ),
        );
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          /*Navigator.of(context).pushNamed('/Product',
              arguments: RouteArgument(id: widget.product.id, argumentsList: [widget.product, widget.heroTag]));*/
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300].withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: widget.heroTag + widget.product.id.toString(),
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                        image: NetworkImage(widget.product.imageList),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          nameproduct(),
                          Text(
                            widget.product.money + widget.product.price,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .merge(TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[color()],
                    ),
                    SizedBox(width: 10),
                    Consumer<InterceptApp>(
                      builder: (context, InterceptApp value, Widget child) {
                        List<ProductModel> data = value.lista();
                        final result = data
                            .where((p) => p.idprod == widget.product.idprod)
                            .toList();
                        if (result.length != 0) {
                          if (result[0].ismultiColors == 1) {
                            final resultDetalle = data
                                .where((p) => p.id == widget.product.id)
                                .toList();
                            widget.quantity = resultDetalle[0].quantity;
                          } else {
                            final resultDetalle = data
                                .where((p) => p.id == widget.product.id)
                                .toList();
                            widget.quantity = resultDetalle[0].quantity;
                          }
                        }
                        return Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.quantity = this
                                          .decrementQuantity(widget.quantity);
                                    });
                                    listquantity(
                                        widget.quantity, widget.product);
                                  },
                                  iconSize: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  icon: Icon(Icons.remove_circle_outline),
                                  color: Theme.of(context).hintColor,
                                ),
                                Text(widget.quantity.toString(),
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.quantity = this
                                          .incrementQuantity(widget.quantity);
                                    });
                                    listquantity(
                                        widget.quantity, widget.product);
                                  },
                                  iconSize: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  icon: Icon(Icons.add_circle_outline),
                                  color: Theme.of(context).hintColor,
                                ),
                              ],
                            ),
                            size(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget nameproduct() {
    if (widget.product.name == null ||
        widget.product.name == "" ||
        widget.product.name == " ") {
      if (widget.product.desciptionOne != null ||
          widget.product.desciptionOne != "" ||
          widget.product.desciptionOne != "") {
        return Text(
          widget.product.desciptionOne,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .subtitle1
              .merge(TextStyle(fontSize: 12)),
        );
      } else {
        return Container();
      }
    } else {
      return Text(
        widget.product.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: Theme.of(context).textTheme.subtitle1,
      );
    }
  }

  Widget color() {
    if (widget.product.ismultiColors == 1) {
      return SizedBox(
        width: 38,
        height: 38,
        child: FilterChip(
            label: Text(''),
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            backgroundColor: Color.fromRGBO(
                int.parse(widget.product.codR),
                int.parse(widget.product.codG),
                int.parse(widget.product.codB),
                1.0),
            selectedColor: Color.fromRGBO(
                int.parse(widget.product.codR),
                int.parse(widget.product.codG),
                int.parse(widget.product.codB),
                1.0),
            selected: widget.product.idCol.isNotEmpty,
            shape: CircleBorder(),
            avatar: Text(''),
            onSelected: (bool value) async {}),
      );
    } else if (widget.product.ismultiColors == 0) {
      return Container();
    } else {
      return Container();
    }
  }

  Widget size() {
    if (widget.product.ismultiColors == 1) {
      return SizedBox(
        height: 28,
        child: RawChip(
          label: Text(
            widget.product.nameSize,
            style: TextStyle(fontSize: 10),
          ),
          labelStyle: TextStyle(color: Theme.of(context).hintColor),
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
          backgroundColor: Theme.of(context).focusColor.withOpacity(0.05),
          selectedColor: Theme.of(context).focusColor.withOpacity(0.2),
          selected: widget.product.nameSize.isNotEmpty,
          shape: StadiumBorder(
              side: BorderSide(
                  color: Theme.of(context).focusColor.withOpacity(0.05))),
          onSelected: (bool value) {},
        ),
      );
    } else if (widget.product.ismultiColors == 0) {
      return Container();
    } else {
      return Container();
    }
  }

  void listquantity(int quantity, ProductModel product) async {
    if (product.ismultiColors == 1) {
      product.quantity = widget.quantity;
      Provider.of<InterceptApp>(context).addProdCartMltp(product);
    } else {
      product.quantity = widget.quantity;
      Provider.of<InterceptApp>(context).addProdCartMltp(product);
    }
  }

  incrementQuantity(int quantity) {
    if (widget.product.ismultiColors == 0) {
      double stock = double.parse(widget.product.stock);
      int stockcant = stock.toInt();
      if (stockcant > quantity) {
        return ++quantity;
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Se le termino el stock del producto: ${widget.product.name} "),
          ),
        );
        return quantity;
      }
    } else if (widget.product.ismultiColors == 1) {
      double stock = double.parse(widget.product.catidadSize);
      int stockcant = stock.toInt();
      if (stockcant > quantity) {
        return ++quantity;
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Se le termino el stock del producto: ${widget.product.name} "),
          ),
        );
        return quantity;
      }
    }
  }

  decrementQuantity(int quantity) {
    if (quantity > 1) {
      return --quantity;
    } else {
      return quantity;
    }
  }
}
