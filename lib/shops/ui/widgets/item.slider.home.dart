import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kushi/shops/model/promotions.model.dart';

class SliderItem extends StatefulWidget {
  SliderItem({
    Key key,
    @required this.promotions,
  }) : super(key: key);

  final List<PromotionsModel> promotions;

  @override
  _SliderItemState createState() => _SliderItemState();
}

class _SliderItemState extends State<SliderItem> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        carrucel(),
        Positioned(
          bottom: 25,
          right: 41,

          ///width: config.App(context).appWidth(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: widget.promotions.map((data) {
              return Container(
                width: 20.0,
                height: 3.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: _current == widget.promotions.indexOf(data)
                        ? Theme.of(context).hintColor
                        : Theme.of(context).hintColor.withOpacity(0.3)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget carrucel() {
    final size = MediaQuery.of(context).size;
    if (size.width > 500) {
      return CarouselSlider(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 6),
        height: 321,
        viewportFraction: 1.0,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
        items: widget.promotions.map((data) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        offset: Offset(0, 4),
                        blurRadius: 9)
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 24 / 8.6,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                  child: Image.asset(
                                'assets/img/gifcarrucel.gif',
                                fit: BoxFit.fill,
                              )),
                              imageUrl: data.image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 260,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(1),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(6),
                                      topLeft: Radius.circular(6))),
                              child: Text(
                                data.name,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 160,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: FlatButton(
                                onPressed: () {
//                              Navigator.of(context).pushNamed('/Checkout');
                                },
                                padding: EdgeInsets.symmetric(vertical: 5),
                                color: Theme.of(context).accentColor,
                                shape: StadiumBorder(),
                                child: Text(
                                  'Ver promoción',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    } else {
      return CarouselSlider(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 6),
        height: 240,
        viewportFraction: 1.0,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
        items: widget.promotions.map((data) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        offset: Offset(0, 4),
                        blurRadius: 9)
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 16 / 8.6,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                  child: Image.asset(
                                'assets/img/gifcarrucel.gif',
                                fit: BoxFit.fill,
                              )),
                              imageUrl: data.image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 260,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(1),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(6),
                                      topLeft: Radius.circular(6))),
                              child: Text(
                                data.name,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 120,
                        right: 200,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: FlatButton(
                                onPressed: () {
//                              Navigator.of(context).pushNamed('/Checkout');
                                },
                                padding: EdgeInsets.symmetric(vertical: 5),
                                color: Theme.of(context).accentColor,
                                shape: StadiumBorder(),
                                child: Text(
                                  'Ver promoción',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      );
    }
  }
}
