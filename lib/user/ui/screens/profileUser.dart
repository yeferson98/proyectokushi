import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';
import 'package:wakelock/wakelock.dart';

import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/widgets/DrawerWidget.dart';
import 'package:kushi/user/ui/widgets/account.dart';

// ignore: must_be_immutable
class ProfileUser extends StatefulWidget {
  UserModel user;
  ProfileUser({
    Key key,
    this.user,
  }) : super(key: key);
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final GlobalKey<ScaffoldState> _scaffoldKeyProfile =
      GlobalKey<ScaffoldState>();
  UserBloc userBloc;
  @override
  void initState() {
    super.initState();
    verifyWA();
  }

  verifyWA() {
    Future<void>.delayed(const Duration(seconds: 2))
      ..then<void>(
        (_) {
          if (mounted) {
            userBloc.wakelock().then((value) {
              if (value == true) {
                setState(() {
                  Wakelock.disable();
                });
              }
            });
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
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
          'Mi Perfil',
          style: Theme.of(context).textTheme.headline2,
        ),
        actions: <Widget>[
          Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
            child: AppBarNotificatios(
              user: widget.user,
              scaffoldKey: _scaffoldKeyProfile,
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
      body: AccountWidget(
        user: widget.user,
        inicioState: true,
      ),
    );
  }
}
