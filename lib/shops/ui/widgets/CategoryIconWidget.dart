import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kushi/shops/model/category.model.dart';

// ignore: must_be_immutable
class CategoryIconWidget extends StatefulWidget {
  CategoryModel category;
  String heroTag;
  double marginLeft;
  ValueChanged<String> onPressed;

  CategoryIconWidget(
      {Key key, this.category, this.heroTag, this.marginLeft, this.onPressed})
      : super(key: key);

  @override
  _CategoryIconWidgetState createState() => _CategoryIconWidgetState();
}

class _CategoryIconWidgetState extends State<CategoryIconWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsets.only(left: widget.marginLeft, top: 10, bottom: 10),
      child: buildSelectedCategory(context),
    );
  }

  InkWell buildSelectedCategory(BuildContext context) {
    if (widget.category.selected == null) {
      return InkWell(
          child: Container(
        child: Text('¿?',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      ));
    } else {
      return InkWell(
        splashColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).accentColor,
        onTap: () {
          setState(() {
            widget.onPressed(widget.category.uid.toString());
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: widget.category.selected.isNotEmpty
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: <Widget>[
              Hero(
                tag: widget.heroTag + widget.category.uid.toString(),
                child: Container(
                    height: 40,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Center(
                        child: Image.asset(
                          'assets/images/gif-icons.gif',
                          fit: BoxFit.cover,
                        ),
                      ),
                      imageUrl: widget.category.icon,
                      height: 30,
                    )),
              ),
              SizedBox(width: 10),
              AnimatedSize(
                duration: Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                vsync: this,
                child: Text(
                  widget.category.selected.isNotEmpty
                      ? widget.category.name
                      : '',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
