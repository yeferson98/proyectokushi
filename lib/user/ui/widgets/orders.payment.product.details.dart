import 'package:flutter/material.dart';
import 'package:kushi/components/ProgressIndicator.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/model/order.detail.product.model.dart';
import 'package:kushi/shops/model/order.payment.model.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/user/ui/widgets/carrucel.product.order.detail.dart';

// ignore: must_be_immutable
class ProductDetailsOrderTabWidget extends StatefulWidget {
  OrderPaymentModel order;
  ValueChanged<String> onChangedImage;
  ProductDetailsOrderTabWidget({this.order, @required this.onChangedImage});

  @override
  ProductDetailsOrderTabWidgetState createState() =>
      ProductDetailsOrderTabWidgetState();
}

class ProductDetailsOrderTabWidgetState
    extends State<ProductDetailsOrderTabWidget> {
  Future<List<OrderDetailProduct>> listdetailorders;
  ShopRepository _serviceShopRepository;
  @override
  void initState() {
    _serviceShopRepository = Ioc.get<ShopRepository>();
    getlistOrdersDetailCliente();
    super.initState();
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
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
              'Detalle de productos en la tienda de ${widget.order.businessRS}'),
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
              'Productos Comprados',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .merge(TextStyle(fontSize: 15)),
            ),
          ),
        ),
        FutureBuilder(
          future: listdetailorders,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CupertinoProgressIndicator();
              case ConnectionState.none:
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
                                  getlistOrdersDetailCliente();
                                }),
                            Text('Reintentar')
                          ],
                        )
                      ],
                    ),
                  ),
                );
              case ConnectionState.active:
                return FlashOrderCarouselWidget(
                  heroTag: 'product_details_related_products',
                  productsList: snapshot.data,
                  onChangedImage: (String value) {
                    widget.onChangedImage(value);
                  },
                );
              case ConnectionState.done:
                return FlashOrderCarouselWidget(
                  heroTag: 'product_details_related_products',
                  productsList: snapshot.data,
                  onChangedImage: (String value) {
                    widget.onChangedImage(value);
                  },
                );
            }
          },
        ),
      ],
    );
  }

  getlistOrdersDetailCliente() {
    setState(() {
      listdetailorders =
          _serviceShopRepository.fetchOrderPaymentDetailClientRepository(
              widget.order.codPayment.toString());
    });
  }
}
