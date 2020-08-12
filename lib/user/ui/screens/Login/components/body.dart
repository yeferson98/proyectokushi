import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/animations/FadeAnimatios.dart';
import 'package:kushi/components/background.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/smsEnvio.dart';
import 'package:kushi/user/ui/screens/Login/components/verifyCode.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  static const items = <String>['+51'];
  final List<DropdownMenuItem<String>> _dropoDownItems = items
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _btnselectVal;
  bool checkVal = true;
  UserBloc userBloc;
  TextEditingController _numerophone;
  SMSENVIO _model;
  @override
  void initState() {
    super.initState();
    _model = new SMSENVIO();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/img/kushilogo.png",
              height: size.height * 0.20,
            ),
            SizedBox(height: size.height * 0.03),
            SizedBox(
              height: 15,
            ),
            FadeAnimation(
              2,
              Text(
                'Ingresa tu número de celular',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'italic',
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            FadeAnimation(
              3,
              Padding(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: Text(
                  'Enviaremos un codigo de verificación a tu celular por SMS ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black54),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                    4,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 50,
                          child: Icon(Icons.phone_iphone),
                        ),
                        Container(
                          child: DropdownButton(
                            value: _btnselectVal,
                            hint: Text('+ 51'),
                            onChanged: ((String newValue) {
                              setState(() {
                                _btnselectVal = newValue;
                              });
                            }),
                            items: _dropoDownItems,
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _numerophone,
                            onSaved: (value) => _model.number = value,
                            decoration: InputDecoration(
                              hintText: 'digite su número',
                              contentPadding: EdgeInsets.only(top: 8),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            maxLength: 9,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Número de celular requerido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                    6,
                    InkWell(
                      child: Container(
                        width: 310,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Center(
                            child: Text(
                          'Enviar',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontSize: 17),
                        )),
                      ),
                      onTap: () {
                        _envSms();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _envSms() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_model.number.length < 9) {
        alert('Su número debe de tener 9 caracteres');
      } else {
        userBloc.getMenssage(_model.number).then((SMSENVIO message) {
          if (message.status == 500) {
            alert('El número  ingresado no es valido');
          } else if (message.status == 200) {
            Provider.of<InterceptApp>(context)
                .queryNumber(Colors.greenAccent[600], message.message);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => BlocProvider(
                  child: VerifyCode(
                    numeroPhone: _model.number,
                    code: message.smsCode,
                  ),
                  bloc: UserBloc(),
                ),
              ),
            );
          } else {
            alert('Kushi no pudo comunicarse con internet');
          }
        });
      }
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
