import 'package:flutter/material.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/shops/ui/widgets/FlashSalesCarouselWidget.dart';
import 'package:kushi/user/model/user.model.dart';

// ignore: must_be_immutable
class ProductDetailsTabWidget extends StatefulWidget {
  ProductModel product;
  Business supermarkets;
  Future<List<ProductModel>> products;
  ValueChanged<ProductModel> onChanged;
  UserModel user;
  ProductDetailsTabWidget({
    this.product,
    this.supermarkets,
    this.user,
    @required this.products,
    @required this.onChanged,
  });

  @override
  ProductDetailsTabWidgetState createState() => ProductDetailsTabWidgetState();
}

class ProductDetailsTabWidgetState extends State<ProductDetailsTabWidget> {
  ShopRepository _serviceTodoRapidAPI;
  String descripcionLarga = "";
  @override
  void initState() {
    _serviceTodoRapidAPI = Ioc.get<ShopRepository>();
    verifyNullData();
    super.initState();
  }

  verifyNullData() {
    if (widget.product.descriptionTwo == null) {
      descripcionLarga = "";
    } else {
      descripcionLarga = widget.product.descriptionTwo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.file_2,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'Descripción',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(descripcionLarga),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.box,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              'Productos Relacionados',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        FutureBuilder(
          future: widget.products,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: Text('Cargando...'));
              case ConnectionState.none:
                return Center(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text('Revisa tu conexión a internet'),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: () {
                                  _actualizarServiceProduct();
                                }),
                            Text('Reintentar')
                          ],
                        )
                      ],
                    ),
                  ),
                );
              case ConnectionState.active:
                List<ProductModel> products = snapshot.data;
                final data = products
                    .where((p) => p.idCategory == widget.product.idCategory)
                    .toList();
                return FlashSalesCarouselWidget(
                    heroTag: 'product_details_related_products',
                    productsList: data,
                    supermarkets: widget.supermarkets,
                    user: widget.user);
              case ConnectionState.done:
                List<ProductModel> products = snapshot.data;
                if (products == null) {
                  return Center(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text('Revisa tu conección a internet'),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    _actualizarServiceProduct();
                                  }),
                              Text('Reintentar')
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  final data = products
                      .where((p) => p.idCategory == widget.product.idCategory)
                      .toList();
                  return FlashSalesCarouselWidget(
                      heroTag: 'product_details_related_products',
                      productsList: data,
                      supermarkets: widget.supermarkets,
                      user: widget.user);
                }
            }
          },
        ),
      ],
    );
  }

  void _actualizarServiceProduct() {
    setState(() {
      widget.products = _serviceTodoRapidAPI.fetchProductRepository(
          widget.supermarkets.uid.toString(), widget.user.id.toString());
    });
  }
}
