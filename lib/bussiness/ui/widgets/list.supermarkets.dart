import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/shops/ui/screens/shop.List.Prod.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/screens/AddressUser.dart';
import 'package:kushi/user/ui/screens/AllowLocation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ItemSupermarket extends StatefulWidget {
  String heroTag;
  String query;
  Business supermarkets;
  UserModel userData;
  AnimationController animationController;
  Animation<dynamic> animation;
  ItemSupermarket({
    Key key,
    this.supermarkets,
    this.heroTag,
    this.userData,
    this.query,
    this.animationController,
    this.animation,
  }) : super(key: key);
  @override
  _ItemSupermarketState createState() => _ItemSupermarketState();
}

class _ItemSupermarketState extends State<ItemSupermarket> {
  ShopRepository _serviceTodoRapidAPI;
  bool cargandoAddrees = false;
  UserBloc userBloc;
  @override
  void initState() {
    _serviceTodoRapidAPI = Ioc.get<ShopRepository>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  queryAdrresClient(widget.supermarkets);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Center(
                                    child: Image.asset(
                                  'assets/img/loaderStock.gif',
                                  fit: BoxFit.cover,
                                )),
                                imageUrl: widget.supermarkets.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: Theme.of(context).primaryColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                text: (widget.supermarkets.name)
                                                    .substring(
                                                        0, widget.query.length),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline2
                                                    .merge(TextStyle(
                                                        color: Colors.black)),
                                                children: [
                                                  TextSpan(
                                                    text: (widget
                                                            .supermarkets.name)
                                                        .substring(widget
                                                            .query.length),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline2,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.location_city,
                                                  size: 12,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                Text(
                                                  widget.supermarkets.descCity,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey
                                                          .withOpacity(0.8)),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Icon(
                                                  Icons.location_on,
                                                  size: 12,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    widget.supermarkets.address,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey
                                                            .withOpacity(0.8)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        /*Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void queryAdrresClient(Business supermarkets) {
    _serviceTodoRapidAPI
        .getAddressClient(widget.userData.idCliente.toString())
        .then((value) {
      if (value.listAdrress.length > 0) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => new BlocProvider(
              child: ShopsProduct(
                supermarkets: widget.supermarkets,
                userData: widget.userData,
              ),
              bloc: ShopBloc(),
            ),
            transitionDuration: Duration(milliseconds: 950),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            },
          ),
        );
      } else {
        alertAddress(
            'Para ingresar a ${supermarkets.name}, debe de registrar su dirección');
      }
    });
  }

  void alertAddress(String message) {
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
                'Registrar Dirección',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.pop(context);
                verifyLocationActive();
              },
            ),
          ],
        );
      },
    );
  }

  void verifyLocationActive() async {
    setState(() => cargandoAddrees = true);
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        Future<void>.delayed(const Duration(seconds: 1))
          ..then<void>((_) {
            if (_preferences.containsKey('permissionLocation')) {
              userBloc.getLocationUser().then(
                (location) {
                  if (location.status == 'false') {
                    Navigator.pop(context);
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) {
                        Future<void>.delayed(const Duration(seconds: 1))
                          ..then<void>((_) {
                            userBloc.getAddress('', location, false).then(
                              (googlelocation) {
                                if (googlelocation.status == "errorQuery") {
                                  Navigator.pop(context);
                                  alert(
                                      'Kushi, no se pudo comunicar con google, verifique su conexión a internet');
                                } else {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BlocProvider(
                                        child: AddressWidget(
                                          user: widget.userData,
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
                          });
                        return Center(
                          child: Container(
                            width: 250.0,
                            height: 230.0,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: <Widget>[
                                Image.asset(
                                  "assets/img/loaderStock.gif",
                                  height: 150,
                                  width: 150,
                                ),
                                Text(
                                  "Terminando y redireccionando...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    Navigator.pop(context);
                    alert(
                        'Kushi, no pudo obtener su ubicación, verifique su conexión');
                  }
                },
              );
            } else {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider(
                    child: AllowLocation(
                      user: widget.userData,
                      inicioState: true,
                    ),
                    bloc: UserBloc(),
                  ),
                ),
              );
            }
          });
        return Center(
          child: Container(
            width: 250.0,
            height: 230.0,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/img/loaderStock.gif",
                  height: 150,
                  width: 150,
                ),
                Text(
                  "Preparando Entorno de Mapas",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: 15),
                )
              ],
            ),
          ),
        );
      },
    );
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
