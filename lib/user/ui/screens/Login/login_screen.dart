import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kushi/user/ui/screens/Login/components/body.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Body(),
      ),
      // ignore: missing_return
      onWillPop: () {
        if (Platform.isAndroid) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Kushi App'),
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
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: Text(
                      'Si',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
