import 'dart:io';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/user/ui/screens/AddressUser.dart';
import 'package:kushi/user/ui/screens/AllowLocation.dart';
import 'package:kushi/user/ui/screens/Login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kushi/animations/FadeAnimatios.dart';
import 'package:kushi/bussiness/bloc/business.bloc.dart';
import 'dart:async';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/result.reg.user.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/screens/dashboar.User.dart';
import 'package:wakelock/wakelock.dart';

import 'configs/intercept.App.dart';

// ignore: must_be_immutable
class SplashKushi extends StatefulWidget {
  bool isLoggedIn;
  SplashKushi({Key key, this.isLoggedIn}) : super(key: key);
  @override
  _SplashKushiState createState() => _SplashKushiState();
}

class _SplashKushiState extends State<SplashKushi> {
  UserBloc userBloc;
  bool isconection = true;
  bool isreconnecting = true;
  String messageStatus = "";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      _homeAtuhUserKushi(widget.isLoggedIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: isconection ? _logo() : reconectando()),
    );
  }

  Widget _logo() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(
              1,
              Container(
                width: 200,
                child: Image(
                  image: AssetImage('assets/img/kushilogo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            FadeAnimation(
              1,
              Text(
                messageStatus,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .merge(TextStyle(color: Colors.orangeAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _homeAtuhUserKushi(bool status) async {
    try {
      setState(() {
        messageStatus = "Iniciando kushi...";
      });
      if (status) {
        SharedPreferences _preferences = await SharedPreferences.getInstance();
        String phone = _preferences.getString('phone');
        userBloc.verifyUserExistBloc(phone).then((value) {
          if (value.status == null) {
            if (value.register == true) {
              userBloc
                  .getqueryResultUserBloc(phone)
                  .then((ResultRegUser userRegExist) {
                _preferences.setString('Token', userRegExist.token);
                userBloc
                    .getuserUserBloc(userRegExist, phone)
                    .then((UserModel user) {
                  if (userRegExist.error == null) {
                    setState(() => isreconnecting = true);
                    setState(() => isconection = false);
                    // reconectando();
                  } else {
                    if (userRegExist.error == true) {
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
                      //_preferences.remove('isLoggedInUser');
                    } else {
                      userBloc.wakelock().then((value) {
                        if (value == true) {
                          setState(() {
                            Wakelock.disable();
                          });
                        }
                      });
                      userBloc
                          .getAddressClient(user.idCliente.toString())
                          .then((value) {
                        if (value.status == 404 ||
                            value.status == 500 ||
                            value.status == 422) {
                          setState(() => isreconnecting = true);
                          setState(() => isconection = false);
                        } else {
                          if (value.listAdrress.length > 0) {
                            userBloc.getTokenNotification().then((token) => {
                                  userBloc
                                      .updatedTokenNotificationBloc(
                                          user.idCliente.toString(),
                                          token,
                                          userRegExist.token)
                                      .then((response) {
                                    if (response == 401 ||
                                        response == 500 ||
                                        response == 403) {
                                      setState(() => isreconnecting = true);
                                      setState(() => isconection = false);
                                    } else if (response == 200) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              BlocProvider(
                                            child:
                                                DashboardUser(userdata: user),
                                            bloc: BusinessBloc(),
                                          ),
                                        ),
                                      );
                                    }
                                  })
                                });
                          } else {
                            verifyLocationActive(user);
                          }
                        }
                      });
                    }
                  }
                });
              });
            } else {
              //==============================Redireccion exitosa al la vista de empresas
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider(
                    child: LoginScreen(),
                    bloc: UserBloc(),
                  ),
                ),
              );
              //==========END=========
            }
          } else if (value.status == 404) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => BlocProvider(
                  child: LoginScreen(),
                  bloc: UserBloc(),
                ),
              ),
            );
          } else {
            setState(() => isreconnecting = true);
            setState(() => isconection = false);
          }
        });
      } else {
        userBloc.wakelock().then((value) {
          if (value == true) {
            setState(() {
              Wakelock.disable();
            });
          }
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider(
                    child: LoginScreen(),
                    bloc: UserBloc(),
                  )),
        );
      }
    } on SocketException {
      print('Error  de conexiion');
    }
  }

  Widget reconectando() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isreconnecting
                ? Container(
                    width: 100,
                    child: Image(
                      image: AssetImage('assets/img/noConnection.png'),
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 100,
                    height: 150,
                    child: Image(
                      image: AssetImage('assets/img/gifconnection.gif'),
                      fit: BoxFit.cover,
                    ),
                  ),
            SizedBox(
              height: 6,
            ),
            Flexible(
              child: Text('Error de red, verifique su conexión a internet'),
            ),
            SizedBox(
              height: 20,
            ),
            isreconnecting
                ? SizedBox(
                    width: 320,
                    child: FlatButton(
                      onPressed: () {
                        setState(() => isreconnecting = false);
                        _homeAtuhUserKushi(widget.isLoggedIn);
                      },
                      padding: EdgeInsets.symmetric(vertical: 14),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Reintentar',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void verifyLocationActive(UserModel user) async {
    setState(() {
      messageStatus = "Accediendo a google...";
    });
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey('permissionLocation')) {
      userBloc.getLocationUser().then(
        (location) {
          if (location.status == 'false') {
            userBloc.getAddress('', location, false).then(
              (googlelocation) {
                setState(() {
                  messageStatus = "Cargando Mapa...";
                });
                if (googlelocation.status == "errorQuery") {
                  setState(() => isreconnecting = true);
                  setState(() => isconection = false);
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BlocProvider(
                        child: AddressWidget(
                          user: user,
                          inicioState: true,
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
            setState(() => isreconnecting = true);
            setState(() => isconection = false);
          }
        },
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: AllowLocation(
              user: user,
              inicioState: true,
            ),
            bloc: UserBloc(),
          ),
        ),
      );
    }
  }
}
