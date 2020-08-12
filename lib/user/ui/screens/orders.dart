import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/shops/model/order.payment.model.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/screens/orders_products.dart';
import 'package:kushi/user/ui/widgets/DrawerWidget.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';

// ignore: must_be_immutable
class OrdersWidget extends StatefulWidget {
  int currentTab;
  UserModel user;
  Business bussines;
  int stateNavigator;
  OrdersWidget(
      {Key key,
      @required this.currentTab,
      @required this.user,
      this.stateNavigator,
      this.bussines})
      : super(key: key);
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ShopRepository _serviceShopRepository;
  List<OrderPaymentModel> pendiente;
  List<OrderPaymentModel> proceso;
  List<OrderPaymentModel> finalizado;
  bool connectionInteernet = true;
  @override
  void initState() {
    _serviceShopRepository = Ioc.get<ShopRepository>();
    getlistOrderUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: DefaultTabController(
        initialIndex: widget.currentTab ?? 0,
        length: 3,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: BlocProvider(
            child: DrawerWidget(
              user: widget.user,
              inicioState: true,
              business: widget.bussines,
            ),
            bloc: UserBloc(),
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
//        leading: new IconButton(
//          icon: new Icon(UiIcons.return_icon, color: Theme.of(context).hintColor),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
            leading: new IconButton(
              icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Mis Ordenes',
              style: Theme.of(context).textTheme.headline3,
            ),
            actions: <Widget>[
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
            bottom: TabBar(
                indicatorPadding: EdgeInsets.all(10),
                labelPadding: EdgeInsets.symmetric(horizontal: 5),
                unselectedLabelColor: Theme.of(context).accentColor,
                labelColor: Theme.of(context).primaryColor,
                isScrollable: true,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).accentColor),
                tabs: [
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Pendiente"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Proceso"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Finalizado"),
                      ),
                    ),
                  ),
                ]),
          ),
          body: tabBar(),
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

  Widget tabBar() {
    if (pendiente == null || proceso == null || finalizado == null) {
      return Center(
        child: connectionInteernet
            ? Image.asset(
                'assets/img/loderOrder.gif',
                height: 50,
              )
            : Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text('Revisa tu conexión a internet'),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              getlistOrderUser();
                            }),
                        Text('Reintentar')
                      ],
                    )
                  ],
                ),
              ),
      );
    } else {
      return TabBarView(
        children: [
          OrdersProductsWidget(
            ordersList: pendiente,
            typeOrder: 1,
            user: widget.user,
            business: widget.bussines,
            stateNavigator: widget.stateNavigator,
          ),
          OrdersProductsWidget(
            ordersList: proceso,
            typeOrder: 3,
            user: widget.user,
            business: widget.bussines,
            stateNavigator: widget.stateNavigator,
          ),
          OrdersProductsWidget(
            ordersList: finalizado,
            typeOrder: 4,
            user: widget.user,
            business: widget.bussines,
            stateNavigator: widget.stateNavigator,
          ),
        ],
      );
    }
  }

  getlistOrderUser() {
    _serviceShopRepository
        .getOrderPaymentClientRepository(widget.user.idCliente.toString())
        .then((value) {
      if (value.code == 500) {
        setState(() {
          connectionInteernet = false;
        });
      } else if (value.code == null) {
        setState(() {
          connectionInteernet = true;
        });
        if (widget.stateNavigator == 0) {
          setState(() {
            pendiente = value.pendiente;
            proceso = value.proceso;
            finalizado = value.finalizado;
          });
        } else {
          setState(() {
            pendiente = value.pendiente
                .where((p) => p.codBusiness == widget.bussines.uid)
                .toList();
            proceso = value.proceso
                .where((p) => p.codBusiness == widget.bussines.uid)
                .toList();
            finalizado = value.finalizado
                .where((p) => p.codBusiness == widget.bussines.uid)
                .toList();
          });
        }
      } else {
        setState(() {
          connectionInteernet = false;
        });
      }
    });
  }
}
