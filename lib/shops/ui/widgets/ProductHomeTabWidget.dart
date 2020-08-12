import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/shops/ui/widgets/FlashSalesCarouselWidget.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/product.color.model.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/model/product.size.model.dart';
import 'package:kushi/shops/repository/shops.repository.dart';

// ignore: must_be_immutable
class ProductHomeTabWidget extends StatefulWidget {
  ProductModel product;
  ValueChanged<ProductColorModel> onChangedColor;
  ValueChanged<ProductSizeModel> onChangedSize;
  Future<List<ProductModel>> products;
  ValueChanged<ProductModel> onChanged;
  Function(int) changeImageOnColorSelected;
  Business supermarkets;
  UserModel user;
  ProductHomeTabWidget(
      {this.product,
      this.products,
      this.supermarkets,
      this.user,
      @required this.onChangedColor,
      @required this.onChangedSize,
      @required this.onChanged,
      @required this.changeImageOnColorSelected});

  @override
  ProductHomeTabWidgetState createState() => ProductHomeTabWidgetState();
}

class ProductHomeTabWidgetState extends State<ProductHomeTabWidget> {
  String priceTash = "";
  ShopRepository _serviceTodoRapidAPI;
  @override
  void initState() {
    if (widget.product.priceTash == null) {
      priceTash = "";
    } else {
      priceTash = widget.product.money + widget.product.priceTash;
    }
    _serviceTodoRapidAPI = Ioc.get<ShopRepository>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .merge(TextStyle(fontSize: 18)),
                ),
              ),
              /*Chip(
                padding: EdgeInsets.all(0),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.product.price.toString(),
                        style: Theme.of(context).textTheme.body2.merge(
                            TextStyle(color: Theme.of(context).primaryColor))),
                    Icon(
                      Icons.star_border,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                shape: StadiumBorder(),
              ),*/
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(widget.product.money + widget.product.price,
                  style: Theme.of(context).textTheme.headline2),
              SizedBox(width: 90),
              Text(
                priceTash,
                style: Theme.of(context).textTheme.headline5.merge(TextStyle(
                    color: Theme.of(context).focusColor,
                    decoration: TextDecoration.lineThrough)),
              ),
            ],
          ),
        ),
        _colorsAndSizeProduct(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.box,
              color: Theme.of(context).hintColor,
            ),
            title: Text('Productos relacionados',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .merge(TextStyle(fontSize: 18))),
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
              case ConnectionState.active:
                List<ProductModel> products = snapshot.data;
                final data = products
                    .where((p) => p.idCategory == widget.product.idCategory)
                    .toList();
                return FlashSalesCarouselWidget(
                    heroTag: 'product_related_products',
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
                } else {
                  final data = products
                      .where((p) => p.idCategory == widget.product.idCategory)
                      .toList();
                  return FlashSalesCarouselWidget(
                      heroTag: 'product_related_products',
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

  Widget _colorsAndSizeProduct() {
    if (widget.product.ismultiColors == 1) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            BlocProvider(
              child: SectionColorAndSizeWidget(
                  idProduct: widget.product.idprod,
                  onChangedColor: widget.onChangedColor,
                  onChangedSize: widget.onChangedSize,
                  changeImageOnColorSelected:
                      widget.changeImageOnColorSelected),
              bloc: ShopBloc(),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

// ignore: must_be_immutable
class SectionColorAndSizeWidget extends StatefulWidget {
  ValueChanged<ProductColorModel> onChangedColor;
  ValueChanged<ProductSizeModel> onChangedSize;
  int idProduct;
  Function(int) changeImageOnColorSelected;
  SectionColorAndSizeWidget(
      {Key key,
      @required this.idProduct,
      this.onChangedColor,
      this.onChangedSize,
      @required this.changeImageOnColorSelected})
      : super(key: key);

  @override
  _SectionColorAndSizeWidgetState createState() =>
      _SectionColorAndSizeWidgetState();
}

class _SectionColorAndSizeWidgetState extends State<SectionColorAndSizeWidget> {
  List<ProductColorModel> _productColorModel = new List<ProductColorModel>();
  List<ProductSizeModel> _productSizeModel = new List<ProductSizeModel>();
  ShopRepository _serviceTodoRapidAPI;
  SharedPreferences _preferences;
  bool isSizeSlect = false;
  @override
  void initState() {
    super.initState();
    _serviceTodoRapidAPI = Ioc.get<ShopRepository>();
    getColor();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Seleccione  color',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_productColorModel.length, (index) {
            var _color = _productColorModel.elementAt(index);
            if (_color.name == null) {
              return Text('Este producto no tiene color');
            } else {
              return buildColor(_color, index);
            }
          }),
        ),
        isSizeSlect
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.15),
                        blurRadius: 5,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Seleccione talla',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          List.generate(_productSizeModel.length, (index) {
                        var _size = _productSizeModel.elementAt(index);
                        return buildSize(_size);
                      }),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  SizedBox buildColor(ProductColorModel color, int index) {
    return SizedBox(
      width: 38,
      height: 38,
      child: FilterChip(
        label: Text(''),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        backgroundColor: Color.fromRGBO(int.parse(color.codR),
            int.parse(color.codG), int.parse(color.codB), 1.0),
        selectedColor: Color.fromRGBO(int.parse(color.codR),
            int.parse(color.codG), int.parse(color.codB), 1.0),
        selected: color.selected.isNotEmpty,
        shape: CircleBorder(),
        avatar: Text(''),
        onSelected: (bool value) async {
          if (value) {
            selected(value, color, index);
          } else {
            onselected(value, color);
          }
        },
      ),
    );
  }

  void selected(bool value, ProductColorModel color, int index) async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey('idCol')) {
      int id = _preferences.getInt('idCol');
      if (id != color.id) {
        setState(() {
          color.selected = '';
        });
      } else {
        setState(() {
          color.selected = value.toString();
          _preferences.setInt('idCol', color.id);
          isSizeSlect = true;
          widget.onChangedColor(color);
          widget.changeImageOnColorSelected(index);
        });
        color.idProduct = widget.idProduct.toString();
        getSize(color.id.toString());
      }
    } else {
      setState(() {
        color.selected = value.toString();
        _preferences.setInt('idCol', color.id);
        isSizeSlect = true;
        widget.onChangedColor(color);
        widget.changeImageOnColorSelected(index);
      });
      color.idProduct = widget.idProduct.toString();
      getSize(color.id.toString());
    }
  }

  void onselected(bool value, ProductColorModel color) async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      //widget.onChangedColor(null);
      isSizeSlect = false;
      _preferences.remove('idCol');
      color.selected = '';
      _preferences.remove('idSize');
    });
  }

  void getColor() async {
    List<ProductColorModel> _productColor = new List<ProductColorModel>();
    _productColor = await _serviceTodoRapidAPI
        .fetchProductColorsRepository(widget.idProduct.toString());
    if (_productColor.length > 0) {
      setState(() {
        _productColorModel = _productColor;
      });
    } else {}
  }

  SizedBox buildSize(ProductSizeModel size) {
    return SizedBox(
      height: 38,
      child: RawChip(
        label: Text(size.name),
        labelStyle: TextStyle(color: Theme.of(context).hintColor),
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        backgroundColor: Theme.of(context).focusColor.withOpacity(0.05),
        selectedColor: Theme.of(context).focusColor.withOpacity(0.2),
        selected: size.selected.isNotEmpty,
        shape: StadiumBorder(
            side: BorderSide(
                color: Theme.of(context).focusColor.withOpacity(0.05))),
        onSelected: (bool value) {
          if (value) {
            selectedSize(value, size);
          } else {
            onselectedSize(value, size);
          }
        },
      ),
    );
  }

  void selectedSize(bool value, ProductSizeModel size) async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey('idSize')) {
      int id = _preferences.getInt('idSize');
      if (id != size.id) {
        setState(() {
          size.selected = '';
        });
      } else {
        setState(() {
          size.selected = value.toString();
          _preferences.setInt('idSize', size.id);
        });
        widget.onChangedSize(size);
      }
    } else {
      setState(() {
        size.selected = value.toString();
        _preferences.setInt('idSize', size.id);
      });
      widget.onChangedSize(size);
    }
  }

  void onselectedSize(bool value, ProductSizeModel size) async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _preferences.remove('idSize');
      size.selected = '';
    });
    widget.onChangedSize(null);
    //widget.onChangedSize(null);
  }

  void getSize(String idColor) async {
    List<ProductSizeModel> _productSize = new List<ProductSizeModel>();
    _productSize = await _serviceTodoRapidAPI.fetchProductSizeRepository(
        widget.idProduct.toString(), idColor);
    setState(() {
      _productSizeModel = _productSize;
    });
  }
}
