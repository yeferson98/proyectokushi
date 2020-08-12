import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/ui/screens/AddressUser.dart';

// ignore: must_be_immutable
class AllowLocation extends StatefulWidget {
  UserModel user;
  bool inicioState;
  AllowLocation({
    Key key,
    @required this.user,
    @required this.inicioState,
  });

  @override
  _AllowLocationState createState() => _AllowLocationState();
}

class _AllowLocationState extends State<AllowLocation> {
  UserBloc userBloc;
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: const EdgeInsets.only(top: 140.0),
          child: FloatingActionButton(
            elevation: 10,
            child: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.user.urlImage),
                    radius: 110,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 90,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(50),
                    child: RichText(
                      text: TextSpan(
                        text: "Habilitar Ubicación",
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .merge(TextStyle(fontSize: 30)),
                        children: [
                          TextSpan(
                              text:
                                  """\nHabilite su ubicación para continuar navegando en KUSHI APP""",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 18)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: FlatButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.arrow_drop_down),
                      label: Text("Habilitar")),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Theme.of(context).accentColor.withOpacity(.5),
                                Theme.of(context).accentColor.withOpacity(.8),
                                Theme.of(context).accentColor,
                                Theme.of(context).accentColor
                              ])),
                      height: MediaQuery.of(context).size.height * .065,
                      width: MediaQuery.of(context).size.width * .75,
                      child: Center(
                          child: Text(
                        "Habilitar",
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ))),
                  onTap: () {
                    permissionUserLocation();
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void permissionUserLocation() {
    userBloc.getLocationUser().then(
      (location) {
        if (location.status == 'false') {
          userBloc.getAddress('', location, false).then(
            (value) {
              if (value.status == "errorQuery") {
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
                        adrresGoogle: value,
                      ),
                      bloc: UserBloc(),
                    ),
                  ),
                );
              }
            },
          );
        } else {
          alert('Kushi, no pudo obtener su ubicación, verifique su internet');
        }
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
