import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/order.payment.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/screens/orders.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';
import 'package:kushi/user/ui/widgets/order.paymentDetails.dart';
import 'package:kushi/user/ui/widgets/orders.payment.product.details.dart';

// ignore: must_be_immutable
class OrderdetailWidget extends StatefulWidget {
  UserModel user;
  Business business;
  OrderPaymentModel order;
  String heroTag = 'DetailOrder120';
  String imageOrder;
  int stateNavigator = 0;
  int typeOrder = 0;
  OrderdetailWidget(
      {Key key,
      @required this.user,
      @required this.business,
      @required this.order,
      @required this.imageOrder,
      @required this.typeOrder,
      @required this.stateNavigator});

  @override
  _OrderdetailWidgetState createState() => _OrderdetailWidgetState();
}

class _OrderdetailWidgetState extends State<OrderdetailWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKeyDetailOrder =
      new GlobalKey<ScaffoldState>();
  int _tabIndex = 0;
  bool imageStatus = true;
  bool buttonAction = true;
  ShopBloc shopBloc;
  @override
  void initState() {
    _tabController =
        TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
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

  @override
  Widget build(BuildContext context) {
    shopBloc = BlocProvider.of(context);
    return Scaffold(
      key: _scaffoldKeyDetailOrder,
      bottomNavigationBar: buttonFinishOrder(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            leading: new IconButton(
              icon: new Icon(UiIcons.return_icon,
                  color: Theme.of(context).hintColor),
              onPressed: () => routeNavigatorDetailValue(),
            ),
            actions: <Widget>[
              Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
                child: AppBarNotificatios(
                  user: widget.user,
                  scaffoldKey: _scaffoldKeyDetailOrder,
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
                tag: widget.heroTag + widget.order.codPayment.toString(),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageStatus
                              ? AssetImage(widget.imageOrder)
                              : NetworkImage(widget.imageOrder),
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
                              stops: [
                            0,
                            0.4,
                            0.6,
                            1
                          ])),
                    ),
                  ],
                ),
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
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.2),
                              width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Detalle"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.2),
                              width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Productos"),
                      ),
                    ),
                  ),
                ]),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Offstage(
                  offstage: 0 != _tabIndex,
                  child: Column(
                    children: <Widget>[
                      OrderSubDetailTabWidget(
                        order: widget.order,
                        typeOrder: widget.typeOrder,
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: 1 != _tabIndex,
                  child: Column(
                    children: <Widget>[
                      ProductDetailsOrderTabWidget(
                        onChangedImage: (image) {
                          setState(() {
                            imageStatus = false;
                            widget.imageOrder = image;
                          });
                        },
                        order: widget.order,
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  routeNavigatorDetailValue() {
    if (widget.stateNavigator == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OrdersWidget(
              currentTab: 0,
              user: widget.user,
              stateNavigator: 0,
              bussines: widget.business),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OrdersWidget(
              currentTab: 0,
              user: widget.user,
              stateNavigator: 1,
              bussines: widget.business),
        ),
      );
    }
  }

  buttonFinishOrder() {
    if (widget.typeOrder == 1) {
      return Container(
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
            Expanded(
              child: FlatButton(
                  onPressed: () {
                    alert(
                        'Esta orden esta en pendiente en unos minutos podra verlo en proceso');
                  },
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                  child: Icon(
                    Icons.help_outline,
                    color: Theme.of(context).primaryColor,
                  )),
            ),
            SizedBox(width: 10),
            FlatButton(
              onPressed: () {},
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
              child: Container(
                width: 240,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Orden en Espera',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (widget.typeOrder == 3) {
      return Container(
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
            Expanded(
              child: FlatButton(
                  onPressed: () {
                    alert(
                        'Esta función esta siendo trabajada por nuestro equipo de desarrollo \n pronto podra disfrutar de esta función');
                  },
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                  child: Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  )),
            ),
            SizedBox(width: 10),
            FlatButton(
              onPressed: () {
                alertOrderQuestion();
              },
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
              child: Container(
                width: 240,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Confirmar entrega',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
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
            Expanded(
              child: FlatButton(
                  onPressed: () {
                    alert('Esta compra fue entregada exitosamente');
                  },
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Theme.of(context).accentColor,
                  shape: StadiumBorder(),
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                  )),
            ),
            SizedBox(width: 10),
            FlatButton(
              onPressed: () {},
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
              child: Container(
                width: 240,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Producto entregado',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void alertOrderQuestion() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('¿Usted esta seguro de finalizar esta Orden?'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'SI',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.pop(context);
                alertOrderQuestion2();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'NO',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void alertOrderQuestion2() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('¿Confirme si recibió su pedido de esta orden.'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'SI',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.pop(context);
                updateOrderClient();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'NO',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void updateOrderClient() {
    shopBloc
        .updateStatusOrderClient(widget.order.codPayment.toString())
        .then((value) {
      if (value == -200) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            Future<void>.delayed(const Duration(seconds: 2))
              ..then<void>((_) {
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => OrdersWidget(
                        currentTab: 0,
                        user: widget.user,
                        stateNavigator: widget.stateNavigator,
                        bussines: widget.business),
                  ),
                );
              });
            return Center(
              child: Container(
                width: 250.0,
                height: 230.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/img/loaderStock.gif",
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      "Hecho, compra finalizada \n redireccionando...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.black,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
            );
          },
        );
      } else if (value == -404) {
        alert('La compra no existe');
      } else if (value == -500) {
        alert('No pudimos procesar su petición');
      } else {
        alert('No pudimos procesar su petición');
      }
    });
  }

  void alert(String message) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            message,
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
