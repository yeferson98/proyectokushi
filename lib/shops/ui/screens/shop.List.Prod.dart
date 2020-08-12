import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/ui/widgets/DrawerWidget.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/components/ProgressIndicator.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/ui/screens/product.list.dart';
import 'package:kushi/shops/ui/widgets/HomeSliderWidget.dart';
import 'package:kushi/shops/ui/widgets/ShoppingCartButtonWidget.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';
import 'package:wakelock/wakelock.dart';

// ignore: must_be_immutable
class ShopsProduct extends StatefulWidget {
  String argument;
  UserModel userData;
  Business supermarkets;
  ShopsProduct({Key key, this.supermarkets, this.userData, this.argument})
      : super(key: key);
  @override
  _ShopsProductState createState() => _ShopsProductState();
}

class _ShopsProductState extends State<ShopsProduct>
    with SingleTickerProviderStateMixin {
  ShopBloc shopBloc;
  ShopRepository _serviceTodoRapidAPI;
  Future<List<ProductModel>> products;
  GlobalKey<RefreshIndicatorState> refreshKey;
  final GlobalKey<ScaffoldState> _scaffoldKeyShop = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _serviceTodoRapidAPI = Ioc.get<ShopRepository>();
    getProduct();
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  getProduct() async {
    products = _serviceTodoRapidAPI.fetchProductRepository(
        widget.supermarkets.uid.toString(),
        widget.userData.idCliente.toString());
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
        key: _scaffoldKeyShop,
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
                scaffoldKey: _scaffoldKeyShop,
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
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => _scaffoldKeyShop.currentState.openDrawer(),
          ),
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
                        HomeSliderWidget(
                          idsupermarket: widget.supermarkets.uid,
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
                                return ProductoList(
                                  supermarkets: widget.supermarkets,
                                  user: widget.userData,
                                  productsList: snapshot.data,
                                  valueFavoriteList: false,
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
                                  return ProductoList(
                                    supermarkets: widget.supermarkets,
                                    user: widget.userData,
                                    productsList: snapshot.data,
                                    valueFavoriteList: false,
                                  );
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
                    'SI',
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
      products = _serviceTodoRapidAPI.fetchProductRepository(
          widget.supermarkets.uid.toString(),
          widget.userData.idCliente.toString());
    });
  }
}
