import 'package:flutter/material.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/model/category.model.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/shops/ui/widgets/CategoryIconWidget.dart';

// ignore: must_be_immutable
class CategoriesIconsCarouselWidget extends StatefulWidget {
  List<CategoryModel> category;
  String heroTag;
  ValueChanged<String> onChanged;
  Business business;
  CategoriesIconsCarouselWidget(
      {Key key,
      this.heroTag,
      this.onChanged,
      this.category,
      @required this.business})
      : super(key: key);

  @override
  _CategoriesIconsCarouselWidgetState createState() =>
      _CategoriesIconsCarouselWidgetState();
}

class _CategoriesIconsCarouselWidgetState
    extends State<CategoriesIconsCarouselWidget> {
  ShopRepository _serviceTodoRapidAPI;
  List<CategoryModel> listcategoryFilter = new List<CategoryModel>();
  @override
  void initState() {
    super.initState();
    _serviceTodoRapidAPI = Ioc.get<ShopRepository>();
    getategory();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: 130,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(1),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                  topRight: Radius.circular(60)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0),
              margin: EdgeInsets.only(left: 0.0, top: 10, bottom: 10, right: 9),
              child: InkWell(
                splashColor: Theme.of(context).accentColor,
                highlightColor: Theme.of(context).accentColor,
                onTap: () {
                  widget.onChanged('-1998');
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Todos',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      SizedBox(width: 10),
                      Hero(
                        tag: widget.heroTag,
                        child: Icon(
                          UiIcons.inbox,
                          color: Theme.of(context).accentColor,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor.withOpacity(1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    topLeft: Radius.circular(60)),
              ),
              child: ListView.builder(
                itemCount: listcategoryFilter.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  double _marginLeft = 0;
                  (index == 0) ? _marginLeft = 12 : _marginLeft = 0;
                  return CategoryIconWidget(
                      heroTag: widget.heroTag,
                      marginLeft: _marginLeft,
                      category: listcategoryFilter.elementAt(index),
                      onPressed: (String id) {
                        selectById(id);
                        widget.onChanged(id);
                      });
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  selectById(String id) {
    listcategoryFilter.forEach((CategoryModel category) {
      category.selected = "";
      if (category.uid == int.parse(id)) {
        category.selected = "data";
      }
    });
  }

  void getategory() async {
    List<CategoryModel> listcategory = new List<CategoryModel>();
    listcategory = await _serviceTodoRapidAPI
        .fetchCategoryRepository(widget.business.uid.toString());
    setState(() {
      listcategoryFilter = listcategory;
    });
  }
}
