import 'package:flutter/material.dart';
import 'package:kushi/bussiness/ui/widgets/SearchBarWidget.dart';
import 'package:kushi/user/model/notification.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/widgets/EmptyNotificationsWidget.dart';
import 'package:kushi/user/ui/widgets/NotificationItemWidget.dart';
import 'package:kushi/utils/utils.paginacion.list.dart';

// ignore: must_be_immutable
class NotificationList extends StatefulWidget {
  List<NotificationModel> notification;
  Animation animationOpacity;
  UserModel user;
  ValueChanged<NotificationModel> onDismissed;
  ValueChanged<int> onDismissedUpdated;
  NotificationList(
      {Key key,
      @required this.notification,
      this.user,
      this.animationOpacity,
      @required this.onDismissed,
      @required this.onDismissedUpdated});
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>
    with SingleTickerProviderStateMixin {
  List<NotificationModel> listFilterNotofication =
      new List<NotificationModel>();
  AnimationController animationController;
  Animation animationOpacity;
  String query = "";
  bool endList = true;
  int ca = PaginacionMostrar.cantidad_paginacion_notificaciones;
  int cmi = PaginacionMostrar.cantidad_inicial_a_mostar_notificaciones;
  int cac = 0;
  int cam = 0;
  @override
  void initState() {
    listFilterNotofication = widget.notification;
    function();
    animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBarWidget(
            onChanged: (text) {
              setState(() {
                query = text;
                cam = 0;
                cac = 0;
                endList = true;
                listFilterNotofication = widget.notification
                    .where((p) => p.bussines.toLowerCase().startsWith(text))
                    .toList();
                function();
              });
            },
          ),
        ),
        Offstage(
            offstage: listFilterNotofication.isEmpty,
            child: itemListNotification()),
        Offstage(
          offstage: listFilterNotofication.isNotEmpty,
          child: EmptyNotificationsWidget(
            user: widget.user,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        butonItemsAdd(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget butonItemsAdd() {
    if (listFilterNotofication.length > cmi) {
      return endList
          ? InkWell(
              child: Text(
                'Mostrar más',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                function();
              },
            )
          : Text('Fin de la lista');
    } else {
      return Container();
    }
  }

  Widget itemListNotification() {
    if (listFilterNotofication.length > 0) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 15),
        shrinkWrap: true,
        primary: false,
        itemCount: cam,
        separatorBuilder: (context, index) {
          return SizedBox(height: 7);
        },
        itemBuilder: (context, index) {
          NotificationModel notification =
              listFilterNotofication.elementAt(index);
          final int count = cam > 10 ? 10 : cam;
          final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / count) * index, 1.0,
                  curve: Curves.fastOutSlowIn),
            ),
          );
          return NotificationItemWidget(
            animation: animation,
            animationController: animationController,
            notification: notification,
            user: widget.user,
            query: query,
            onDismissedUpdated: (value) {
              widget.onDismissedUpdated(value);
            },
            onDismissed: (notification) {
              widget.onDismissed(notification);
            },
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

  void function() async {
    int total = listFilterNotofication.length;
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

  void checkListNotification() {
    if (listFilterNotofication.length == 0) {
      listFilterNotofication = widget.notification;
    }
  }
}
