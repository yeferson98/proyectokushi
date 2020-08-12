import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/ui/screens/wish.list.Product.dart';
import 'package:kushi/user/ui/screens/Login/login_screen.dart';
import 'package:kushi/user/ui/widgets/drawerItemNotification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kushi/bussiness/bloc/business.bloc.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/screens/AddressUser.dart';
import 'package:kushi/user/ui/screens/AllowLocation.dart';
import 'package:kushi/user/ui/screens/dashboar.User.dart';
import 'package:kushi/user/ui/screens/orders.dart';
import 'package:kushi/user/ui/screens/profileUser.dart';

// ignore: must_be_immutable
class DrawerWidget extends StatefulWidget {
  UserModel user;
  bool inicioState;
  Business business;
  DrawerWidget({Key key, this.user, this.inicioState, @required this.business})
      : super(key: key);
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  UserBloc userBloc;
  bool cargandoAddrees = false;
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              //Navigator.of(context).pushNamed('/Tabs', arguments: 1);
            },
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
              ),
              accountName: Text(
                widget.user.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              accountEmail: verifyEmail(),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                backgroundImage: NetworkImage(widget.user.urlImage),
              ),
            ),
          ),
          Consumer<InterceptApp>(
            builder: (context, InterceptApp value, Widget child) {
              return ListTile(
                onTap: () {
                  if (value.lista().length == 0) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          child: DashboardUser(
                            userdata: widget.user,
                          ),
                          bloc: BusinessBloc(),
                        ),
                      ),
                    );
                  } else if (value.lista().length > 0) {
                    _showAlertDialog(
                      onPressed: () {
                        Provider.of<InterceptApp>(context)
                            .removeAllProductCart();
                        removeNotePreference();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => BlocProvider(
                              child: DashboardUser(
                                userdata: widget.user,
                              ),
                              bloc: BusinessBloc(),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          child: DashboardUser(
                            userdata: widget.user,
                          ),
                          bloc: BusinessBloc(),
                        ),
                      ),
                    );
                  }
                },
                leading: Icon(
                  UiIcons.home,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                title: Text(
                  "Inicio",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              );
            },
          ),
          NotificationItem(
            user: widget.user,
          ),
          Consumer<InterceptApp>(
            builder: (context, InterceptApp value, Widget child) {
              return ListTile(
                onTap: () {
                  if (value.lista().length == 0) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          child: ProfileUser(user: widget.user),
                          bloc: UserBloc(),
                        ),
                      ),
                    );
                  } else {
                    _showAlertDialog(onPressed: () {
                      Provider.of<InterceptApp>(context).removeAllProductCart();
                      removeNotePreference();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => BlocProvider(
                            child: ProfileUser(user: widget.user),
                            bloc: UserBloc(),
                          ),
                        ),
                      );
                    });
                  }
                },
                leading: Icon(
                  UiIcons.user_1,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                title: Text(
                  "Mi perfil",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              );
            },
          ),
          Consumer<InterceptApp>(
            builder: (context, InterceptApp value, Widget child) {
              return ListTile(
                onTap: () {
                  if (value.lista().length == 0) {
                    verifyLocationActive();
                  } else {
                    _showAlertDialog(
                      onPressed: () {
                        Provider.of<InterceptApp>(context)
                            .removeAllProductCart();
                        removeNotePreference();
                        verifyLocationActive();
                      },
                    );
                  }
                },
                leading: Icon(
                  Icons.location_on,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                title: !cargandoAddrees
                    ? Text(
                        "Dirección",
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    : Row(
                        children: <Widget>[
                          Text('Preparando entorno'),
                          SizedBox(
                            width: 5,
                          ),
                          CupertinoActivityIndicator()
                        ],
                      ),
              );
            },
          ),
          Consumer<InterceptApp>(
            builder: (context, InterceptApp value, Widget child) {
              return ListTile(
                onTap: () {
                  if (value.lista().length == 0) {
                    navigationOrderClient();
                  } else {
                    _showAlertDialog(
                      onPressed: () {
                        Provider.of<InterceptApp>(context)
                            .removeAllProductCart();
                        removeNotePreference();
                        navigationOrderClient();
                      },
                    );
                  }
                },
                leading: Icon(
                  UiIcons.inbox,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                title: Text(
                  "Mis ordenes",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              );
            },
          ),
          !widget.inicioState
              ? ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          child: WishList(
                            supermarkets: widget.business,
                            userData: widget.user,
                          ),
                          bloc: ShopBloc(),
                        ),
                      ),
                    );
                  },
                  leading: Icon(
                    UiIcons.heart,
                    color: Theme.of(context).accentColor.withOpacity(1),
                  ),
                  title: Text(
                    "Lista de deseos",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )
              : Container(),
          ListTile(
            dense: true,
            title: Text(
              "Mis preferencias",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).accentColor.withOpacity(0.3),
            ),
          ),
          /*ListTile(
            onTap: () {
              //Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(
              UiIcons.information,
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              "Ayuda & Soporte",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),*/
          Consumer<InterceptApp>(
            builder: (context, InterceptApp value, Widget child) {
              return ListTile(
                onTap: () {
                  if (value.lista().length == 0) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          child: ProfileUser(user: widget.user),
                          bloc: UserBloc(),
                        ),
                      ),
                    );
                  } else {
                    _showAlertDialog(onPressed: () {
                      Provider.of<InterceptApp>(context).removeAllProductCart();
                      removeNotePreference();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => BlocProvider(
                            child: ProfileUser(user: widget.user),
                            bloc: UserBloc(),
                          ),
                        ),
                      );
                    });
                  }
                },
                leading: Icon(
                  UiIcons.settings_1,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                title: Text(
                  "Configuración",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              );
            },
          ),
          ListTile(
            onTap: () {
              alertInfo(widget.user);
            },
            leading: Icon(
              UiIcons.upload,
              color: Theme.of(context).accentColor.withOpacity(1),
            ),
            title: Text(
              "Log out",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              "Versión. 1.1.5",
              style: Theme.of(context).textTheme.bodyText1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).accentColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget verifyEmail() {
    if (widget.user.email == null ||
        widget.user.email == "" ||
        widget.user.email == " ") {
      return Text('');
    } else {
      return Text(
        widget.user.email,
        style: Theme.of(context).textTheme.caption,
      );
    }
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

  void alertInfo(UserModel user) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return CupertinoAlertDialog(
            title: Text(
              user.name.toUpperCase(),
              style: Theme.of(context).textTheme.headline3,
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '¿Seguro que desea cerrar sesión?',
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .merge(TextStyle(fontSize: 14)),
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  'SI',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                onPressed: () async {
                  SharedPreferences _preferences =
                      await SharedPreferences.getInstance();
                  Provider.of<InterceptApp>(context).singUpPrev();
                  _preferences.remove('isLoggedInUser');
                  _preferences.remove('phone');
                  _preferences.remove('Token');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        child: LoginScreen(),
                        bloc: UserBloc(),
                      ),
                    ),
                  );
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
        });
  }

  void verifyLocationActive() async {
    setState(() => cargandoAddrees = true);
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey('permissionLocation')) {
      userBloc.getLocationUser().then(
        (location) {
          if (location.status == 'false') {
            userBloc.getAddress('', location, false).then(
              (googlelocation) {
                setState(() => cargandoAddrees = false);
                Navigator.pop(context);
                if (googlelocation.status == "errorQuery") {
                  setState(() => cargandoAddrees = false);
                  alert(
                      'Kushi, no se pudo comunicar con google, verifique su conexión a internet');
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        child: AddressWidget(
                          user: widget.user,
                          inicioState: widget.inicioState,
                          userLocation: location,
                          adrresGoogle: googlelocation,
                        ),
                        bloc: UserBloc(),
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            setState(() => cargandoAddrees = false);
            alert('Kushi, no pudo obtener su ubicación, verifique su internet');
          }
        },
      );
    } else {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: AllowLocation(
              user: widget.user,
              inicioState: widget.inicioState,
            ),
            bloc: UserBloc(),
          ),
        ),
      );
    }
  }

  void alert(String message) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void navigationOrderClient() {
    if (widget.inicioState == true) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => OrdersWidget(
              currentTab: 0,
              user: widget.user,
              stateNavigator: 0,
              bussines: widget.business)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => OrdersWidget(
              currentTab: 0,
              user: widget.user,
              stateNavigator: 1,
              bussines: widget.business)));
    }
  }

  void removeNotePreference() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('notePaymentUser');
  }
}
