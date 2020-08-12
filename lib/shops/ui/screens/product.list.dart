import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/ui/screens/CategoriesIconsCarouselWidget.dart';
import 'package:kushi/shops/ui/widgets/gridViewProd.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/utils/utils.paginacion.list.dart';

// ignore: must_be_immutable
class ProductoList extends StatefulWidget {
  UserModel user;
  int quantity;
  final List<ProductModel> _productsList;
  final Business supermarkets;
  final bool valueFavoriteList;
  ProductoList(
      {Key key,
      @required List<ProductModel> productsList,
      @required this.user,
      @required Business supermarkets,
      @required bool valueFavoriteList,
      this.quantity})
      : _productsList = productsList,
        supermarkets = supermarkets,
        valueFavoriteList = valueFavoriteList,
        super(key: key);
  @override
  _ProductoListState createState() => _ProductoListState();
}

class _ProductoListState extends State<ProductoList>
    with SingleTickerProviderStateMixin {
  bool fd = false;
  bool endList = true;
  Animation animationOpacity;
  AnimationController animationController;
  List<ProductModel> listFilterproduct = new List<ProductModel>();
  List<ProductModel> listPageProduct = [];
  int ca = PaginacionMostrar.cantidad_paginacion_productos;
  int cmi = PaginacionMostrar.cantidad_inicial_a_mostar_productos;
  int cac = 0;
  int cam = 0;
  @override
  void initState() {
    listFilterproduct = widget._productsList.toList();
    function();
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 70), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StickyHeader(
          header: CategoriesIconsCarouselWidget(
              heroTag: 'home_categories_1',
              business: widget.supermarkets,
              onChanged: (id) {
                setState(() {
                  animationController.reverse().then((f) {
                    if (int.parse(id) == -1998) {
                      cam = 0;
                      cac = 0;
                      endList = true;
                      listFilterproduct = widget._productsList.toList();
                      function();
                    } else {
                      cam = 0;
                      cac = 0;
                      endList = true;
                      listFilterproduct = widget._productsList
                          .where((p) => p.idCategory == int.parse(id))
                          .toList();
                      function();
                    }
                    animationController.forward();
                  });
                });
              }),
          content: FadeTransition(
            opacity: animationOpacity,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: itemListaProductos(),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        butonItemsAdd(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget butonItemsAdd() {
    if (listFilterproduct.length > cmi) {
      return endList
          ? InkWell(
              child: Text(
                'Mostrar más productos',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                function();
              },
            )
          : Text('Fin de la lista');
    } else {
      return Container();
    }
  }

  void function() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('cupon');
    _preferences.remove('idCol');
    _preferences.remove('idSize');
    int total = listFilterproduct.length;
    if (total == cam) {
      setState(() {
        endList = false;
      });
    } else {
      if (cac == 0) {
        cac = cac + cmi;
        if (total > cac) {
          setState(() {
            cam = cac;
          });
        } else {
          setState(() {
            cam = total;
          });
        }
      } else {
        cac = cac + ca;
        if (total > cac) {
          setState(() {
            cam = cac;
          });
        } else {
          setState(() {
            cam = total;
          });
        }
      }
    }
  }

  Widget itemListaProductos() {
    final size = MediaQuery.of(context).size;
    if (listFilterproduct.length > 0) {
      if (size.width > 500) {
        return new StaggeredGridView.countBuilder(
          itemCount: cam,
          primary: false,
          shrinkWrap: true,
          crossAxisCount: 4,
          itemBuilder: (context, index) {
            ProductModel product = listFilterproduct.elementAt(index);
            return CardGrid(
              supermarkets: widget.supermarkets,
              user: widget.user,
              product: product,
              heroTag: 'card',
              valueFavoriteList: widget.valueFavoriteList,
              quantity: 0,
            );
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        );
      } else {
        return new StaggeredGridView.countBuilder(
          itemCount: cam,
          primary: false,
          shrinkWrap: true,
          crossAxisCount: 4,
          itemBuilder: (context, index) {
            ProductModel product = listFilterproduct.elementAt(index);
            return CardGrid(
              supermarkets: widget.supermarkets,
              user: widget.user,
              product: product,
              heroTag: 'card',
              valueFavoriteList: widget.valueFavoriteList,
              quantity: 0,
            );
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        );
      }
    } else {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Image.asset('assets/img/notFountDataService.png'),
        ],
      );
    }
  }

  /*void checkListProduct() async {
    if (listFilterproduct.length == 0) {
      if (widget._productsList.length <= cmi) {
        
      } else {
        listFilterproduct = widget._productsList.toList();
        fun
      }
    } else {}
    
  }*/
}
