import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kushi/bussiness/bloc/business.bloc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/screens/AddressUser.dart';
import 'package:kushi/user/ui/screens/AllowLocation.dart';
import 'package:kushi/user/ui/screens/dashboar.User.dart';

// ignore: must_be_immutable
class AccountWidget extends StatefulWidget {
  UserModel user;
  bool inicioState;
  AccountWidget({Key key, @required this.user, @required this.inicioState});
  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  UserBloc userBloc;
  bool cargandoAddrees = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.user.name,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      verifyEmail()
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                SizedBox(
                    width: 55,
                    height: 55,
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
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).hintColor.withOpacity(0.15),
                    offset: Offset(0, 3),
                    blurRadius: 10)
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    onPressed: () {
                      //Navigator.of(context).pushNamed('/Tabs', arguments: 4);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(UiIcons.heart),
                        Text(
                          'Pr. Favoritos',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    onPressed: () {
                      ///Navigator.of(context).pushNamed('/Tabs', arguments: 0);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(UiIcons.favorites),
                        Text(
                          'Em. Favoritas',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    onPressed: () {
                      Navigator.of(context).push(
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
                    child: Column(
                      children: <Widget>[
                        Icon(UiIcons.home),
                        Text(
                          'Inicio',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)
              ],
            ),
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                ListTile(
                  leading: Icon(UiIcons.inbox),
                  title: Text(
                    'Mis Ordenes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: ButtonTheme(
                    padding: EdgeInsets.all(0),
                    minWidth: 50.0,
                    height: 25.0,
                    child: FlatButton(
                      onPressed: () {
                        //Navigator.of(context).pushNamed('/Orders');
                      },
                      child: Text(
                        "Ver Todos",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                   /// Navigator.of(context).pushNamed('/Orders');
                  },
                  dense: true,
                  title: Text(
                    'No pagados',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Chip(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor)),
                    label: Text(
                      '1',
                      style: TextStyle(color: Theme.of(context).focusColor),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                  // Navigator.of(context).pushNamed('/Orders');
                  },
                  dense: true,
                  title: Text(
                    'Productos enviados',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Chip(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor)),
                    label: Text(
                      '3',
                      style: TextStyle(color: Theme.of(context).focusColor),
                    ),
                  ),
                ),
              ],
            ),
          ),*/
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).hintColor.withOpacity(0.15),
                    offset: Offset(0, 3),
                    blurRadius: 10)
              ],
            ),
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                ListTile(
                  leading: Icon(UiIcons.user_1),
                  title: Text(
                    'Mis Datos Personales',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  trailing: ButtonTheme(
                      padding: EdgeInsets.all(0),
                      minWidth: 50.0,
                      height: 25.0,
                      child: Text(
                          '') /*ProfileSettingsDialog(
                      user: widget.user,
                      onChanged: () {
                        setState(() {});
                      },
                    ),*/
                      ),
                ),
                ListTile(
                  onTap: () {},
                  dense: true,
                  title: Text(
                    'Nombre completo',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Text(
                    widget.user.name + ' ' + widget.user.lastname,
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ),
                ),
                verifyEmail2(),
                /*ListTile(
                  onTap: () {},
                  dense: true,
                  title: Text(
                    'Ciudad',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Text(
                    widget.user.ciudad,
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ),
                ),*/
                ListTile(
                  onTap: () {},
                  dense: true,
                  title: Text(
                    'Telefono',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: Text(
                    widget.user.phone,
                    style: TextStyle(color: Theme.of(context).focusColor),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).hintColor.withOpacity(0.15),
                    offset: Offset(0, 3),
                    blurRadius: 10)
              ],
            ),
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                ListTile(
                  leading: Icon(UiIcons.settings_1),
                  title: Text(
                    'Config. de cuenta',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                ListTile(
                  onTap: () {
                    verifyLocationActive();
                  },
                  dense: true,
                  title: Row(
                    children: <Widget>[
                      Icon(
                        UiIcons.placeholder,
                        size: 22,
                        color: Theme.of(context).focusColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Dirección de Envio',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                /*ListTile(
                  onTap: () {
                    //Navigator.of(context).pushNamed('/Help');
                  },
                  dense: true,
                  title: Row(
                    children: <Widget>[
                      Icon(
                        UiIcons.information,
                        size: 22,
                        color: Theme.of(context).focusColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Help & Support',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),*/
              ],
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
      return Container();
    } else {
      return Text(
        widget.user.email,
        style: Theme.of(context).textTheme.caption,
      );
    }
  }

  Widget verifyEmail2() {
    if (widget.user.email == null ||
        widget.user.email == "" ||
        widget.user.email == " ") {
      return Container();
    } else {
      return ListTile(
        onTap: () {},
        dense: true,
        title: Text(
          'Email',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: Text(
          widget.user.email,
          style: TextStyle(color: Theme.of(context).focusColor),
        ),
      );
    }
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
