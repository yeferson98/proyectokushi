import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/model/order.payment.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/widgets/EmptyOrdersProductsWidget.dart';
import 'package:kushi/user/ui/widgets/OrderGridItemWidget.dart';
import 'package:kushi/user/ui/widgets/OrderListItemWidget.dart';
import 'package:kushi/utils/utils.paginacion.list.dart';

// ignore: must_be_immutable
class OrdersProductsWidget extends StatefulWidget {
  List<OrderPaymentModel> ordersList;
  UserModel user;
  Business business;
  int typeOrder;
  int stateNavigator = 0;
  @override
  _OrdersProductsWidgetState createState() => _OrdersProductsWidgetState();

  OrdersProductsWidget(
      {Key key,
      this.ordersList,
      @required this.typeOrder,
      @required this.user,
      @required this.business,
      @required this.stateNavigator})
      : super(key: key);
}

class _OrdersProductsWidgetState extends State<OrdersProductsWidget> {
  String layout = 'list';
  bool endList = true;
  int ca = PaginacionMostrar.cantidad_paginacion_ordenes;
  int cmi = PaginacionMostrar.cantidad_inicial_a_mostar_ordenes;
  int cac = 0;
  int cam = 0;
  @override
  void initState() {
    function();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Offstage(
            offstage: widget.ordersList.isEmpty,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  UiIcons.inbox,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Lista de ordenes',
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(context).textTheme.headline6,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          this.layout = 'list';
                        });
                      },
                      icon: Icon(
                        Icons.format_list_bulleted,
                        color: this.layout == 'list'
                            ? Theme.of(context).accentColor
                            : Theme.of(context).focusColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          this.layout = 'grid';
                        });
                      },
                      icon: Icon(
                        Icons.apps,
                        color: this.layout == 'grid'
                            ? Theme.of(context).accentColor
                            : Theme.of(context).focusColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Offstage(
            offstage: this.layout != 'list' || widget.ordersList.isEmpty,
            child: itemListaOrder(),
          ),
          Offstage(
            offstage: this.layout != 'grid' || widget.ordersList.isEmpty,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: itemGridListOrder(),
            ),
          ),
          Offstage(
            offstage: widget.ordersList.isNotEmpty,
            child: EmptyOrdersProductsWidget(),
          ),
          SizedBox(
            height: 10,
          ),
          butonItemsAdd(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget butonItemsAdd() {
    if (widget.ordersList.length > cmi) {
      return endList
          ? InkWell(
              child: Center(
                child: Text(
                  'Mostrar más ordenes',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              onTap: () {
                function();
              },
            )
          : Center(child: Text('Fin de la lista'));
    } else {
      return Container();
    }
  }

  Widget itemListaOrder() {
    if (widget.ordersList.length > 0) {
      return new ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: cam,
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          return OrderListItemWidget(
            heroTag: 'orders_list',
            order: widget.ordersList.elementAt(index),
            typeOrder: widget.typeOrder,
            user: widget.user,
            business: widget.business,
            stateNavigator: widget.stateNavigator,
          );
        },
      );
    } else {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Image.asset('assets/img/notFountDataService.png'),
        ],
      );
    }
  }

  Widget itemGridListOrder() {
    if (widget.ordersList.length > 0) {
      final size = MediaQuery.of(context).size;
      if (size.width > 500) {
        return new StaggeredGridView.countBuilder(
          primary: false,
          shrinkWrap: true,
          crossAxisCount: 4,
          itemCount: cam,
          itemBuilder: (BuildContext context, int index) {
            OrderPaymentModel order = widget.ordersList.elementAt(index);
            return OrderGridItemWidget(
                order: order,
                heroTag: 'orders_grid',
                typeOrder: widget.typeOrder,
                user: widget.user,
                business: widget.business,
                stateNavigator: widget.stateNavigator);
          },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        );
      } else {
        return new StaggeredGridView.countBuilder(
          primary: false,
          shrinkWrap: true,
          crossAxisCount: 4,
          itemCount: cam,
          itemBuilder: (BuildContext context, int index) {
            OrderPaymentModel order = widget.ordersList.elementAt(index);
            return OrderGridItemWidget(
                order: order,
                heroTag: 'orders_grid',
                typeOrder: widget.typeOrder,
                user: widget.user,
                business: widget.business,
                stateNavigator: widget.stateNavigator);
          },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        );
      }
    } else {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Image.asset('assets/img/notFountDataService.png'),
        ],
      );
    }
  }

  void function() async {
    int total = widget.ordersList.length;
    if (total == cam) {
      setState(() {
        endList = false;
      });
    } else {
      if (cac == 0) {
        cac = cac + cmi;
        if (total > cac) {
          setState(() {
            cam = cac;
          });
        } else {
          setState(() {
            cam = total;
          });
        }
      } else {
        cac = cac + ca;
        if (total > cac) {
          setState(() {
            cam = cac;
          });
        } else {
          setState(() {
            cam = total;
          });
        }
      }
    }
  }
}
