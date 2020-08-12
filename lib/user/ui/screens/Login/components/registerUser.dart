import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kushi/components/backgroundRegister.dart';
import 'package:kushi/components/text_field_container.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/user/ui/screens/AddressUser.dart';
import 'package:kushi/user/ui/screens/AllowLocation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as pah;
import 'package:http/http.dart' as http;
import 'package:kushi/animations/FadeAnimatios.dart';
import 'package:kushi/bussiness/bloc/business.bloc.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/constants/constant.user.dart';
import 'package:kushi/user/model/cities.model.dart';
import 'package:kushi/user/model/result.reg.user.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/repository/user.respository.dart';
import 'package:kushi/user/ui/screens/dashboar.User.dart';

// ignore: must_be_immutable
class RegisterUser extends StatefulWidget {
  String phone;
  RegisterUser({Key key, this.phone}) : super(key: key);
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  List<Cities> listaCity = new List<Cities>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Cities cities;
  //int idCity = 0;
  bool imagePicture = false;
  File _selectedPicture;
  UserModel _model;
  TextEditingController _namecontroller, _lastnamecontroller, _emailcontroller;
  bool messagecarga = false;
  bool hasError = true;
  bool isreconnecting = true;
  String messageError;
  UserRepository userRepository;
  UserBloc userBloc;
  String messageProgressRegUser = "";
  UserModel getUserSet;
  @override
  void initState() {
    super.initState();
    userRepository = Ioc.get<UserRepository>();
    _model = new UserModel();

    ///getListCities();
  }

  /*getListCities() async {
    final lista = await userRepository.getCitiesRepository();
    setState(() {
      listaCity = lista;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return WillPopScope(
      child: Scaffold(
        body: BackgroundRegister(
          child: SingleChildScrollView(
            child: hasError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FadeAnimation(
                        1,
                        Container(
                          child: CircleAvatar(
                              backgroundImage: !imagePicture
                                  ? AssetImage('assets/img/upLoadPhoto.png')
                                  : FileImage(_selectedPicture),
                              maxRadius: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 55),
                                child: InkWell(
                                  child: Container(
                                    width: 145,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Icon(
                                            Icons.camera,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          child: InkWell(
                                            child: Text(
                                              'Subir Imagen',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            onTap: () async {
                                              var image =
                                                  await ImagePicker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (image != null) {
                                                setState(() {
                                                  _selectedPicture = image;
                                                  imagePicture = true;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    var image = await ImagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    if (image != null) {
                                      setState(() {
                                        _selectedPicture = image;
                                        imagePicture = true;
                                      });
                                    }
                                  },
                                ),
                              )),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FadeAnimation(
                              2,
                              Text(
                                'Ingrese sus datos',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                              3,
                              TextFieldContainer(
                                child: TextFormField(
                                    controller: _namecontroller,
                                    onSaved: (data) => _model.name = data,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Nombre (requerido)',
                                        labelStyle: TextStyle(letterSpacing: 2),
                                        icon: Icon(
                                          UiIcons.user_1,
                                          color: Theme.of(context).accentColor,
                                        )),
                                    validator: _validatename),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FadeAnimation(
                              6,
                              TextFieldContainer(
                                child: TextFormField(
                                    controller: _lastnamecontroller,
                                    onSaved: (data) => _model.lastname = data,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Apellido (requerido)',
                                        icon: Icon(UiIcons.user_1,
                                            color:
                                                Theme.of(context).accentColor)),
                                    validator: _validateLastName),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FadeAnimation(
                              8,
                              TextFieldContainer(
                                child: TextFormField(
                                  controller: _emailcontroller,
                                  onSaved: (data) => _model.email = data,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Correo (opcional)',
                                    icon: Icon(Icons.email,
                                        color: Theme.of(context).accentColor),
                                  ),
                                  validator: _validateEmail,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 28,
                            ),
                            !messagecarga
                                ? FadeAnimation(
                                    10,
                                    InkWell(
                                      child: Container(
                                        width: 310,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).accentColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Guardar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                              fontSize: 17),
                                        )),
                                      ),
                                      onTap: () {
                                        registerUser();
                                      },
                                    ),
                                  )
                                : Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          messageProgressRegUser,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: reconectando(),
                  ),
          ),
        ),
      ),
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Salir'),
              content: Text('¿Seguro que desea salir de la aplicación?'),
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

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return null;
    }
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    final nameExp = RegExp(p);
    if (!nameExp.hasMatch(value)) {
      return 'Email no valido';
    }
    return null;
  }

  String _validatename(String value) {
    if (value.isEmpty) {
      return 'Campo vacio';
    }
    final nameExp = RegExp(r'(^[a-zA-Z ]*$)');
    if (!nameExp.hasMatch(value)) {
      return 'Sin tildes u especios en blaco';
    }
    return null;
  }

  String _validateLastName(String value) {
    if (value.isEmpty) {
      return 'Campo vacio';
    }
    final nameExp = RegExp(r'^[A-Za-z]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Sin tildes u especios en blaco';
    }
    return null;
  }

  /* changedDropDownItem(Cities city) {
    setState(() {
      cities = city;
      idCity = city.uid;
    });
  }*/
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
              child: Text(messageProgressRegUser),
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
                        verifyLocationActive(getUserSet);
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

