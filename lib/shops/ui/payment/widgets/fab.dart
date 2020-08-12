import 'package:flutter/material.dart';

Widget fab(Color bgcolor, IconData icon, Color iconColour, double size) {
  return FloatingActionButton(
    backgroundColor: bgcolor,
    onPressed: () => {},
    child: Icon(
      icon,
      color: iconColour,
      size: size,
    ),
  );
}
