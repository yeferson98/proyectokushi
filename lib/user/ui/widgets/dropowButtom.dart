import 'package:flutter/material.dart';
import 'package:kushi/user/model/cities.model.dart';

// ignore: must_be_immutable
class DropowButton extends StatefulWidget {
  List<Cities> cities;
  ValueChanged<Cities> onDismissed;
  DropowButton({Key key, @required this.cities, @required this.onDismissed});
  @override
  _DropowButtonState createState() => _DropowButtonState();
}

class _DropowButtonState extends State<DropowButton> {
  Cities cities;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 310,
        child: new DropdownButton<Cities>(
          value: cities,
          hint: Text('Seleleccione ciudad'),
          items: widget.cities.map((Cities city) {
            return new DropdownMenuItem(
              child: Text(city.name),
              value: city,
            );
          }).toList(),
          onChanged: (Cities city) {
            widget.onDismissed(city);
          },
        ));
  }
}
