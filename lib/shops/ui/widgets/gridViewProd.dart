import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/ui/widgets/floating_action_button_green.dart';
import 'package:provider/provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/routes/routes.arguments.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/user/model/user.model.dart';

// ignore: must_be_immutable
class CardGrid extends StatefulWidget {
  String heroTag;
  ProductModel product;
  String avatar;
  UserModel user;
  int quantity;
  Business supermarkets;
  bool valueFavoriteList;
  ValueChanged<int> onChanged;
  CardGrid(
      {Key key,
      this.product,
      this.heroTag,
      this.avatar,
      this.quantity = 0,
      this.onChanged,
      @required this.user,
      @required this.supermarkets,
      @required this.valueFavoriteList})
      : super(key: key);
  @override
  _CardGridState createState() => _CardGridState();
}

class _CardGridState extends State<CardGrid> {
  ShopBloc shopBloc;
  bool statusFavorite = true;
  bool removestatusFavorite = false;
  bool stopFuctionFavorite = false;
  String priceTash = "";
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
    shopBloc = BlocProvider.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
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
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Hero(
                      tag: widget.heroTag + widget.product.idprod.toString(),
                      child: Material(
                        child: InkWell(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Center(
                              child:
                                  Image.asset('assets/img/progressImage.gif'),
                            ),
                            imageUrl: widget.product.imageList,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) {
                                  return new Material(
                                    color: Colors.black12,
                                    child: Container(
                                      padding: EdgeInsets.all(30.0),
                                      child: InkWell(
                                        child: Hero(
                                          tag: widget.heroTag +
                                              widget.product.idprod.toString(),
                                          child: Container(
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  Center(
                                                child: Image.asset(
                                                    'assets/img/progressImage.gif'),
                                              ),
                                              imageUrl:
                                                  widget.product.imageDetail,
                                              width: 300.0,
                                              height: 300.0,
                                              alignment: Alignment.center,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 500),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      child: favorite(),
                      top: 0,
                      left: 0,
                    ),
                    stockTerminado()
                  ],
                ),
                SizedBox(height: 12),
                nameproduct(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    descripcionMarca,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: <Widget>[
                      Text(
                        widget.product.money + widget.product.price,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          priceTash,
                          style: Theme.of(context).textTheme.headline6.merge(
                              TextStyle(
                                  color: Theme.of(context).focusColor,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 10)),
                        ),
                      ),
                    ],
                  ),
                ),
                multicolors(),
                SizedBox(height: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget nameproduct() {
    if (widget.product.name == null ||
        widget.product.name == "" ||
        widget.product.name == " ") {
      if (widget.product.desciptionOne == null ||
          widget.product.desciptionOne == "" ||
          widget.product.desciptionOne == " ") {
        return Container();
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Text(
            widget.product.desciptionOne,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
      }
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Text(
          widget.product.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );
    }
  }

  Widget multicolors() {
    if (widget.product.ismultiColors == 0) {
      return Consumer<InterceptApp>(
        builder: (context, InterceptApp value, Widget child) {
          if (widget.product.stock != '0.00') {
            List<ProductModel> data = value.lista();
            final result =
                data.where((p) => p.idprod == widget.product.idprod).toList();
            if (result.length != 0) {
              widget.quantity = result[0].quantity;
            }
            if (result.length == 0) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                    child: IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Theme.of(context).accentColor,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.quantity =
                              this.decrementQuantity(widget.quantity);
                        });
                        listquantity(widget.quantity, widget.product);
                      },
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  Text(
                    widget.quantity.toString(),
                    style: TextStyle(
                        fontSize: 26, color: Theme.of(context).accentColor),
                  ),
                  SizedBox(
                    height: 25,
                    child: IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).accentColor,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.quantity =
                              this.incrementQuantity(widget.quantity);
                        });
                        listquantity(widget.quantity, widget.product);
                      },
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                  )
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                    child: IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Theme.of(context).accentColor,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.quantity =
                              this.decrementQuantity(widget.quantity);
                        });
                        listquantity(widget.quantity, widget.product);
                      },
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  Text(
                    widget.quantity.toString(),
                    style: TextStyle(
                        fontSize: 26, color: Theme.of(context).accentColor),
                  ),
                  SizedBox(
                    height: 25,
                    child: IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).accentColor,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.quantity =
                              this.incrementQuantity(widget.quantity);
                        });
                        listquantity(widget.quantity, widget.product);
                      },
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                  )
                ],
              );
            }
          } else {
            return Container();
          }
        },
      );
    } else {
      return Consumer<InterceptApp>(
        builder: (context, InterceptApp value, Widget child) {
          List<ProductModel> data = value.lista();
          final result =
              data.where((p) => p.idprod == widget.product.idprod).toList();
          if (result.length == 0) {
            return child;
          } else {
            if (result[0].idCol.isNotEmpty) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Icon(
                      UiIcons.checked,
                      color: Theme.of(context).accentColor,
                    ),
                  )
                ],
              );
            } else {
              return child;
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Icon(
                UiIcons.eye,
                color: Theme.of(context).accentColor,
              ),
            )
          ],
        ),
      );
    }
  }

  Widget favorite() {
    if (widget.valueFavoriteList == false) {
      if (widget.product.isfavorite == 0) {
        return FloatingActionButtonGreen(
            iconData: Icon(statusFavorite ? UiIcons.heart : Icons.favorite,
                color: statusFavorite
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor),
            color: statusFavorite
                ? Theme.of(context).primaryColor
                : Theme.of(context).accentColor,
            onPressed: () {
              if (statusFavorite == true) {
                shopBloc
                    .saveProduductFavoriteBloc(
                        widget.product.idprod.toString(),
                        widget.user.idCliente.toString(),
                        widget.supermarkets.uid.toString())
                    .then((bool status) {
                  if (status == false) {
                    setState(() {
                      statusFavorite = false;
                      removestatusFavorite = true;
                    });
                  } else if (status == true) {
                    _showAlertDialog('No se  puede añadir a favoritos');
                  }
                });
              } else {
                shopBloc
                    .removeProduductFavoriteRepository(
                  widget.product.idprod.toString(),
                  widget.user.idCliente.toString(),
                )
                    .then((bool status) {
                  if (status == false) {
                    setState(() {
                      removestatusFavorite = true;
                      statusFavorite = true;
                    });
                  } else if (status == true) {
                    _showAlertDialog('No se  puede remover este producto');
                  }
                });
              }
            });
      } else {
        return FloatingActionButtonGreen(
          iconData: Icon(removestatusFavorite ? UiIcons.heart : Icons.favorite,
              color: removestatusFavorite
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor),
          color: removestatusFavorite
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
          onPressed: () {
            if (removestatusFavorite == true) {
              shopBloc
                  .saveProduductFavoriteBloc(
                      widget.product.idprod.toString(),
                      widget.user.id.toString(),
                      widget.supermarkets.uid.toString())
                  .then((bool status) {
                if (status == false) {
                  setState(() {
                    statusFavorite = false;
                    removestatusFavorite = false;
                  });
                } else if (status == true) {
                  _showAlertDialog('No se  puede añadir a favoritos');
                }
              });
            } else {
              shopBloc
                  .removeProduductFavoriteRepository(
                widget.product.idprod.toString(),
                widget.user.idCliente.toString(),
              )
                  .then((bool status) {
                if (status == false) {
                  setState(
                    () {
                      statusFavorite = true;
                      removestatusFavorite = true;
                    },
                  );
                } else if (status == true) {
                  _showAlertDialog('No se  puede remover este producto');
                }
              });
            }
          },
        );
      }
    } else {
      return FloatingActionButtonGreen(
        iconData: Icon(UiIcons.trash, color: Theme.of(context).accentColor),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          shopBloc
              .removeProduductFavoriteRepository(
            widget.product.idprod.toString(),
            widget.user.idCliente.toString(),
          )
              .then((bool status) {
            if (status == false) {
              widget.onChanged(1);
            } else if (status == true) {
              _showAlertDialog('No se  puede remover este producto');
            }
          });
        },
      );
    }
  }

  Widget stockTerminado() {
    if (widget.product.ismultiColors == 0) {
      if (widget.product.stock == '0.00') {
        return Positioned(
            top: 70,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      topLeft: Radius.circular(100)),
                  color: Color.fromRGBO(95, 10, 159, 9.0)),
              alignment: AlignmentDirectional.topEnd,
              child: Text(
                'Stock Agotado',
                style: Theme.of(context).textTheme.bodyText2.merge(
                      TextStyle(color: Theme.of(context).primaryColor),
                    ),
              ),
            ));
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  void listquantity(int quantity, ProductModel product) async {
    List<ProductModel> data = Provider.of<InterceptApp>(context).lista();
    final queryresult = data.where((p) => p.idprod == product.idprod).toList();
    if (queryresult.length == 0) {
      product.quantity = widget.quantity;
      product.idCol = "1";
      product.idSize = 1;
      Provider.of<InterceptApp>(context).addProdCart(product);
    } else {
      if (queryresult[0].idCol.isEmpty) {
      } else {
        product.quantity = widget.quantity;
        product.idCol = "1";
        product.idSize = 1;
        Provider.of<InterceptApp>(context).addProdCart(product);
      }
    }
  }

  incrementQuantity(int quantity) {
    double stock = double.parse(widget.product.stock);
    int stockcant = stock.toInt();
    if (stockcant > quantity) {
      return ++quantity;
    } else {
      _showAlertDialog('Stock agotado');
      return quantity;
    }
  }

  decrementQuantity(int quantity) {
    if (quantity > 0) {
      return --quantity;
    } else {
      return quantity;
    }
  }

  void _showAlertDialog(String menssage) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            menssage,
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
