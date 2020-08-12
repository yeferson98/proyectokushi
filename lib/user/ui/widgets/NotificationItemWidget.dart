import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:kushi/bussiness/bloc/business.bloc.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/routes/routes.arguments.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/order.payment.model.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/ui/screens/shop.List.Prod.dart';
import 'package:kushi/user/model/notification.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/screens/detail.order.dart';

// ignore: must_be_immutable
class NotificationItemWidget extends StatefulWidget {
  NotificationItemWidget(
      {Key key,
      this.notification,
      this.user,
      this.onDismissed,
      @required this.onDismissedUpdated,
      this.animation,
      this.animationController,
      this.query})
      : super(key: key);
  NotificationModel notification;
  UserModel user;
  ValueChanged<NotificationModel> onDismissed;
  ValueChanged<int> onDismissedUpdated;
  AnimationController animationController;
  Animation<dynamic> animation;
  String query;

  @override
  _NotificationItemWidgetState createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {
  BusinessBloc businessBloc;
  @override
  Widget build(BuildContext context) {
    businessBloc = BlocProvider.of(context);
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation.value), 0.0),
            child: Slidable(
                delegate: new SlidableDrawerDelegate(),
                actionExtentRatio: 0.25,
                actions: <Widget>[
                  new IconSlideAction(
                    icon: UiIcons.eye,
                    caption: 'ver',
                    color: Theme.of(context).accentColor,
                    onTap: () {
                      if (widget.notification.viewItem == 0) {
                        runUpdatedNotification(this.widget.notification);
                      } else if (widget.notification.viewItem == 1) {
                        routeValueData();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("kushi no pudo comunicarse con internet"),
                          ),
                        );
                      }
                    },
                  ),
                ],
                secondaryActions: <Widget>[
                  new IconSlideAction(
                    key: Key(widget.notification.keyDocument),
                    icon: UiIcons.trash_1,
                    color: Colors.redAccent,
                    caption: 'Eliminar',
                    onTap: () {
                      alertInfodelete();
                    },
                  )
                ],
                child: valueNotificationItem()),
          ),
        );
      },
    );
  }

  Widget valueNotificationItem() {
    if (this.widget.notification.viewItem == 1) {
      return Container(
        color: Theme.of(context).focusColor.withOpacity(0.15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            imageNotification(this.widget.notification.image),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    this.widget.notification.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .merge(TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  RichText(
                    text: TextSpan(
                      text: (widget.notification.bussines)
                          .substring(0, widget.query.length),
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .merge(TextStyle(color: Colors.black)),
                      children: [
                        TextSpan(
                          text: (widget.notification.bussines)
                              .substring(widget.query.length),
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    this.widget.notification.description,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        color: Theme.of(context).hintColor.withOpacity(0.10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            imageNotification(this.widget.notification.iconNotification),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    this.widget.notification.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .merge(TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  RichText(
                    text: TextSpan(
                      text: (widget.notification.bussines)
                          .substring(0, widget.query.length),
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .merge(TextStyle(color: Colors.black)),
                      children: [
                        TextSpan(
                          text: (widget.notification.bussines)
                              .substring(widget.query.length),
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    this.widget.notification.description,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  Widget imageNotification(String url) {
    if (this.widget.notification.image == null) {
      return Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
              image: AssetImage('assets/images/notification.png'),
              fit: BoxFit.cover),
        ),
      );
    } else {
      return Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        ),
      );
    }
  }

  void alertInfodelete() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                '¡${widget.user.name}! ¿Seguro que desea eliminar esta notificación?'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'SI',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.onDismissed(widget.notification);
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

  void runUpdatedNotification(NotificationModel model) {
    NotificationModel newmodel = new NotificationModel();
    newmodel.keyDocument = model.keyDocument;
    newmodel.idBusiness = model.idBusiness;
    newmodel.click = model.click;
    newmodel.bussines = model.bussines;
    newmodel.codData = model.codData;
    newmodel.description = model.description;
    newmodel.date = model.date;
    newmodel.iconNotification = model.iconNotification;
    newmodel.image = model.image;
    newmodel.view = model.view;
    newmodel.viewItem = 1;
    newmodel.typeNotification = model.typeNotification;
    newmodel.sound = model.sound;
    newmodel.name = model.name;
    businessBloc
        .updatedNotiicationViewAll(newmodel, widget.user.idCliente.toString())
        .then(
      (value) {
        if (value == true) {
          routeValueData();
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Se produjo un error inesperado"),
            ),
          );
        }
      },
    );
  }

  routeValueData() {
    if (this.widget.notification.typeNotification == 1 ||
        this.widget.notification.typeNotification == 2) {
      businessBloc
          .fetchBusinesBusinesBloc(this.widget.user.idCliente.toString())
          .then(
        (business) {
          final data = business
              .where((p) => p.uid == this.widget.notification.idBusiness)
              .toList();
          if (data.length > 0) {
            routeListProduct(data[0]);
          } else {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Empresa no encontrada")));
          }
        },
      );
    } else if (this.widget.notification.typeNotification == 3) {
      businessBloc
          .fetchBusinesBusinesBloc(this.widget.user.idCliente.toString())
          .then(
        (business) {
          final data = business
              .where((p) => p.uid == this.widget.notification.idBusiness)
              .toList();
          if (data.length > 0) {
            getProduct(data[0]);
          } else {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Empresa no encontrada")));
          }
        },
      );
    } else if (this.widget.notification.typeNotification == 4) {
      businessBloc
          .fetchBusinesBusinesBloc(this.widget.user.idCliente.toString())
          .then(
        (business) {
          final data = business
              .where((p) => p.uid == this.widget.notification.idBusiness)
              .toList();
          if (data.length > 0) {
            getlistOrderUser(data[0]);
          } else {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Empresa no encontrada")));
          }
        },
      );
    } else {}
  }

  getProduct(Business business) {
    businessBloc
        .fetchProductRepository(
            business.uid.toString(), this.widget.user.idCliente.toString())
        .then(
      (products) {
        products
            .where((p) => p.idprod == this.widget.notification.codData)
            .toList();
        if (products.length > 0) {
          routeDetailProduct(business, products[0]);
        } else {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("No pude localizar al producto")));
        }
      },
    );
  }

  getlistOrderUser(Business business) {
    businessBloc
        .getOrderPaymentClientBloc(widget.user.idCliente.toString())
        .then((value) {
      if (value.code == 500) {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("No pude conectarme al servidor")));
      } else if (value.code == null) {
        final pendiente = value.pendiente
            .where((p) => p.codPayment == widget.notification.codData)
            .toList();
        final proceso = value.proceso
            .where((p) => p.codPayment == widget.notification.codData)
            .toList();
        final finalizado = value.finalizado
            .where((p) => p.codPayment == widget.notification.codData)
            .toList();
        if (pendiente.length > 0) {
          routeDetailOrder(1, pendiente[0], business);
        } else if (proceso.length > 0) {
          routeDetailOrder(3, proceso[0], business);
        } else if (finalizado.length > 0) {
          routeDetailOrder(4, finalizado[0], business);
        } else {
          widget.onDismissedUpdated(0);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: InkWell(
                child: Text(
                    "Click para ingresas al sistema web de gestión de pedidos y productos"),
                onTap: () {
                  _launchInWebViewWithDomStorage(
                      'http://app.todorapid.com/login');
                },
              ),
            ),
          );
        }
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("Internet y yo nos comunicamos")));
      }
    });
  }

  Future<void> _launchInWebViewWithDomStorage(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void routeListProduct(Business business) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext contex) => BlocProvider(
          child: ShopsProduct(
            supermarkets: business,
            userData: widget.user,
          ),
          bloc: ShopBloc(),
        ),
      ),
    );
  }

  void routeDetailProduct(Business business, ProductModel product) {
    if (product.isfavorite == 0) {
      Navigator.of(context).pushNamed(
        '/Product',
        arguments: new RouteArgumentProd(
          argumentsList: [
            product,
            product.id,
            widget.user,
            business,
            false,
            false,
          ],
          id: product.idprod.toString(),
        ),
      );
    } else {
      Navigator.of(context).pushNamed(
        '/Product',
        arguments: new RouteArgumentProd(
          argumentsList: [
            product,
            product.id,
            widget.user,
            business,
            true,
            true,
          ],
          id: product.idprod.toString(),
        ),
      );
    }
  }

  void routeDetailOrder(
      int typeOrder, OrderPaymentModel order, Business business) {
    if (typeOrder == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: OrderdetailWidget(
              user: widget.user,
              order: order,
              imageOrder: 'assets/img/pendiente.png',
              typeOrder: typeOrder,
              business: business,
              stateNavigator: 0,
            ),
            bloc: ShopBloc(),
          ),
        ),
      );
    } else if (typeOrder == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: OrderdetailWidget(
              user: widget.user,
              order: order,
              imageOrder: 'assets/img/proceso.png',
              typeOrder: typeOrder,
              business: business,
              stateNavigator: 0,
            ),
            bloc: ShopBloc(),
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: OrderdetailWidget(
              user: widget.user,
              order: order,
              imageOrder: 'assets/img/finalizado.png',
              typeOrder: typeOrder,
              business: business,
              stateNavigator: 0,
            ),
            bloc: ShopBloc(),
          ),
        ),
      );
    }
  }
}
