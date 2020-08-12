import 'package:flutter/material.dart';

class FloatingActionButtonGreen extends StatefulWidget {
  final Icon iconData;
  final VoidCallback onPressed;
  final Color color;
  FloatingActionButtonGreen(
      {Key key,
      @required this.iconData,
      @required this.onPressed,
      @required this.color});
  @override
  State<StatefulWidget> createState() {
    return _FloatingActionButtonGreen();
  }
}

class _FloatingActionButtonGreen extends State<FloatingActionButtonGreen> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: widget.color,
      mini: true,
      tooltip: "Fav",
      onPressed: widget.onPressed,
      child: widget.iconData,
      heroTag: null,
    );
  }
}
