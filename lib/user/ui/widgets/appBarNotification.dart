import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kushi/components/notification.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/pushproviders/push_notification_provider.dart';
import 'package:kushi/user/model/notification.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/repository/user.respository.dart';
import 'package:kushi/user/ui/screens/notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AppBarNotificatios extends StatefulWidget {
  UserModel user;
  GlobalKey<ScaffoldState> scaffoldKey;
  AppBarNotificatios({Key key, this.user, this.scaffoldKey});
  @override
  _AppBarNotificatiosState createState() => _AppBarNotificatiosState();
}

class _AppBarNotificatiosState extends State<AppBarNotificatios> {
  UserRepository _serviceKushiAPI;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  List<NotificationModel> notificaciones = new List<NotificationModel>();
  bool stausNotification = false;
  String messageAlert = "";
  int productCart = 0;
  @override
  void initState() {
    notification();
    _serviceKushiAPI = Ioc.get<UserRepository>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _serviceKushiAPI.listNotificationViewAllUserRepository(
          widget.user.idCliente.toString()),
      builder: (_, AsyncSnapshot<List<NotificationModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return InkWell(
            child: Stack(
              children: <Widget>[
                Icon(
                  UiIcons.bell,
                  size: 27,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                Positioned(
                  top: 0,
                  right: 1,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "0",
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle),
                  ),
                )
              ],
            ),
            onTap: () {
              //updateNotifcationView(snapshot.data);
            },
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          notificaciones = snapshot.data;
          return Consumer<InterceptApp>(
            builder: (context, InterceptApp value, Widget child) {
              productCart = value.lista().length;
              return InkWell(
                child: Stack(
                  children: <Widget>[
                    Icon(
                      UiIcons.bell,
                      size: 27,
                      color: Theme.of(context).accentColor.withOpacity(1),
                    ),
                    Positioned(
                      top: 0,
                      right: 1,
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "${snapshot.data.length}",
                          style: TextStyle(color: Colors.white, fontSize: 10.0),
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            shape: BoxShape.circle),
                      ),
                    )
                  ],
                ),
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
              );
            },
          );
        } else {
          notificaciones = [];
          return InkWell(
            child: Stack(
              children: <Widget>[
                Icon(
                  UiIcons.bell,
                  size: 27,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                Positioned(
                  top: 0,
                  right: 1,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "0",
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        shape: BoxShape.circle),
                  ),
                )
              ],
            ),
            onTap: () {
              updateNotifcationView(snapshot.data);
            },
          );
        }
      },
    );
  }

  void notification() {
    final pushNotification = new PushNotificationProvider();
    pushNotification.initNotifications();
    pushNotification.mensaje.listen((data) {
      if (data == 'Notification1998') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                NotificationsWidget(user: widget.user),
          ),
        );
      } else {
        messageAlert = data;
        stausNotification = false;
        setupNotificationPlugin();
        //alertNotification(data);
      }
    });
  }

  void setupNotificationPlugin() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin
        .initialize(initializationSettings,
            onSelectNotification: onSelectNotification)
        .then((int) {
      setupNotification();
      stausNotification = true;
    });
  }

  Future onSelectNotification(String payload) async {
    if (stausNotification == false) {
      print('sin datos');
    } else {
      stausNotification = false;
      if (productCart > 0) {
        _showAlertDialog(onPressed: () {
          Provider.of<InterceptApp>(context).removeAllProductCart();
          removeNotePreference();
          updateNotifcationView(notificaciones);
        });
      } else {
        updateNotifcationView(notificaciones);
      }
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    widget.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: NotificationContext(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    NotificationsWidget(user: widget.user),
              ),
            );
          },
          data: messageAlert,
        ),
        duration: Duration(milliseconds: 9000),
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void setupNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'Nueva Notificacion', messageAlert, platformChannelSpecifics,
        payload: 'ssdhksd');
  }

  /*void alertNotification(String data) {
    sonidoNotification();
    widget.scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: NotificationContext(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    NotificationsWidget(user: widget.user),
              ),
            );
          },
          data: data,
        ),
        duration: Duration(milliseconds: 9000),
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void sonidoNotification() {
    AudioCache player = new AudioCache();
    player.play(SOUND.doorbell);
  }*/

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
    _serviceKushiAPI
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

  void removeNotePreference() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('notePaymentUser');
  }
}
