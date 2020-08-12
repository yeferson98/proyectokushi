import 'package:flutter/cupertino.dart';
import 'package:kushi/shops/model/category.model.dart';
import 'package:kushi/shops/ui/widgets/CategoryIconWidget.dart';

// ignore: must_be_immutable
class ListCategoryFilter extends StatefulWidget {
  List<CategoryModel> category;
  String heroTag;
  ValueChanged<String> onChanged;

  ListCategoryFilter({Key key, this.heroTag, this.onChanged, this.category})
      : super(key: key);
  @override
  _ListCategoryFilterState createState() => _ListCategoryFilterState();
}

class _ListCategoryFilterState extends State<ListCategoryFilter> {
  List<CategoryModel> categoryFilter = List<CategoryModel>();
  @override
  void initState() {
    categoryFilter = widget.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categoryFilter.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        double _marginLeft = 0;
        (index == 0) ? _marginLeft = 12 : _marginLeft = 0;
        return CategoryIconWidget(
            heroTag: widget.heroTag,
            marginLeft: _marginLeft,
            category: categoryFilter.elementAt(index),
            onPressed: (String id) {
              widget.onChanged(id);
            });
      },
      scrollDirection: Axis.horizontal,
    );
  }

  selectById(String id) {
    categoryFilter.forEach((CategoryModel category) {
      category.selected = "data";
      if (category.uid == int.parse(id)) {
        category.selected = "";
      }
    });
  }
}
