import 'package:flutter/material.dart';

class HeaderUser extends StatefulWidget {
  @override
  _HeaderUserState createState() => _HeaderUserState();
}

class _HeaderUserState extends State<HeaderUser> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.12,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.deepPurple[600].withOpacity(0.5), blurRadius: 5)
          ]),
      child: Row(
        children: <Widget>[
        Container(
          width: 80,
          height: 80,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/img/avatarPermanent.png'),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'BIENVENIDO',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text('PEDRO',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent)),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Icon(Icons.arrow_drop_down),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text('Pacaicaso 145',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ],
        ),
        SizedBox(width: 80,),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.deepPurple[600],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.shopping_cart, color: Colors.white,),
        )
      ]),
    );
  }
}
