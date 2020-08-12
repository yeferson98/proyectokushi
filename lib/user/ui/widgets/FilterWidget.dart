import 'package:flutter/material.dart';
import 'package:kushi/user/model/map.google.model.dart';
import 'package:kushi/user/model/user.model.dart';

// ignore: must_be_immutable
class FilterWidget extends StatefulWidget {
  List<Results> googlemap;
  ValueChanged<Results> onChanged;
  UserModel user;
  FilterWidget(
      {Key key,
      @required this.googlemap,
      @required this.user,
      @required this.onChanged})
      : super(key: key);
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                //Navigator.of(context).pushNamed('/Tabs', arguments: 1);
              },
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/myaddress.png'))),
                accountName: Text(
                  '',
                  style: Theme.of(context).textTheme.headline6,
                ),
                accountEmail: Text(
                  '',
                  style: Theme.of(context).textTheme.caption,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  backgroundImage: NetworkImage(widget.user.urlImage),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      child:
                          Text('Resultados de la busqueda según su dirección')),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                primary: true,
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  listAddrress()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listAddrress() {
    if (widget.googlemap == null) {
      return Center(child: Text('BUSCA UNA DIRECCION'));
    } else {
      return ExpansionTile(
        title: Text('Seleccione su dirección'),
        children: List.generate(widget.googlemap.length, (index) {
          var _location = widget.googlemap.elementAt(index);
          return ExpansionTile(
            leading: Icon(Icons.location_on),
            title: Text(_location.direccionformateada),
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  widget.onChanged(_location);
                },
                leading: Icon(
                  Icons.save,
                  color: Theme.of(context).accentColor.withOpacity(1),
                ),
                title: Text(
                  "Guardar esta dirección",
                  style: Theme.of(context).textTheme.caption,
                ),
              )
            ],
          );
        }),
        initiallyExpanded: true,
      );
    }
  }
}
