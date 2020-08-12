import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationContext extends StatefulWidget {
  VoidCallback onPressed;
  String data;
  NotificationContext({Key key, @required this.onPressed, @required this.data});
  @override
  _NotificationContextState createState() => _NotificationContextState();
}

class _NotificationContextState extends State<NotificationContext> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Image.asset(
            'assets/images/alertNotification.png',
            width: 50,
            height: 50,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              'Nueva notificación \n ${widget.data.toString()} ',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .merge(TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
      onTap: widget.onPressed,
    );
  }
}
