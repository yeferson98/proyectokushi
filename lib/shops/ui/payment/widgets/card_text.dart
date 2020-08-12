import 'package:flutter/material.dart';

Widget cardText(double bottomPoistion, double leftPosition, Color textColor,
    FontWeight textWeight, String text, double textSize) {
  return Positioned(
    bottom: bottomPoistion,
    left: leftPosition,
    child: InkWell(
          child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 14, fontWeight: textWeight),
      ),
    ),
  );
}
