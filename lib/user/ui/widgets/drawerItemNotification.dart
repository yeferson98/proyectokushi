import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/user/model/notification.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/repository/user.respository.dart';
import 'package:kushi/user/ui/screens/notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class NotificationItem extends StatefulWidget {
  UserModel user;
  NotificationItem({Key key, this.user});
  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  UserRepository serviceKushiAPI;
  @override
  void initState() {
    serviceKushiAPI = Ioc.get<UserRepository>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: serviceKushiAPI.listNotificationViewAllUserRepository(
          widget.user.idCliente.toString()),
      builder: (_, AsyncSnapshot<List<NotificationModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.connectionState == ConnectionState.active) {
          return Consumer<InterceptApp>(
            builder: (context, InterceptApp value, Widget child) {
              return ListTile(
                onTap: () {
                  if (value.lista().length == 0) {
                    updateNotifcationView(snapshot.data);
                  } else {
                    _showAlertDialog(
                      onPressed: () {
                        Provider.of<InterceptApp>(context)
                            .removeAllProductCart();
                        removeNotePreference();
                        updateNotifcationView(snapshot.data);
                      },
                    );
                  }
                },
                leading: Icon(
                  UiIcons.bell,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                title: Text(
                  "Notificaciones",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                trailing: Chip(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                      side: BorderSide(color: Theme.of(context).focusColor)),
                  label: Text(
                    '${snapshot.data.length}',
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ),
                ),
              );
            },
          );
        } else {
          return Consumer<InterceptApp>(
            builder: (context, InterceptApp value, Widget child) {
              return ListTile(
                onTap: () {
                  if (value.lista().length == 0) {
                    updateNotifcationView(snapshot.data);
                  } else {
                    _showAlertDialog(
                      onPressed: () {
                        Provider.of<InterceptApp>(context)
                            .removeAllProductCart();
                        removeNotePreference();
                        updateNotifcationView(snapshot.data);
                      },
                    );
                  }
                },
                leading: Icon(
                  UiIcons.bell,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                title: Text(
                  "Notificaciones",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                trailing: Chip(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  backgroundColor: Colors.transparent,
                  shape: StadiumBorder(
                      side: BorderSide(color: Theme.of(context).focusColor)),
                  label: Text(
                    '${snapshot.data.length}',
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void updateNotifcationView(List<NotificationModel> data) {
    if (data.length > 0) {
      for (var items in data) {
        runUpdatedNotification(items);
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              NotificationsWidget(user: widget.user),
        ),
      );
    }
  }

  void removeNotePreference() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('notePaymentUser');
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
    newmodel.view = 1;
    newmodel.viewItem = model.viewItem;
    newmodel.typeNotification = model.typeNotification;
    newmodel.sound = model.sound;
    newmodel.name = model.name;
    serviceKushiAPI
        .updatedNotiicationViewAll(newmodel, widget.user.idCliente.toString())
        .then(
      (value) {
        if (value == true) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  NotificationsWidget(user: widget.user),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  NotificationsWidget(user: widget.user),
            ),
          );
        }
      },
    );
  }

  void _showAlertDialog({VoidCallback onPressed}) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            '¡' +
                'Hay productos en el carrito de esta tienda y se eliminaran, ya que no puede comprar otros productos que no sea de aquí.',
            style: TextStyle(fontSize: 12),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('¿Seguro que desea salir?'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'SI',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: onPressed,
            ),
            CupertinoDialogAction(
              child: Text(
                'NO',
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
