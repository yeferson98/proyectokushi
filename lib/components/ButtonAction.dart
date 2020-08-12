import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonAction extends StatefulWidget {
  String name;
  Color color;
  dynamic onTap;
  ButtonAction({this.name, this.color, this.onTap});
  @override
  _ButtonActionState createState() => _ButtonActionState();
}

class _ButtonActionState extends State<ButtonAction> {
  dynamic function;
  @override
  void initState() {
    super.initState();
    function = widget.onTap;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 350,
        height: 38,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
            child: Text(
          widget.name,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        )),
      ),
      onTap: function,
    );
  }
}
