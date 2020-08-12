import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/bloc/business.bloc.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/address.client.model.dart';
import 'package:kushi/user/model/map.google.model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/user/model/model.google/user.location.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/repository/user.respository.dart';
import 'package:kushi/user/ui/screens/dashboar.User.dart';
import 'package:kushi/user/ui/widgets/DrawerWidget.dart';
import 'package:kushi/user/ui/widgets/FilterWidget.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';
import 'package:wakelock/wakelock.dart';

// ignore: must_be_immutable
class AddressWidget extends StatefulWidget {
  UserModel user;
  bool inicioState;
  UserLocation userLocation;
  AdrresGoogle adrresGoogle;
  AddressWidget(
      {Key key,
      @required this.user,
      @required this.inicioState,
      @required this.userLocation,
      @required this.adrresGoogle});
  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKeyAddress =
      GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyFormDialog = GlobalKey<FormState>();
  double latititud;
  double longitud;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center;
  final Set<Marker> _marker = {};
  //final CameraPosition _initialPosition =CameraPosition(target: LatLng(-8.099843099999999, -79.0200377),zoom: 18.0);
  TextEditingController _addressController;
  List<AddressClient> listAdreesClient;
  LatLng _lastMapPosition;
  AddressSeach adressmodelserach;
  UserBloc userBloc;
  AddressClient addressSaveFrom;
  AdrresGoogle dataGoogleMap;
  UserRepository _serviceUserRepository;
  AddressCoponents departamento;
  AddressCoponents provincia;
  AddressCoponents distrito;
  List<Results> googlemapList;
  bool searchStatusAddrress = true;
  _oncreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  void initState() {
    _serviceUserRepository = Ioc.get<UserRepository>();
    getlistAdreesClient();
    adressmodelserach = AddressSeach();
    addressSaveFrom = AddressClient();
    super.initState();
    setdateMap();
  }

