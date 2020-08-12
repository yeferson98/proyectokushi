import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/ui/screens/service.todorapid.dart';
import 'package:kushi/configs/ecosystem_explorer.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/widgets/DrawerWidget.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';

// ignore: must_be_immutable
class DashboardUser extends StatefulWidget {
  UserModel userdata;
  DashboardUser({Key key, this.userdata}) : super(key: key);
  @override
  _DashboardUserState createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser>
    with PortraitStatefulModeMixin<DashboardUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool stateButtom = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),
          elevation: 0,
          title: Text(
            'Kushi App',
            style: Theme.of(context).textTheme.headline3,
          ),
          actions: <Widget>[
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: AppBarNotificatios(
                user: widget.userdata,
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
                  backgroundImage: NetworkImage(widget.userdata.urlImage),
                ),
              ),
            ),
          ],
        ),
        drawer: BlocProvider(
          child: DrawerWidget(
            user: widget.userdata,
            inicioState: true,
            business: null,
          ),
          bloc: UserBloc(),
        ),
        body: ServiceKushi(
          userData: widget.userdata,
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
}
