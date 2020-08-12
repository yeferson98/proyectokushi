import 'package:flutter/material.dart';
import 'package:kushi/shops/model/order.detail.product.model.dart';
import 'package:kushi/user/ui/widgets/carrucel.product.order.item.detail.dart';

// ignore: must_be_immutable
class FlashOrderCarouselWidget extends StatelessWidget {
  List<OrderDetailProduct> productsList;
  String heroTag;
  ValueChanged<String> onChangedImage;

  FlashOrderCarouselWidget(
      {Key key, this.productsList, this.heroTag, @required this.onChangedImage})
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
          return FlashOrderCarouselItemWidget(
            heroTag: this.heroTag,
            marginLeft: _marginLeft,
            onChangedImage: (image) {
              onChangedImage(image);
            },
            product: productsList.elementAt(index),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