  void showInSnackBar(String value) {
    _scaffoldKeyAddress.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      duration: Duration(milliseconds: 8000),
      content: Text(value),
    ));
  }

  void setdateMap() {
    if (widget.adrresGoogle.googlemap.length == 0 ||
        widget.adrresGoogle.googlemap == null) {
      showInSnackBar(
          'Error al consultar dirección, revice su conexión de internet o verifique su dirección');
    } else {
      Wakelock.enable();
      dataGoogleMap = widget.adrresGoogle;
      double laty = widget.adrresGoogle.googlemap[0].geometry.location.latY;
      double longx = widget.adrresGoogle.googlemap[0].geometry.location.longX;
      _oncargaLocation(
        'Mi ubicación',
        widget.adrresGoogle.googlemap[0].direccionformateada,
      );
      getDataRefresh(laty, longx);
      _goToPositionRefresh(laty, longx);
    }
  }

  getDataRefresh(double lat, double long) {
    setState(() {
      latititud = lat;
      longitud = long;
      _center = LatLng(latititud, longitud);
      _lastMapPosition = _center;
    });
  }

  _oncargaLocation(String data1, String data2) {
    Future<void>.delayed(const Duration(seconds: 2))
      ..then<void>((_) {
        _marker.clear();
        setState(() {
          _marker.add(Marker(
            markerId: MarkerId(_lastMapPosition.toString()),
            position: _lastMapPosition,
            infoWindow: InfoWindow(
              title: data1,
              snippet: data2,
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKeyAddress,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: drawerBar(),
          elevation: 0,
          title: Text(
            'Mis direcciones',
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: <Widget>[
            valueNotification(),
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
        endDrawer: FilterWidget(
          googlemap: googlemapList,
          user: widget.user,
          onChanged: (Results value) {
            upLocationAddressSave(value);
          },
        ),
        body: FutureBuilder(
          future: Wakelock.isEnabled,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) return Container();

            return Stack(
              children: <Widget>[
                _builGoogledMap(context),
                _serchAddress(),
                butonsAction(),
                _buildContainer()
              ],
            );
          },
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

  Widget valueNotification() {
    if (listAdreesClient == null) {
      return Container();
    } else {
      if (listAdreesClient.length > 0) {
        return Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
          child: AppBarNotificatios(
            user: widget.user,
            scaffoldKey: _scaffoldKeyAddress,
          ),
        );
      } else {
        return Container();
      }
    }
  }

  Widget drawerBar() {
    if (listAdreesClient == null) {
      return Container();
    } else {
      if (listAdreesClient.length > 0) {
        return new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _scaffoldKeyAddress.currentState.openDrawer(),
        );
      } else {
        return Icon(Icons.location_on, color: Theme.of(context).hintColor);
      }
    }
  }

  Widget _builGoogledMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: _center, zoom: 18.0),
        mapType: MapType.normal,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        markers: _marker,
        onCameraMove: _onCameraMove,
        onMapCreated: _oncreated,
      ),
    );
  }

  Widget _serchAddress() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.10),
                      offset: Offset(0, 4),
                      blurRadius: 10)
                ],
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  TextFormField(
                    controller: _addressController,
                    onSaved: (value) => adressmodelserach.address = value,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'Av. tu calle 145, mi distrito',
                      hintStyle: TextStyle(
                          color: Theme.of(context).focusColor.withOpacity(0.8)),
                      prefixIcon: Icon(UiIcons.loupe,
                          size: 20, color: Theme.of(context).hintColor),
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  searchStatusAddrress
                      ? IconButton(
                          onPressed: () {
                            getAdrees();
                          },
                          icon: Icon(Icons.send,
                              size: 20,
                              color:
                                  Theme.of(context).hintColor.withOpacity(0.8)),
                        )
                      : Container(
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.all(10),
                          child: CircularProgressIndicator(),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer() {
    if (listAdreesClient == null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Text('Cargando..'),
      );
    } else {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 23.0),
          height: 150.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: listAdreesClient.length,
            separatorBuilder: (context, index) {
              return SizedBox(width: 16);
            },
            itemBuilder: (context, index) {
              AddressClient adresItem = listAdreesClient.elementAt(index);
              return _boxes(adresItem);
            },
          ),
        ),
      );
    }
  }

  Widget _boxes(AddressClient item) {
    return GestureDetector(
      onTap: () {
        _goToPositionRefresh(
            double.parse(item.latitud), double.parse(item.longitud));
        _oncargaLocation(item.nameAdrres, item.address);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  imagevaluePreference(item),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailContainerAddress(item),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget imagevaluePreference(AddressClient item) {
    if (item.predeterminada == "0") {
      return Container(
        width: 180,
        height: 200,
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(24.0),
          child: Image(
            fit: BoxFit.fill,
            image: AssetImage('assets/img/mylocations.png'),
          ),
        ),
      );
    } else {
      return Container(
        width: 180,
        height: 200,
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(24.0),
          child: Image(
            fit: BoxFit.fill,
            image: AssetImage('assets/img/locationOn.png'),
          ),
        ),
      );
    }
  }

  Widget myDetailContainerAddress(AddressClient item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              width: 210,
              child: Text(
                item.address,
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Ubicación: " + item.nameAdrres,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        )),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              valueButtonPreference(item),
              RawMaterialButton(
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                shape: CircleBorder(),
                elevation: 2,
                splashColor: Colors.transparent,
                fillColor: Colors.redAccent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  alertInfodeleteAddress(item.id.toString());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget valueButtonPreference(AddressClient item) {
    if (item.predeterminada == "0") {
      return RawMaterialButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        elevation: 3,
        splashColor: Colors.transparent,
        fillColor: Theme.of(context).primaryColorDark,
        highlightColor: Colors.transparent,
        onPressed: () {
          alertAddPreferenceAddressClient(
              widget.user.idCliente.toString(), item.id.toString());
        },
      );
    } else {
      return RawMaterialButton(
        child: Icon(
          Icons.location_on,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        elevation: 3,
        splashColor: Colors.transparent,
        fillColor: Theme.of(context).primaryColorDark,
        highlightColor: Colors.transparent,
        onPressed: () {
          showInSnackBar('Esta es tu direccion que te llegara tus pedidos');
        },
      );
    }
  }

  Widget butonsAction() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(top: 80, right: 0),
        child: Column(
          children: <Widget>[
            RawMaterialButton(
              child: Icon(
                Icons.add_location,
                color: Colors.white,
              ),
              shape: CircleBorder(),
              elevation: 2,
              splashColor: Colors.transparent,
              fillColor: Theme.of(context).accentColor,
              highlightColor: Colors.transparent,
              onPressed: () {
                _formKey.currentState.reset();
                ubicationUserRealTime();
              },
            ),
            RawMaterialButton(
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              shape: CircleBorder(),
              elevation: 2,
              splashColor: Colors.transparent,
              fillColor: Theme.of(context).accentColor,
              highlightColor: Colors.transparent,
              onPressed: () {
                Wakelock.disable();
                if (listAdreesClient.length > 0) {
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
                } else {
                  showInSnackBar(
                      'Es necesario contar con al menos una dirección registrada \n para salir a la lista de empresas.');
                }
              },
            ),
            RawMaterialButton(
              child: Icon(
                Icons.help,
                color: Colors.white,
              ),
              shape: CircleBorder(),
              elevation: 2,
              splashColor: Colors.transparent,
              fillColor: Theme.of(context).accentColor,
              highlightColor: Colors.transparent,
              onPressed: () {
                showInSnackBar(
                    '-Dos fromas para localizar una dirección: \n  1.- Ingrese dirección \n *Escribir Dirección  según formato (Av. Tu Calle 100, Mi Distrito). \n *Click en (>).\n 2.- Click en botón buscar ubicación (2º Botón) \n -Después de localizar la dirección: \n *Click en guardar (Primer Botón) \n *Ingresar Datos, Click en guardar.');
              },
            ),
            //button(_prubea, Icons.add_location)
          ],
        ),
      ),
    );
  }

  void ubicationUserRealTime() {
    userBloc.getLocationUser().then(
      (location) {
        if (location.status == 'false') {
          setState(() => searchStatusAddrress = false);
          userBloc.getAddress('', location, false).then(
            (value) {
              if (value.status == "errorQuery") {
                showInSnackBar(
                    'Kushi, no se pudo comunicar con google, verifique su conexión a internet');
              } else {
                setState(() => searchStatusAddrress = true);
                final rooftoop = value.googlemap
                    .where((p) => p.geometry.locationtype == "ROOFTOP")
                    .toList();
                final rangeInterpolated = value.googlemap
                    .where(
                        (p) => p.geometry.locationtype == "RANGE_INTERPOLATED")
                    .toList();
                final geometryCenter = value.googlemap
                    .where((p) => p.geometry.locationtype == "GEOMETRIC_CENTER")
                    .toList();
                if (rooftoop.length > 0) {
                  if (rooftoop.length == 0) {
                    showInSnackBar('Kushi, no pudo accedeer a su ubicación');
                  } else {
                    if (rooftoop.length > 1) {
                      setState(() {
                        googlemapList = rooftoop;
                      });
                      _scaffoldKeyAddress.currentState.openEndDrawer();
                    } else {
                      setState(() {
                        googlemapList = rooftoop;
                      });
                      upLocationAddressSave(rooftoop[0]);
                    }
                  }
                } else if (rangeInterpolated.length > 0) {
                  if (rangeInterpolated.length == 0) {
                    showInSnackBar('Kushi, no pudo accedeer a su ubicación');
                  } else {
                    if (rangeInterpolated.length > 1) {
                      setState(() {
                        googlemapList = rangeInterpolated;
                      });
                      _scaffoldKeyAddress.currentState.openEndDrawer();
                    } else {
                      setState(() {
                        googlemapList = rangeInterpolated;
                      });
                      upLocationAddressSave(rangeInterpolated[0]);
                    }
                  }
                } else {
                  if (geometryCenter.length == 0) {
                    showInSnackBar('Kushi, no pudo accedeer a su ubicación');
                  } else {
                    if (geometryCenter.length > 1) {
                      setState(() {
                        googlemapList = geometryCenter;
                      });
                      _scaffoldKeyAddress.currentState.openEndDrawer();
                    } else {
                      setState(() {
                        googlemapList = geometryCenter;
                      });
                      upLocationAddressSave(geometryCenter[0]);
                    }
                  }
                }
              }
            },
          );
        } else {
          showInSnackBar(
              'Kushi, no pudo obtener su ubicación, verifique su internet');
        }
      },
    );
  }

  void upLocationAddressSave(Results googlemap) {
    final dataDis = googlemap.addressComponets
        .where((p) => p.types[0] == 'locality')
        .toList();
    double laty = googlemap.geometry.location.latY;
    double longx = googlemap.geometry.location.longX;
    if (dataDis.length == 0) {
      final dataDis = googlemap.addressComponets
          .where((p) => p.types[1] == 'locality')
          .toList();
      getDataRefresh(laty, longx);
      _oncargaLocation(dataDis[0].shortName, googlemap.direccionformateada);
      _goToPositionRefresh(laty, longx);
      Future<void>.delayed(const Duration(seconds: 3))
        ..then<void>((_) {
          if (mounted) {
            dialogSaveAddress(googlemap);
          }
        });
    } else {
      getDataRefresh(laty, longx);
      _oncargaLocation(dataDis[0].shortName, googlemap.direccionformateada);
      _goToPositionRefresh(laty, longx);
      Future<void>.delayed(const Duration(seconds: 3))
        ..then<void>((_) {
          if (mounted) {
            dialogSaveAddress(googlemap);
          }
        });
    }
  }

  void getAdrees() async {
    _formKey.currentState.save();
    if (adressmodelserach.address == null || adressmodelserach.address == "") {
      showInSnackBar('¿Que es esto?, profavor ingrese una dirección');
    } else {
      setState(() => searchStatusAddrress = false);
      userBloc
          .getAddress(adressmodelserach.address, widget.userLocation, true)
          .then((value) {
        if (widget.adrresGoogle.googlemap.length == 0 ||
            widget.adrresGoogle.googlemap == null) {
          setState(() => searchStatusAddrress = true);
          showInSnackBar(
              'Error al consltar dirección, revice su conexión de internet o verifique su dirección');
        } else {
          setState(() {
            searchStatusAddrress = true;
            dataGoogleMap = value;
          });
          if (value.googlemap.length > 1) {
            setState(() {
              googlemapList = value.googlemap.toList();
            });
            _scaffoldKeyAddress.currentState.openEndDrawer();
          } else {
            setState(() {
              googlemapList = value.googlemap;
            });
            upLocationAddressSave(value.googlemap[0]);
          }
        }
      });
    }
  }

  Future<void> _goToPositionRefresh(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(lat, long),
            zoom: 20.0,
            tilt: 59.440,
            bearing: 192.833),
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      controller = controller;
    });
  }

  dialogSaveAddress(Results googlemap) {
    String valorInicialNombre = "";
    /*final dataRute = dataGoogleMap.googlemap[0].addressComponets
        .where((p) => p.types[0] == 'route')
        .toList();
    final dataPoli = dataGoogleMap.googlemap[0].addressComponets
        .where((p) => p.types[0] == 'political')
        .toList();*/
    /*final dataciudad = googlemap.addressComponets
        .where((p) => p.types[0] == 'administrative_area_level_2')
        .toList();*/
    final dataDis = googlemap.addressComponets
        .where((p) => p.types[0] == 'locality')
        .toList();
    final dataProv = googlemap.addressComponets
        .where((p) => p.types[0] == 'administrative_area_level_2')
        .toList();
    final dataDep = googlemap.addressComponets
        .where((p) => p.types[0] == 'administrative_area_level_1')
        .toList();
    if (dataDis.length == 0 || dataProv.length == 0 || dataDep.length == 0) {
      showInSnackBar(
          'No puedo guardar esta dirección, pruebe con otra diferente.');
    } else {
      valorInicialNombre = googlemap.direccionformateada;
      addressSaveFrom.latitud = googlemap.geometry.location.latY.toString();
      addressSaveFrom.longitud = googlemap.geometry.location.longX.toString();
      addressSaveFrom.descriptionProv = dataProv[0].longName;
      addressSaveFrom.descriptionDis = dataDis[0].longName;
      addressSaveFrom.descriptionDepa = dataDep[0].longName;
      alertDialogFromSave(valorInicialNombre);
    }
  }

  void alertDialogFromSave(String valorInicialNombre) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          title: Row(
            children: <Widget>[
              Icon(UiIcons.user_1),
              SizedBox(width: 10),
              Text(
                'Registrar Dirección',
                style: Theme.of(context).textTheme.bodyText2,
              )
            ],
          ),
          children: <Widget>[
            Form(
              key: _formKeyFormDialog,
              child: Column(
                children: <Widget>[
                  new TextFormField(
                    style: TextStyle(color: Theme.of(context).hintColor),
                    keyboardType: TextInputType.emailAddress,
                    decoration: getInputDecoration(
                        hintText: '', labelText: 'Nombre de dirección'),
                    onSaved: (input) => addressSaveFrom.nameAdrres = input,
                    validator: (input) => input.trim().length < 3
                        ? 'este campo es obligatorio'
                        : null,
                  ),
                  new TextFormField(
                    enabled: true,
                    style: TextStyle(color: Theme.of(context).hintColor),
                    keyboardType: TextInputType.text,
                    decoration: getInputDecoration(
                        hintText: '', labelText: 'Dirección'),
                    initialValue: valorInicialNombre,
                    validator: (input) => input.trim().length < 3
                        ? 'Not a valid full name'
                        : null,
                    onSaved: (input) => addressSaveFrom.address = input,
                  ),
                  new TextFormField(
                    style: TextStyle(color: Theme.of(context).hintColor),
                    keyboardType: TextInputType.emailAddress,
                    decoration: getInputDecoration(
                        hintText: 'Agrege departamento u piso',
                        labelText: 'Dirección adicional '),
                    onSaved: (input) => addressSaveFrom.addressAdd = input,
                  ),
                  new TextFormField(
                    style: TextStyle(color: Theme.of(context).hintColor),
                    keyboardType: TextInputType.emailAddress,
                    decoration: getInputDecoration(
                        hintText: 'agrege su referencia ',
                        labelText: 'Referencia'),
                    onSaved: (input) => addressSaveFrom.reference = input,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                MaterialButton(
                  onPressed: () {
                    saveFromAdrresSave(context);
                  },
                  child: Text(
                    'Guardar',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText1.merge(
            TextStyle(color: Theme.of(context).focusColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText1.merge(
            TextStyle(color: Theme.of(context).hintColor),
          ),
    );
  }

  saveFromAdrresSave(BuildContext context) {
    if (_formKeyFormDialog.currentState.validate()) {
      _formKeyFormDialog.currentState.save();
      addressSaveFrom.idClient = widget.user.idCliente;
      userBloc.saveAdrresClientBloc(addressSaveFrom).then((value) {
        if (value == 200) {
          Navigator.pop(context);
          _formKey.currentState.reset();
          showInSnackBar('La Dirección se grabo\n Correctamente');
          getlistAdreesClient();
        } else if (value == 404 || value == 401 || value == 403) {
          Navigator.pop(context);
          showInSnackBar(
              'No se obtienen respuesta satisfactoria de Google", por favor ingrese otra dirección');
        } else {
          Navigator.pop(context);
          print('¡Chispas!, petición no procesada');
        }
      });
    }
  }

  getlistAdreesClient() {
    _serviceUserRepository
        .getAddressClient(widget.user.idCliente.toString())
        .then((value) {
      setState(() {
        listAdreesClient = value.listAdrress;
      });
    });
  }

  void alertInfodeleteAddress(String idAdress) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                '¡${widget.user.name}! ¿Seguro que desea eliminar esta dirección?'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'SI',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                deleAddrresClient(context, idAdress);
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
      },
    );
  }

  deleAddrresClient(BuildContext context, String idAdress) {
    if (listAdreesClient.length > 1) {
      userBloc.removeAddressClientBloc(idAdress).then(
        (value) {
          if (value == 200) {
            Navigator.pop(context);
            showInSnackBar('Hecho, dirección eliminada');
            getlistAdreesClient();
          } else if (value == 404 || value == 401 || value == 403) {
            Navigator.pop(context);
            showInSnackBar('¡Vaya!, error al borrar esta dirección');
          } else {
            Navigator.pop(context);
            showInSnackBar('¡Chispas!, petición no procesada');
          }
        },
      );
    } else {
      Navigator.pop(context);
      showInSnackBar(
          'Procedimiento denegado, No puesdes borrar todas tus direcciones, si deseas borrar esta dirección guarda otra y vuelve a intentarlo.');
    }
  }

  void alertAddPreferenceAddressClient(String idClient, String idAddress) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                '¡${widget.user.name}! ¿Seguro que desea agregar esta dirección como Predeterminada?'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'SI',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                addPreferenceAddressClient(context, idClient, idAddress);
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
      },
    );
  }

  addPreferenceAddressClient(
      BuildContext context, String idClient, String idAddress) {
    userBloc.addPreferenceAddressClient(idClient, idAddress).then((value) {
      if (value == 200) {
        Navigator.pop(context);
        showInSnackBar(
            'Hecho, Ahora esta dirección es la predeterminada para su delivery');
        getlistAdreesClient();
      } else if (value == 404 || value == 401 || value == 403 || value == 400) {
        Navigator.pop(context);
        showInSnackBar('¡Vaya!, error al hacer predeterminada esta dirección');
      } else {
        Navigator.pop(context);
        print('¡Chispas!, peticion no procesada');
      }
    });
  }
}
