import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/shops/ui/screens/shop.List.Prod.dart';
import 'package:kushi/shops/ui/screens/wish.list.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/ui/widgets/DrawerWidget.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/components/ProgressIndicator.dart';
import 'package:kushi/routes/routes.arguments.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/configs/app_config.dart' as config;
import 'package:kushi/shops/ui/widgets/ShoppingCartButtonWidget.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';
import 'package:wakelock/wakelock.dart';

// ignore: must_be_immutable
class WishList extends StatefulWidget {
  RouteArgumentProd routeArgument;
  UserModel userData;
  Business supermarkets;
  WishList({Key key, this.supermarkets, this.userData}) : super(key: key);
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList>
    with SingleTickerProviderStateMixin {
  ShopBloc shopBloc;
  ShopRepository _serviceTodoRapidAPI;
  Future<List<ProductModel>> products;
  GlobalKey<RefreshIndicatorState> refreshKey;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _serviceTodoRapidAPI = Ioc.get<ShopRepository>();
    getProduct();
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  getProduct() async {
    products = _serviceTodoRapidAPI
        .fetchWishListProductRepository(widget.userData.idCliente.toString());
    Future<void>.delayed(const Duration(seconds: 2))
      ..then<void>(
        (_) {
          if (mounted) {
            shopBloc.wakelock().then((value) {
              if (value == true) {
                setState(() {
                  Wakelock.disable();
                });
              }
            });
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    shopBloc = BlocProvider.of(context);
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            widget.supermarkets.name,
            style: Theme.of(context).textTheme.headline4,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          actions: <Widget>[
            new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor,
              supermarkets: widget.supermarkets,
              userData: widget.userData,
            ),
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: AppBarNotificatios(
                user: widget.userData,
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
                    // Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.userData.urlImage),
                  ),
                )),
          ],
          leading: new IconButton(
              icon: new Icon(UiIcons.return_icon,
                  color: Theme.of(context).hintColor),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext contex) => BlocProvider(
                        child: ShopsProduct(
                          supermarkets: widget.supermarkets,
                          userData: widget.userData,
                        ),
                        bloc: ShopBloc(),
                      ),
                    ));
              }),
        ),
        drawer: BlocProvider(
          child: DrawerWidget(
            user: widget.userData,
            inicioState: false,
            business: widget.supermarkets,
          ),
          bloc: UserBloc(),
        ),
        body: RefreshIndicator(
          key: refreshKey,
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              UiIcons.heart,
                              color: Theme.of(context).hintColor,
                              size: 30,
                            ),
                            title: Text(
                              'Lista de deseos',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            subtitle: Text(
                              'Mis productos agregados ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FutureBuilder(
                          future: products,
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return CupertinoProgressIndicator();
                              case ConnectionState.none:
                                return Center(
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('Sin conexión a internet'),
                                            IconButton(
                                                icon: Icon(Icons.refresh),
                                                onPressed: () {
                                                  _actualizarServiceProduct();
                                                }),
                                            Text('Reintentar')
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              case ConnectionState.active:
                                return WishListWidget(
                                  supermarkets: widget.supermarkets,
                                  user: widget.userData,
                                  productsList: snapshot.data,
                                  valueFavoriteList: true,
                                  onChangedUpdated: (int value) {
                                    if (value == 1) {
                                      _actualizarServiceProduct();
                                    }
                                  },
                                );
                              case ConnectionState.done:
                                if (snapshot.data == null) {
                                  return Center(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(Icons.refresh),
                                                  onPressed: () {
                                                    _actualizarServiceProduct();
                                                  }),
                                              Text('Reintentar')
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  List<ProductModel> products = snapshot.data;
                                  if (products.length == 0) {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      height: config.App(context).appHeight(60),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                width: 150,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .bottomLeft,
                                                        end: Alignment.topRight,
                                                        colors: [
                                                          Theme.of(context)
                                                              .accentColor,
                                                          Theme.of(context)
                                                              .accentColor
                                                              .withOpacity(0.1),
                                                        ])),
                                                child: Icon(
                                                  UiIcons.heart,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 70,
                                                ),
                                              ),
                                              Positioned(
                                                right: -30,
                                                bottom: -50,
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            150),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                left: -20,
                                                top: -50,
                                                child: Container(
                                                  width: 120,
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.15),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            150),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Opacity(
                                            opacity: 0.4,
                                            child: Text(
                                              'Lista de deseos vacía',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3
                                                  .merge(TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300)),
                                            ),
                                          ),
                                          SizedBox(height: 50),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext contex) =>
                                                            BlocProvider(
                                                      child: ShopsProduct(
                                                        supermarkets:
                                                            widget.supermarkets,
                                                        userData:
                                                            widget.userData,
                                                      ),
                                                      bloc: ShopBloc(),
                                                    ),
                                                  ));
                                            },
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 30),
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.15),
                                            shape: StadiumBorder(),
                                            child: Text(
                                              'Empezar a Comprar',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    final data = products
                                        .where((p) =>
                                            p.idBusiness ==
                                            widget.supermarkets.uid)
                                        .toList();
                                    if (data.length > 0) {
                                      return WishListWidget(
                                        supermarkets: widget.supermarkets,
                                        user: widget.userData,
                                        productsList: data,
                                        valueFavoriteList: true,
                                        onChangedUpdated: (int value) {
                                          if (value == 1) {
                                            _actualizarServiceProduct();
                                          }
                                        },
                                      );
                                    } else {
                                      return Container(
                                        alignment: AlignmentDirectional.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        height:
                                            config.App(context).appHeight(60),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                  width: 150,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .bottomLeft,
                                                          end: Alignment
                                                              .topRight,
                                                          colors: [
                                                            Theme.of(context)
                                                                .accentColor,
                                                            Theme.of(context)
                                                                .accentColor
                                                                .withOpacity(
                                                                    0.1),
                                                          ])),
                                                  child: Icon(
                                                    UiIcons.heart,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 70,
                                                  ),
                                                ),
                                                Positioned(
                                                  right: -30,
                                                  bottom: -50,
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              150),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: -20,
                                                  top: -50,
                                                  child: Container(
                                                    width: 120,
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              150),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Opacity(
                                              opacity: 0.4,
                                              child: Text(
                                                'Lista de deseos vacía',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    .merge(TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300)),
                                              ),
                                            ),
                                            SizedBox(height: 50),
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 30),
                                              color: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.15),
                                              shape: StadiumBorder(),
                                              child: Text(
                                                'Empezar a Comprar',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          onRefresh: () {
            return Future<void>.delayed(const Duration(seconds: 2))
              ..then<void>((_) {
                if (mounted) {
                  _actualizarServiceProduct();
                }
              });
          },
        ),
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
                    'Si',
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

  void _actualizarServiceProduct() {
    setState(() {
      products = _serviceTodoRapidAPI
          .fetchWishListProductRepository(widget.userData.idCliente.toString());
    });
  }
}
