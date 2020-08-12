import 'package:flutter/material.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/ui/widgets/FlashSalesCarouselItemWidget.dart';
import 'package:kushi/user/model/user.model.dart';

// ignore: must_be_immutable
class FlashSalesCarouselWidget extends StatelessWidget {
  List<ProductModel> productsList;
  String heroTag;
  UserModel user;
  Business supermarkets;
  FlashSalesCarouselWidget(
      {Key key,
      this.productsList,
      this.heroTag,
      this.supermarkets,
      @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: productsList.length,
          itemBuilder: (context, index) {
            double _marginLeft = 0;
            (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
            return FlashSalesCarouselItemWidget(
              heroTag: this.heroTag,
              marginLeft: _marginLeft,
              product: productsList.elementAt(index),
              user: user,
              supermarkets: supermarkets,
            );
          },
          scrollDirection: Axis.horizontal,
        ));
  }
}