  void registerUser() {
    userBloc.getTokenNotification().then((value) async {
      if (value != "") {
        if (_formKey.currentState.validate()) {
          setState(() {
            messageProgressRegUser = 'Procesando...';
            messagecarga = true;
          });
          try {
            _model.phone = widget.phone;
            _formKey.currentState.save();
            if (_selectedPicture == null) {
              SharedPreferences _preferences =
                  await SharedPreferences.getInstance();
              Map<String, String> headers = {
                "Accept": "application/json",
                "Authorization": "Bearer "
              };
              var uri = Uri.parse(UserConstants.SAVEUSER);
              var request = new http.MultipartRequest("POST", uri);
              request.headers.addAll(headers);
              request.fields['Usu_Celular'] = _model.phone;
              request.fields['Usu_Nom'] = _model.name;
              request.fields['Usu_Ape'] = _model.lastname;
              request.fields['Usu_Email'] = _model.email;
              request.fields['Cli_TokenCel'] = value;
              var response = await request.send();
              print(response.statusCode);
              if (response.statusCode == 422) {
                alert('Ocurrio un error inesperado');
                setState(() {
                  messageProgressRegUser = '';
                  messagecarga = false;
                });
              } else if (response.statusCode == 404 ||
                  response.statusCode == 500 ||
                  response.statusCode == 403) {
                alert('Error al grabar usuario');
                setState(() {
                  messageProgressRegUser = '';
                  messagecarga = false;
                });
              }
              if (response.statusCode == 200) {
                response.stream.transform(utf8.decoder).listen(
                  (value) {
                    final map = jsonDecode(value) as Map<String, dynamic>;
                    ResultRegUser data = ResultRegUser.formJson(map);
                    _preferences.setString('Token', data.token);
                    getUser(data);
                  },
                );
              }
            } else {
              SharedPreferences _preferences =
                  await SharedPreferences.getInstance();
              var stream = new http.ByteStream(
                  Stream.castFrom(_selectedPicture.openRead()));
              var length = await _selectedPicture.length();
              Map<String, String> headers = {
                "Accept": "application/json",
                "Authorization": "Bearer "
              };
              var uri = Uri.parse(UserConstants.SAVEUSER);
              var request = new http.MultipartRequest("POST", uri);
              var multipartFileSign = new http.MultipartFile(
                  'Usu_foto', stream, length,
                  filename: pah.basename(_selectedPicture.path));
              request.files.add(multipartFileSign);
              request.headers.addAll(headers);
              request.fields['Usu_Celular'] = _model.phone;
              request.fields['Usu_Nom'] = _model.name;
              request.fields['Usu_Ape'] = _model.lastname;
              request.fields['Usu_Email'] = _model.email;
              request.fields['Cli_TokenCel'] = value;
              var response = await request.send();
              print(response.statusCode);
              if (response.statusCode == 422) {
                alert('La imagen seleccionada  debe de ser \n menora 200kb');
                setState(() {
                  messageProgressRegUser = '';
                  messagecarga = false;
                });
              } else if (response.statusCode == 404 ||
                  response.statusCode == 500 ||
                  response.statusCode == 403) {
                alert('Error al grabar usuario');
                setState(() {
                  messageProgressRegUser = '';
                  messagecarga = false;
                });
              }
              if (response.statusCode == 200) {
                response.stream.transform(utf8.decoder).listen(
                  (value) {
                    final map = jsonDecode(value) as Map<String, dynamic>;
                    ResultRegUser data = ResultRegUser.formJson(map);
                    _preferences.setString('Token', data.token);
                    getUser(data);
                  },
                );
              }
            }
          } catch (e) {
            print(e);
            alert('Kushi no pudo procesar su petición');
            setState(() {
              messageProgressRegUser = '';
              messagecarga = false;
            });
          }
        }
      }
    });
  }

  void getUser(ResultRegUser data) async {
    setState(() {
      messageProgressRegUser = 'Usuario guardado Espere...';
    });
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    userBloc.getuserUserBloc(data, _model.phone).then(
      (UserModel user) {
        _preferences.setBool('isLoggedInUser', true);
        _preferences.setString('phone', _model.phone);
        userBloc.getAddressClient(user.idCliente.toString()).then((value) {
          if (value.status == 404 ||
              value.status == 500 ||
              value.status == 422) {
            setState(() {
              isreconnecting = true;
              hasError = true;
              messageError = 'Error de red verifique su conexión';
            });
          } else {
            if (value.listAdrress.length > 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider(
                    child: DashboardUser(userdata: user),
                    bloc: BusinessBloc(),
                  ),
                ),
              );
            } else {
              verifyLocationActive(user);
            }
          }
        });
      },
    );
  }

  void verifyLocationActive(UserModel user) async {
    setState(() {
      messageProgressRegUser = 'Ya casi terminamos...';
      getUserSet = user;
    });
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey('permissionLocation')) {
      userBloc.getLocationUser().then(
        (location) {
          if (location.status == 'false') {
            userBloc.getAddress('', location, false).then(
              (googlelocation) {
                if (googlelocation.status == "errorQuery") {
                  setState(() {
                    isreconnecting = true;
                    hasError = false;
                    messageError =
                        'Kushi, no se pudo comunicar con google, verifique su conexión a internet';
                  });
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
            setState(
              () {
                isreconnecting = true;
                hasError = false;
                messageError = 'Vaya, verifique su internet';
              },
            );
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
