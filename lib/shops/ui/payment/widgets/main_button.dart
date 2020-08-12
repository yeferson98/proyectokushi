import 'package:flutter/material.dart';

Widget mainButton(double width, double height, Color btnColor, String btnText, Color textColor, double textSize) {
  return FlatButton(
    onPressed: () => {},
    child: Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shadows: [
          BoxShadow(
            color: btnColor.withOpacity(0.85),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
        color: btnColor,
        shape: StadiumBorder(),
      ),
      child: Center(
        child: Text(
          btnText,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}
