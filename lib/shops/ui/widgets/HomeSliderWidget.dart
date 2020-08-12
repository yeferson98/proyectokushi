import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/components/slider.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/ui/widgets/item.slider.home.dart';

// ignore: must_be_immutable
class HomeSliderWidget extends StatefulWidget {
  int idsupermarket;
  HomeSliderWidget({Key key, this.idsupermarket}) : super(key: key);
  @override
  _HomeSliderWidgetState createState() => _HomeSliderWidgetState();
}

class _HomeSliderWidgetState extends State<HomeSliderWidget> {
  List<SliderData> _productsFilterList;
  SliderDataListData cartList;
  SliderData data;
  ShopBloc shopBloc;
  @override
  void initState() {
    super.initState();
    cartList = new SliderDataListData();
    slider();
  }

  void slider() {
    setState(() {
      _productsFilterList = cartList.list
          .where((p) => p.idSupermarket == widget.idsupermarket)
          .toList();
    });
    if (_productsFilterList.length == 0) {
      // _productsFilterList = cartList.list.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    shopBloc = BlocProvider.of(context);
    return FutureBuilder(
      future:
          shopBloc.fetchPromotionsRepository(widget.idsupermarket.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return Center(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Revisa tu conexión a internet'),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          if (snapshot.data.length == 0) {
            return Container();
          } else {
            return SliderItem(promotions: snapshot.data);
          }
        } else {
          return Center(
            child: Container(
              child: Text('Cargando...'),
            ),
          );
        }
      },
    );
  }
}
