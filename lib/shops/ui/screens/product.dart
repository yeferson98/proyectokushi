import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/shops/ui/screens/cartShop.dart';
import 'package:kushi/shops/ui/widgets/carousel.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';
import 'package:provider/provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/routes/routes.arguments.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/product.color.model.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/model/product.size.model.dart';
import 'package:kushi/shops/ui/screens/shop.List.Prod.dart';
import 'package:kushi/shops/ui/widgets/ProductDetailsTabWidget.dart';
import 'package:kushi/shops/ui/widgets/ProductHomeTabWidget.dart';
import 'package:kushi/shops/ui/widgets/ShoppingCartButtonWidget.dart';
import 'package:kushi/user/model/user.model.dart';

// ignore: must_be_immutable
class ProductWidget extends StatefulWidget {
  RouteArgumentProd routeArgument;
  ProductModel productItem;
  String heroTag;
  int idColor;
  UserModel user;
  int quantity = 0;
  bool statusFavorite;
  bool removestatusFavorite;
  Business supermarkets;

  ProductWidget({
    Key key,
    this.routeArgument,
    this.quantity = 0,
    this.idColor = 0,
  }) {
    productItem = this.routeArgument.argumentsList[0] as ProductModel;
    heroTag = this.routeArgument.argumentsList[1] as String;
    user = this.routeArgument.argumentsList[2] as UserModel;
    supermarkets = this.routeArgument.argumentsList[3] as Business;
    statusFavorite = this.routeArgument.argumentsList[4] as bool;
    removestatusFavorite = this.routeArgument.argumentsList[5] as bool;
  }
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ProductColorModel color;
  ProductSizeModel size;
  Future<List<ProductModel>> products;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<CarouselState> carouselStateKey = GlobalKey<CarouselState>();
  int _tabIndex = 0;
  ProductModel product = new ProductModel();
  List<ProductColorModel> _productColorModel = new List<ProductColorModel>();
  ShopRepository _serviceTodoRapidAPI;
  bool stopFuctionFavorite = false;
  String selectedPhoto = "";
  @override
  void initState() {
    getaddProdnew();
    _tabController =
        TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _serviceTodoRapidAPI = Ioc.get<ShopRepository>();
    getColor();
    getProduct();
    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  getaddProdnew() {
    setState(() {
      product = widget.productItem;
    });
  }

  getProduct() async {
    products = _serviceTodoRapidAPI.fetchProductRepository(
        widget.supermarkets.uid.toString(), widget.user.idCliente.toString());
  }

  void changeImageOnColorSelected(int index) {
    carouselStateKey.currentState.switchToPage(index);
    setState(() {
      selectedPhoto = _productColorModel[index].image;
    });
  }

  void getColor() async {
    if (widget.productItem.ismultiColors == 0) {
      setState(() {
        _productColorModel = [];
      });
    } else if (widget.productItem.ismultiColors == 1) {
      _serviceTodoRapidAPI
          .fetchProductColorsRepository(widget.productItem.idprod.toString())
          .then((colores) {
        if (colores.length > 0) {
          setState(() {
            _productColorModel = colores;
          });
        } else {
          setState(() {
            _productColorModel = [];
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.15),
                  blurRadius: 5,
                  offset: Offset(0, -2)),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(child: favorite()),
              SizedBox(width: 10),
              Consumer<InterceptApp>(
                  builder: (context, InterceptApp value, Widget child) {
                    List<ProductModel> data = value.lista();
                    final result = data
                        .where((p) => p.idprod == widget.productItem.idprod)
                        .toList();
                    if (result.length != 0) {
                      if (widget.productItem.ismultiColors == 0) {
                        widget.quantity = result[0].quantity;
                      } else {
                        ///widget.quantity =1;
                      }
                    }
                    if (widget.productItem.ismultiColors == 1) {
                      return child;
                    } else {
                      if (result.length > 0) {
                        return FlatButton(
                          onPressed: () {
                            Provider.of<InterceptApp>(context)
                                .costRemoveDouble();
                            Provider.of<InterceptApp>(context)
                                .descRemoveDouble();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext contex) => CartWidget(
                                    supermarkets: widget.supermarkets,
                                    userData: widget.user,
                                  ),
                                ));
                          },
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                          child: Container(
                            width: 240,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    'Ver en en el carrito',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return child;
                      }
                    }
                  },
                  child: buttonAddCart()),
            ],
          ),
        ),
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
//          snap: true,
            floating: true,
//          pinned: true,
            automaticallyImplyLeading: false,
            leading: new IconButton(
                icon: new Icon(UiIcons.return_icon,
                    color: Theme.of(context).hintColor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext contex) => BlocProvider(
                          child: ShopsProduct(
                            supermarkets: widget.supermarkets,
                            userData: widget.user,
                          ),
                          bloc: ShopBloc(),
                        ),
                      ));
                }),
            actions: <Widget>[
              new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor,
                supermarkets: widget.supermarkets,
                userData: widget.user,
              ),
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
                child: AppBarNotificatios(
                  user: widget.user,
                  scaffoldKey: _scaffoldKey,
                ),
              ),
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
                      backgroundImage: NetworkImage(widget.user.urlImage),
                    ),
                  )),
            ],
            backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 350,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Hero(
                tag: widget.heroTag + product.idprod.toString(),
                child: carrucelImageProduct(),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.symmetric(horizontal: 10),
              unselectedLabelColor: Theme.of(context).accentColor,
              labelColor: Theme.of(context).primaryColor,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).accentColor),
              tabs: [
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.2),
                            width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Producto"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.2),
                            width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Detalle"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Offstage(
                offstage: 0 != _tabIndex,
                child: Column(
                  children: <Widget>[
                    ProductHomeTabWidget(
                      product: product,
                      products: products,
                      supermarkets: widget.supermarkets,
                      user: widget.user,
                      onChangedColor: (ProductColorModel model) {
                        if (model == null) {
                          setState(() {
                            color.id = 0;
                            widget.quantity = 0;
                            size = null;
                          });
                        } else {
                          setState(() {
                            color = model;
                            widget.quantity = 0;
                          });
                        }
                      },
                      onChangedSize: (ProductSizeModel model) {
                        if (model == null) {
                          setState(() {
                            widget.quantity = 0;
                            size = null;
                          });
                        } else {
                          setState(() {
                            size = model;
                            widget.quantity = 0;
                          });
                        }
                      },
                      onChanged: (ProductModel value) {
                        setState(() {
                          widget.productItem = value;
                        });
                      },
                      changeImageOnColorSelected: (index) {
                        changeImageOnColorSelected(index);
                      },
                    ),
                  ],
                ),
              ),
              Offstage(
                offstage: 1 != _tabIndex,
                child: Column(
                  children: <Widget>[
                    ProductDetailsTabWidget(
                      product: product,
                      supermarkets: widget.supermarkets,
                      user: widget.user,
                      products: products,
                      onChanged: (ProductModel value) {
                        setState(() {
                          widget.productItem = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            ]),
          )
        ]),
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
                    'Yes',
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

  Widget carrucelImageProduct() {
    if (widget.productItem.ismultiColors == 0) {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(product.imageDetail),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.white.withOpacity(0),
                  Colors.white.withOpacity(0),
                  Theme.of(context).scaffoldBackgroundColor
                ],
                stops: [0, 0.5, 0.6, 1],
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            width: double.infinity,
            child: Carousel(
              key: carouselStateKey,
              images: _productColorModel.map((photo) {
                return NetworkImage(photo.image);
              }).toList(),
            ),
          ),
        ],
      );
    }
  }

  Widget buttonAddCart() {
    if (widget.productItem.ismultiColors == 0) {
      if (widget.productItem.stock == '0.00') {
        return FlatButton(
          onPressed: () {
            //accion
          },
          color: Theme.of(context).accentColor,
          shape: StadiumBorder(),
          child: Container(
            width: 240,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Stock agotado',
                        style: Theme.of(context).textTheme.headline1.merge(
                            TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                      Icon(Icons.pan_tool, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return FlatButton(
          onPressed: () {
            listquantity(product);
          },
          color: Theme.of(context).accentColor,
          shape: StadiumBorder(),
          child: Container(
            width: 240,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.quantity = this.decrementQuantity(widget.quantity);
                    });
                  },
                  iconSize: 30,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  icon: Icon(Icons.remove_circle_outline),
                  color: Theme.of(context).primaryColor,
                ),
                Text(widget.quantity.toString(),
                    style: Theme.of(context).textTheme.subtitle1.merge(
                        TextStyle(color: Theme.of(context).primaryColor))),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.quantity = this.incrementQuantity(widget.quantity);
                    });
                  },
                  iconSize: 30,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  icon: Icon(Icons.add_circle_outline),
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Agregar',
                        style: Theme.of(context).textTheme.headline1.merge(
                            TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                      Icon(Icons.shopping_cart, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      return FlatButton(
        onPressed: () {
          listquantity(product);
        },
        color: Theme.of(context).accentColor,
        shape: StadiumBorder(),
        child: Container(
          width: 240,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.quantity = this.decrementQuantity(widget.quantity);
                  });
                },
                iconSize: 30,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                icon: Icon(Icons.remove_circle_outline),
                color: Theme.of(context).primaryColor,
              ),
              Text(widget.quantity.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .merge(TextStyle(color: Theme.of(context).primaryColor))),
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.quantity = this.incrementQuantity(widget.quantity);
                  });
                },
                iconSize: 30,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                icon: Icon(Icons.add_circle_outline),
                color: Theme.of(context).primaryColor,
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Text(
                      'Agregar',
                      style: Theme.of(context).textTheme.headline1.merge(
                          TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                    Icon(Icons.shopping_cart, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  //============================== Section  of the functios, add cart shop ===========================================================================//
  incrementQuantity(int quantity) {
    if (widget.productItem.ismultiColors == 1) {
      if (size != null) {
        double stock = double.parse(size.cantStock);
        int stockcant = stock.toInt();
        if (stockcant > quantity) {
          return ++quantity;
        } else {
          _showAlertDialogStock('Talla sin stock');
          return quantity;
        }
      } else {
        _showAlertDialogStock('Seleccione su talla');
        return quantity = 0;
      }
    } else if (widget.productItem.ismultiColors == 0) {
      double stock = double.parse(widget.productItem.stock);
      int stockcant = stock.toInt();
      if (stockcant > quantity) {
        return ++quantity;
      } else {
        _showAlertDialogStock('Producto sin Stock');
        return quantity;
      }
    } else {
      _showAlertDialogStock('Algo no va bien');
    }
  }

  decrementQuantity(int quantity) {
    if (quantity > 0) {
      return --quantity;
    } else {
      return quantity;
    }
  }

  void listquantity(ProductModel products) async {
    products.quantity = widget.quantity;
    if (products.ismultiColors == 0) {
      if (widget.quantity == 0) {
        _showAlertDialogStock('¡Porfavor aumente  cantidad!');
      } else {
        product.idCol = "1";
        product.idSize = 1;
        product.nameSize = "";
        Provider.of<InterceptApp>(context).addMlProduct(product);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext contex) => BlocProvider(
              child: ShopsProduct(
                supermarkets: widget.supermarkets,
                userData: widget.user,
              ),
              bloc: ShopBloc(),
            ),
          ),
        );
      }
    } else if (products.ismultiColors == 1) {
      if (color == null) {
        _showAlertDialogStock('Porfavor seleccione un color');
      } else if (size == null) {
        _showAlertDialog();
      } else {
        if (widget.quantity > 0) {
          Provider.of<InterceptApp>(context)
              .queryexistSize(size.id, color.id, products.idprod)
              .then((int cant) {
            if (cant == 0) {
              products.idCol = color.id.toString();
              products.codR = color.codR;
              products.codG = color.codG;
              products.codB = color.codB;
              products.idSize = size.id;
              products.nameSize = size.name;
              products.catidadSize = size.cantStock;
              products.imageList = selectedPhoto;
              products.imageDetail = selectedPhoto;
              Provider.of<InterceptApp>(context).addMlProduct(product);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext contex) => BlocProvider(
                    child: ShopsProduct(
                      supermarkets: widget.supermarkets,
                      userData: widget.user,
                    ),
                    bloc: ShopBloc(),
                  ),
                ),
              );
            } else {
              _showAlertDialogStock(
                  '¡Este producto ya se encuentra en su carrito, allí puede aumentar la cantidad!');
            }
          });
        } else {
          _showAlertDialogStock('Aumente cantidad para su producto');
        }
      }
    } else {
      _showAlertDialogStock('Ocurrio un error inesperado');
    }
  }
  //============================== end===========================================================================//

  //============================== Function add favorite===========================================================================//
  Widget favorite() {
    if (widget.productItem.isfavorite == 0) {
      return FlatButton(
          onPressed: () {
            if (widget.statusFavorite == true) {
              setState(() {
                stopFuctionFavorite = true;
              });
              _serviceTodoRapidAPI
                  .saveProduductFavoriteRepository(
                      widget.productItem.idprod.toString(),
                      widget.user.idCliente.toString(),
                      widget.supermarkets.uid.toString())
                  .then((bool status) {
                if (status == false) {
                  setState(() {
                    stopFuctionFavorite = false;
                    widget.statusFavorite = false;
                    widget.removestatusFavorite = true;
                  });
                } else if (status == true) {
                  stopFuctionFavorite = false;
                  _showAlertDialogStock('Ups, algo no va bien ');
                }
              });
            } else {
              setState(() {
                stopFuctionFavorite = true;
              });
              _serviceTodoRapidAPI
                  .removeProduductFavoriteRepository(
                widget.productItem.idprod.toString(),
                widget.user.idCliente.toString(),
              )
                  .then((bool status) {
                if (status == false) {
                  setState(() {
                    stopFuctionFavorite = false;
                    widget.removestatusFavorite = true;
                    widget.statusFavorite = true;
                  });
                } else if (status == true) {
                  stopFuctionFavorite = false;
                  _showAlertDialogStock('Ups, algo no va bien ');
                }
              });
            }
          },
          padding: EdgeInsets.symmetric(vertical: 14),
          color: Theme.of(context).accentColor,
          shape: StadiumBorder(),
          child: stopFuctionFavorite
              ? Container(
                  width: 20,
                  height: 20,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ))
              : Icon(
                  widget.statusFavorite ? UiIcons.heart : Icons.favorite,
                  color: Theme.of(context).primaryColor,
                ));
    } else {
      return FlatButton(
          onPressed: () {
            if (widget.removestatusFavorite == true) {
              setState(() {
                stopFuctionFavorite = true;
              });
              _serviceTodoRapidAPI
                  .saveProduductFavoriteRepository(
                      widget.productItem.idprod.toString(),
                      widget.user.idCliente.toString(),
                      widget.supermarkets.uid.toString())
                  .then((bool status) {
                if (status == false) {
                  setState(() {
                    stopFuctionFavorite = false;
                    widget.statusFavorite = false;
                    widget.removestatusFavorite = false;
                  });
                } else if (status == true) {
                  stopFuctionFavorite = false;
                  _showAlertDialogStock('Ups, algo no va bien');
                }
              });
            } else {
              setState(() {
                stopFuctionFavorite = true;
              });
              _serviceTodoRapidAPI
                  .removeProduductFavoriteRepository(
                widget.productItem.idprod.toString(),
                widget.user.idCliente.toString(),
              )
                  .then((bool status) {
                if (status == false) {
                  setState(() {
                    stopFuctionFavorite = false;
                    widget.statusFavorite = true;
                    widget.removestatusFavorite = true;
                  });
                } else if (status == true) {
                  stopFuctionFavorite = false;
                  _showAlertDialogStock('Ups, algo no va bien ');
                }
              });
            }
          },
          padding: EdgeInsets.symmetric(vertical: 14),
          color: Theme.of(context).accentColor,
          shape: StadiumBorder(),
          child: stopFuctionFavorite
              ? Container(
                  width: 20,
                  height: 20,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ))
              : Icon(
                  widget.removestatusFavorite ? UiIcons.heart : Icons.favorite,
                  color: Theme.of(context).primaryColor,
                ));
    }
  }

  //============================== end ===========================================================================//

  //============================== Section of the functios Alerts ===========================================================================//
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

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            '¡' +
                'Profavor seleccione su talla del \n ' +
                widget.productItem.name +
                '!',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
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
