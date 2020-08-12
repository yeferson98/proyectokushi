import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/components/background.dart';
import 'package:kushi/user/ui/screens/Login/components/registerUser.dart';
import 'package:kushi/user/ui/screens/Login/login_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kushi/animations/FadeAnimatios.dart';
import 'package:kushi/bussiness/bloc/business.bloc.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/user/model/result.reg.user.model.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/model/verify.code.dart';
import 'package:kushi/user/ui/screens/dashboar.User.dart';

class VerifyCode extends StatefulWidget {
  final String numeroPhone;
  final int code;
  const VerifyCode({Key key, this.numeroPhone, this.code}) : super(key: key);
  @override
  _VerifyCodeState createState() => _VerifyCodeState();
}

var onTapRecognizer;

class _VerifyCodeState extends State<VerifyCode> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool checkVal = true;
  UserBloc userBloc;
  String messageError;
  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => BlocProvider(
              child: LoginScreen(),
              bloc: UserBloc(),
            ),
          ),
        );
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Background(
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
                  'Ingresa el código de seguridad',
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
                    'Envíamos  un código de verificación al (+51)' +
                        widget.numeroPhone,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.black54),
                  ),
                ),
              ),
              /*SizedBox(
                height: 5,
              ),
              FadeAnimation(
                4,
                Text(
                  'codigo' + widget.code.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).accentColor,
                      fontStyle: FontStyle.italic),
                ),
              ),*/
              SizedBox(
                height: 17,
              ),
              FadeAnimation(
                  5,
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: PinCodeTextField(
                            textInputType: TextInputType.number,
                            length: 6,
                            obsecureText: false,
                            autoDismissKeyboard: true,
                            activeColor: Theme.of(context).accentColor,
                            animationType: AnimationType.fade,
                            shape: PinCodeFieldShape.underline,
                            animationDuration: Duration(milliseconds: 300),
                            fieldHeight: 40,
                            fieldWidth: 25,
                            textStyle: TextStyle(color: Colors.purple[600]),
                            affirmativeText: "Pegar",
                            dialogTitle: 'Prueba',
                            onCompleted: (v) {
                              print("Completed");
                            },
                            onChanged: (value) {
                              setState(() => currentText = value);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Container(
                            child: Text(hasError ? messageError : "",
                                style: TextStyle(
                                    color: Colors.red.shade300, fontSize: 12),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "¿No me llego el codigo?",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 15),
                              children: [
                                TextSpan(
                                    text: "Cambiar",
                                    recognizer: onTapRecognizer,
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))
                              ]),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          6,
                          InkWell(
                            child: Container(
                              width: 310,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Center(
                                  child: Text(
                                'Verificar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    fontSize: 17),
                              )),
                            ),
                            onTap: () {
                              verifiCode();
                            },
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void verifiCode() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (currentText == "" || currentText.length < 6) {
        setState(() {
          hasError = true;
          messageError = 'Codigo incompleto, llene todos los campos';
        });
      } else {
        userBloc
            .verifycodeUserBloc(widget.numeroPhone, currentText)
            .then((VERIFICODE code) {
          if (code.error == null) {
            setState(() {
              hasError = true;
              messageError = 'Error de red, sin conexión a internet';
            });
          } else {
            if (code.error == false) {
              print(code.message);
              setState(() {
                hasError = false;
              });
              verifyuserReg();
            } else {
              setState(() {
                hasError = true;
                messageError = 'Codigo icorrecto, ingrese nuevamente el codigo';
              });
            }
          }
        });
      }
    }
  }

  void verifyuserReg() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    userBloc.verifyUserExistBloc(widget.numeroPhone).then((value) {
      if (value.status == null) {
        if (value.register == true) {
          userBloc
              .getqueryResultUserBloc(widget.numeroPhone)
              .then((ResultRegUser code) {
            if (code.error == false) {
              userBloc
                  .getuserUserBloc(code, widget.numeroPhone)
                  .then((UserModel user) {
                userBloc.getTokenNotification().then((token) => {
                      userBloc
                          .updatedTokenNotificationBloc(
                              user.idCliente.toString(), token, code.token)
                          .then((response) {
                        if (response == 401 ||
                            response == 500 ||
                            response == 403) {
                          setState(() {
                            hasError = true;
                            messageError =
                                'Kushi no pudo comunicarse con internet';
                          });
                        } else if (response == 200) {
                          _preferences.setString('Token', code.token);
                          _preferences.setString('phone', widget.numeroPhone);
                          _preferences.setBool('isLoggedInUser', true);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) => BlocProvider(
                                child: DashboardUser(userdata: user),
                                bloc: BusinessBloc(),
                              ),
                            ),
                          );
                        }
                      })
                    });
              });
            } else if (code.error == true) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => BlocProvider(
                    child: RegisterUser(
                      phone: widget.numeroPhone,
                    ),
                    bloc: UserBloc(),
                  ),
                ),
              );
            } else {
              setState(() {
                hasError = true;
                messageError = code.message;
              });
            }
          });
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider(
                child: RegisterUser(
                  phone: widget.numeroPhone,
                ),
                bloc: UserBloc(),
              ),
            ),
          );
        }
      } else if (value.status == 404) {
        setState(() {
          hasError = true;
          messageError =
              'Número no registrado, vuelva a intentarlo registrando su número nuevamente.';
        });
      } else {
        setState(() {
          hasError = true;
          messageError = 'Ocurrio un error inesperado.';
        });
      }
    });
  }
}
