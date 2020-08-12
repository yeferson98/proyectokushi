import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/bloc/business.bloc.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/components/ProgressIndicator.dart';
import 'package:kushi/components/notification.dart';
import 'package:kushi/configs/config.select.sound.notification.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/pushproviders/push_notification_provider.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/notification.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/repository/user.respository.dart';
import 'package:kushi/user/ui/widgets/DrawerWidget.dart';
import 'package:kushi/user/ui/widgets/list.notification.dart';

// ignore: must_be_immutable
class NotificationsWidget extends StatefulWidget {
  UserModel user;
  Business business;
  NotificationsWidget({Key key, this.user, this.business}) : super(key: key);
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKeyProfile =
      GlobalKey<ScaffoldState>();
  UserRepository _serviceKushiAPI;
  Stream<List<NotificationModel>> notification;
  AnimationController animationController;
  Animation animationOpacity;
  @override
  void initState() {
    _serviceKushiAPI = Ioc.get<UserRepository>();
    getNotification();
    notificationUser();
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curve =  CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

  getNotification() async {
    notification = _serviceKushiAPI.listNotificationUser(widget.user.idCliente.toString());
  }

  void notificationUser() {
    final pushNotification = new PushNotificationProvider();
    pushNotification.initNotifications();
    pushNotification.mensaje.listen((data) {
      alertNotification(data);
      _actualizarServiceNotification();
    });
  }

  void alertNotification(String data) {
    sonidoNotification();
    _scaffoldKeyProfile.currentState.showSnackBar(
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
  }

  void showInSnackBar(String value) {
    _scaffoldKeyProfile.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      duration: Duration(milliseconds: 2000),
      content: Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyProfile,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _scaffoldKeyProfile.currentState.openDrawer(),
        ),
        elevation: 0,
        title: Text(
          'Notificaciones',
          style: Theme.of(context).textTheme.headline2,
        ),
        actions: <Widget>[
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
            ),
          ),
        ],
      ),
      drawer: BlocProvider(
        child: DrawerWidget(
          user: widget.user,
          inicioState: true,
          business: null,
        ),
        bloc: UserBloc(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 7),
        child: StreamBuilder(
          stream: notification,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Text('Error de red')],
                        )
                      ],
                    ),
                  ),
                );
              case ConnectionState.active:
                List<NotificationModel> notification = snapshot.data;
                final newListNotification = notification
                  ..sort((p1, p2) => p2.date.compareTo(p1.date));
                return BlocProvider(
                  child: NotificationList(
                    user: widget.user,
                    notification: newListNotification,
                    animationOpacity: animationOpacity,
                    onDismissed: (NotificationModel value) {
                      deleteUser(value);
                    },
                    onDismissedUpdated: (value) {
                      if (value == 0) {
                        _actualizarServiceNotification();
                      } else {}
                    },
                  ),
                  bloc: BusinessBloc(),
                );
              case ConnectionState.done:
                List<NotificationModel> notification = snapshot.data;
                final newListNotification = notification
                  ..sort((p1, p2) => p2.date.compareTo(p1.date));
                if (snapshot.data == null) {
                  return Center(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Text('Error de red')],
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return BlocProvider(
                    child: NotificationList(
                      user: widget.user,
                      notification: newListNotification,
                      animationOpacity: animationOpacity,
                      onDismissed: (NotificationModel value) {
                        deleteUser(value);
                      },
                      onDismissedUpdated: (value) {
                        if (value == 0) {
                          _actualizarServiceNotification();
                        } else {}
                      },
                    ),
                    bloc: BusinessBloc(),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  void _actualizarServiceNotification() {
    setState(() {
      notification = _serviceKushiAPI
          .listNotificationUser(widget.user.idCliente.toString());
    });
  }

  void deleteUser(NotificationModel item) {
    _serviceKushiAPI
        .deleteNotification(item, widget.user.idCliente.toString())
        .then(
      (value) {
        if (value == true) {
          showInSnackBar('Notificación eliminada');
          _actualizarServiceNotification();
        } else {
          showInSnackBar('No se pudo eliminar esta notificación');
          _actualizarServiceNotification();
        }
      },
    );
  }
}
