import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/repository/business.respository.dart';
import 'package:kushi/user/model/map.google.model.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kushi/bussiness/bloc/business.bloc.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/ui/screens/supermarkets.body.dart';
import 'package:kushi/components/ProgressIndicator.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:wakelock/wakelock.dart';

// ignore: must_be_immutable
class ServiceKushi extends StatefulWidget {
  UserModel userData;
  ServiceKushi({Key key, this.userData}) : super(key: key);
  @override
  _ServiceKushiState createState() => _ServiceKushiState();
}

class _ServiceKushiState extends State<ServiceKushi>
    with SingleTickerProviderStateMixin {
  SharedPreferences _preferences;
  List<Business> _supermarketsFilterList;
  Future<List<Business>> business;
  AnimationController animationController;
  Animation animationOpacity;
  BusinessBloc businessBloc;
  BusinessRepository _serviceTodoRapidAPI;
  GlobalKey<RefreshIndicatorState> refreshKeyBusiness;
  @override
  void initState() {
    _serviceTodoRapidAPI = Ioc.get<BusinessRepository>();
    super.initState();
    getBusiness();
    removeCupon();
    //getAdrressGogle();
    animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

  getAdrressGogle() async {
    AdrresGoogle result;
    //result= await _serviceTodoRapidAPI.getAddressRepository();
    String nombre = result.googlemap[0].addressComponets[3].shortName +
        ',' +
        result.googlemap[0].addressComponets[2].longName;
    double latY = result.googlemap[0].geometry.location.latY;
    double longX = result.googlemap[0].geometry.location.longX;

    print('Direccion: ' + nombre);
    print('Latitud: ' + latY.toString());
    print('Longitud: ' + longX.toString());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    businessBloc = BlocProvider.of(context);
    return RefreshIndicator(
      key: refreshKeyBusiness,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FutureBuilder(
                    future: business,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data == null) {
                          return Center(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Text('Revisa tu conexión a internet'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.refresh),
                                          onPressed: () {
                                            _actualizarServiceBusiness();
                                          }),
                                      Text('Reintentar')
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          _supermarketsFilterList = snapshot.data;

                          return SupermarketsBody(
                            userDataGet: widget.userData,
                            animationOpacity: animationOpacity,
                            supermarkets: _supermarketsFilterList,
                          );
                        }
                      } else {
                        return CupertinoProgressIndicator();
                      }
                    }),
              )
            ],
          ),
        ),
      ),
      onRefresh: () {
        return Future<void>.delayed(const Duration(seconds: 2))
          ..then<void>((_) {
            if (mounted) {
              _actualizarServiceBusiness();
            }
          });
      },
    );
  }

  void _actualizarServiceBusiness() {
    try {
      setState(() {
        business = _serviceTodoRapidAPI
            .fetchBusinesRepository(widget.userData.idCliente.toString());
      });
    } catch (e) {
      print(e);
    }
  }

  getBusiness() async {
    business = _serviceTodoRapidAPI
        .fetchBusinesRepository(widget.userData.idCliente.toString());
    Future<void>.delayed(const Duration(seconds: 2))
      ..then<void>(
        (_) {
          if (mounted) {
            businessBloc.wakelock().then((value) {
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

  void removeCupon() async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.remove('cupon');
  }
}
