import 'package:flutter/widgets.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/ui/widgets/SearchBarWidget.dart';
import 'package:kushi/bussiness/ui/widgets/list.supermarkets.dart';
import 'package:kushi/user/model/user.model.dart';

_SupermarketsBodyState pagestate;

// ignore: must_be_immutable
class SupermarketsBody extends StatefulWidget {
  final List<Business> supermarkets;
  final Animation animationOpacity;
  final UserModel userDataGet;
  ValueChanged onPressed;
  SupermarketsBody(
      {Key key,
      @required this.animationOpacity,
      @required List<Business> supermarkets,
      @required UserModel userDataGet})
      : supermarkets = supermarkets,
        userDataGet = userDataGet,
        super(key: key);
  @override
  _SupermarketsBodyState createState() {
    pagestate = _SupermarketsBodyState();
    return pagestate;
  }
}

class _SupermarketsBodyState extends State<SupermarketsBody>
    with SingleTickerProviderStateMixin {
  List<Business> listFilterBusiness = new List<Business>();
  List<Business> lista = new List<Business>();
  AnimationController animationController;
  Animation animationOpacity;
  String query = "";
  @override
  void initState() {
    checkListSrupermarket();
    animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StickyHeader(
          header: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(onChanged: (text) {
                setState(() {
                  query = text;
                  listFilterBusiness = widget.supermarkets
                      .where((p) => p.name.toLowerCase().startsWith(text))
                      .toList();
                });
              })),
          content: Container(
            child: itemListaBusiness(),
          ),
        ),
      ],
    );
  }

  Widget itemListaBusiness() {
    if (listFilterBusiness.length > 0) {
      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 13),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: listFilterBusiness.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 1);
        },
        itemBuilder: (context, index) {
          Business supermarket = listFilterBusiness.elementAt(index);
          final int count =
              listFilterBusiness.length > 10 ? 10 : listFilterBusiness.length;
          final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * index, 1.0,
                      curve: Curves.fastOutSlowIn)));

          animationController.forward();
          return BlocProvider(
            child: ItemSupermarket(
              supermarkets: supermarket,
              query: query,
              heroTag: 'tienda',
              animation: animation,
              animationController: animationController,
              userData: widget.userDataGet,
            ),
            bloc: UserBloc(),
          );
        },
      );
    } else {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Image.asset('assets/img/nosearchbusiness.png'),
          Text(
            'No encontre coincidencias para su busqueda: \n ${query.toString()}',
            textAlign: TextAlign.center,
          )
        ],
      );
    }
  }

  void checkListSrupermarket() {
    if (listFilterBusiness.length == 0) {
      listFilterBusiness = widget.supermarkets;
    } else {}
  }
}
