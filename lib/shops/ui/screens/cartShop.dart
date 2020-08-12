import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/animations/FadeAnimatios.dart';
import 'package:kushi/components/custom_button.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/payment.options.cart.dart';
import 'package:kushi/shops/model/post.json.cost.env.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/shops/ui/payment/pages/checkout.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/shops/ui/screens/checkout_done.dart';
import 'package:kushi/shops/ui/screens/shop.List.Prod.dart';
import 'package:kushi/user/model/address.client.model.dart';
import 'package:kushi/user/ui/widgets/appBarNotification.dart';
import 'package:provider/provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ui_icons.dart';
import 'package:kushi/shops/ui/widgets/CartItemWidget.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CartWidget extends StatefulWidget {
  UserModel userData;
  Business supermarkets;
  CartWidget({
    this.supermarkets,
    this.userData,
    Key key,
  }) : super(key: key);

  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final GlobalKey<FormState> _formKeyCupon = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKeyCartShop =
      GlobalKey<ScaffoldState>();
  List<ProductModel> productNewList = new List<ProductModel>();
  ShopRepository _serviceTodoRapidAPI;
  List<ProductModel> productNewQuery = new List<ProductModel>();
  List<ProductCod> productCode = new List<ProductCod>();
  List<AddressClient> listAdreesClient;
  TextEditingController _cupon;
  CuponEnv modelcupon;
  String descriptionNote = "";
  AddressClient itemPermAddress;

  /* funciones para habilitar los  widgets */
  bool listAddressClient = true;
  bool itemAddressPrem = true;
  bool cartEmpy = true;
  bool formPayment = true;
  bool enableNoteUser = true;
  bool enableTextSubtitleNote = true;
  bool existContainsKey = true;
  /*  fin */
  @override
  void initState() {
    _serviceTodoRapidAPI = Ioc.get<ShopRepository>();
    getAddressClient();
    valueDescriptionNote();
    super.initState();
    queryCostoEnvio();
    modelcupon = new CuponEnv();
  }

  void valueDescriptionNote() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey('notePaymentUser')) {
      setState(() {
        widget.userData.descriptionNote =
            _preferences.getString('notePaymentUser');
        existContainsKey = true;
        enableTextSubtitleNote = false;
      });
    } else {
      setState(() {
        widget.userData.descriptionNote = "";
        existContainsKey = false;
        enableTextSubtitleNote = true;
      });
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKeyCartShop.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      duration: Duration(milliseconds: 8000),
      content: Text(value),
    ));
  }

  String layout = 'list';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKeyCartShop,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: new IconButton(
              icon: new Icon(UiIcons.return_icon,
                  color: Theme.of(context).hintColor),
              onPressed: () {
                Provider.of<InterceptApp>(context).costRemoveDouble();
                Provider.of<InterceptApp>(context).descRemoveDouble();
                Provider.of<InterceptApp>(context).removeEneableButton();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext contex) => BlocProvider(
                        child: ShopsProduct(
                          supermarkets: widget.supermarkets,
                          userData: widget.userData,
                        ),
                        bloc: ShopBloc(),
                      ),
                    ));
              }),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Center(
            child: Text(
              'Carro de Compras',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          actions: <Widget>[
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              child: AppBarNotificatios(
                user: widget.userData,
                scaffoldKey: _scaffoldKeyCartShop,
              ),
            ),
            Container(
                width: 30,
                height: 30,
                margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(300),
                  onTap: () {
                    //Navigator.of(context).pushNamed('/Tabs', arguments: 1);
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.userData.urlImage),
                  ),
                )),
          ],
        ),
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.shopping_cart,
                          color: Theme.of(context).hintColor,
                          size: 30,
                        ),
                        title: Text(
                          'Productos',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        subtitle: Text(
                          'verifica la catidad de  productos ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ),
                    Consumer<InterceptApp>(
                      builder: (BuildContext context, InterceptApp value,
                          Widget child) {
                        productNewList = value.lista();
                        if (value.lista().length == 0) {
                          cartEmpy = false;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Image.asset(
                                    'assets/img/empyCardShoping.png'),
                              ),
                            ],
                          );
                        }
                        cartEmpy = true;
                        return Column(
                          children: <Widget>[
                            Offstage(
                              offstage: this.layout != 'list' ||
                                  value.lista().isEmpty,
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: value.lista().length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 15);
                                },
                                itemBuilder: (context, index) {
                                  return CartItemWidget(
                                    product: value.lista().elementAt(index),
                                    heroTag: 'cart' + index.toString(),
                                    key: UniqueKey(),
                                    onDismissed: () {
                                      Provider.of<InterceptApp>(context)
                                          .remobeProductCart(index);
                                      queryCostoEnvio();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    cartEmpy
                        ? Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Tu dirección',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    !listAddressClient
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            onPressed: () {
                                              setState(() =>
                                                  listAddressClient = true);
                                            },
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              addessClient(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 0),
                                      leading: Icon(
                                        Icons.note,
                                        color: Theme.of(context).hintColor,
                                        size: 30,
                                      ),
                                      title: Row(
                                        children: <Widget>[
                                          Text(
                                            'Nota',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                          !existContainsKey
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.add_comment,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  onPressed: () {
                                                    setState(() =>
                                                        enableNoteUser = false);
                                                  },
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  onPressed: () {
                                                    alertInfodeleteNoteUser();
                                                  },
                                                )
                                        ],
                                      ),
                                      subtitle: enableNoteUser
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                enableTextSubtitleNote
                                                    ? Text(
                                                        'Nota para la tienda (alguna obserbación u petición)',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption,
                                                      )
                                                    : Text(
                                                        widget.userData
                                                            .descriptionNote,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption,
                                                      ),
                                              ],
                                            )
                                          : commentaryUser(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    Consumer<InterceptApp>(
                      builder: (BuildContext context, InterceptApp value,
                          Widget child) {
                        productCode = Provider.of<InterceptApp>(context)
                            .listaCodProdCostEnv();
                        double costoProducto = 0.00;
                        double costoEnvio = 0.00;
                        double descuento = 0.00;
                        double total = 0.00;

                        value.lista().forEach(
                          (product) {
                            costoProducto += (double.parse(product.price) *
                                product.quantity);
                          },
                        );

                        if (value.lista().length > 0) {
                          costoEnvio = value.costoEnvioProducto();
                          descuento = value.descuentoProduct();
                          total = costoProducto + costoEnvio - descuento;
                        }
                        if (value.lista().length == 0) {
                          return Container();
                        } else {
                          if (value.isNotEmpityCostDv() == false) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset('assets/img/proceso.png'),
                                  Text(
                                      'Su dirección esta fuera de la zona de delivery, registre otra dirección ubicada más al centro de tu ciudad',
                                      textAlign: TextAlign.center),
                                  SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            );
                          } else if (value.isNotEmptyCosto() == false) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset('assets/img/proceso.png'),
                                  Text(
                                      'No esta dentro de nuestra dentro de nuestra sona de delivery \n o no tiene precio de delivery',
                                      textAlign: TextAlign.center),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: () {
                                      queryCostoEnvio();
                                    },
                                  )
                                ],
                              ),
                            );
                          } else {
                            return formPayment
                                ? formResult(
                                    costoProducto, costoEnvio, descuento, total)
                                : Container();
                          }
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Salir'),
              content: Text('¿Esta seguro que desea salir de la aplicación?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'No',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                FlatButton(
                  onPressed: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                  child: Text(
                    'Si',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void queryCostoEnvio() {
    Future<void>.delayed(const Duration(seconds: 2)).then<void>((_) {
      Provider.of<InterceptApp>(context).clearListCostoEnvio();
      if (productNewList.length > 0) {
        for (var item in productNewList) {
          Provider.of<InterceptApp>(context)
              .addCostoEnvio(ProductCod(item.idprod.toString()));
        }
        _serviceTodoRapidAPI
            .queryCostoEnvioRepositoy(widget.supermarkets.uid.toString(),
                widget.userData.idAdrres.toString(), productCode)
            .then((double result) {
          print(result);
          if (result == -404.01 || result == -401.01 || result == -500.01) {
            Provider.of<InterceptApp>(context).removeEmptyCosto();
            // _showAlertDialogMessage('La empreza no tiene zona de delivery');
          } else {
            if (result == -1.0) {
              Provider.of<InterceptApp>(context).removeEmptyCosto();
              Provider.of<InterceptApp>(context).isValuetEmpityCostDv();
            } else if (result >= 0.0) {
              Provider.of<InterceptApp>(context).removeEmptyCosto();
              Provider.of<InterceptApp>(context).isValuetDateCostDv();
              Provider.of<InterceptApp>(context).costSetDouble(result);
              Provider.of<InterceptApp>(context).enableFunctionButtonCart();
            } else {
              showInSnackBar('¡Vaya!, algo no va');
            }
          }
        });
      }
    });
  }

  Widget commentaryUser() {
    return Column(
      children: <Widget>[
        CupertinoTextField(
          cursorColor: Theme.of(context).primaryColor,
          maxLines: 10,
          onChanged: (value) {
            descriptionNote = value;
          },
          style: Theme.of(context).textTheme.caption,
          minLines: 3,
          placeholder: "Encriba aquí su nota",
          padding: EdgeInsets.all(10),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                valueButtonPreferenceNote(),
                RawMaterialButton(
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  shape: CircleBorder(),
                  elevation: 2,
                  splashColor: Colors.transparent,
                  fillColor: Colors.redAccent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    descriptionNote = "";
                    setState(() {
                      enableNoteUser = true;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget valueButtonPreferenceNote() {
    return RawMaterialButton(
      child: Icon(
        Icons.check,
        color: Colors.white,
      ),
      shape: CircleBorder(),
      elevation: 3,
      splashColor: Colors.transparent,
      fillColor: Theme.of(context).accentColor,
      highlightColor: Colors.transparent,
      onPressed: () {
        saveNotePreference();
      },
    );
  }

  void alertInfodeleteNoteUser() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('¿Seguro que desea eliminar esta nota?'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'SI',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                removeNotePreference();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'NO',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void saveNotePreference() async {
    if (descriptionNote.isNotEmpty) {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      _preferences.setString('notePaymentUser', descriptionNote);
      setState(() {
        enableNoteUser = true;
      });
      valueDescriptionNote();
    } else {
      showInSnackBar('¡Nota vacía! \n porfavor agregar una nota');
    }
  }

  void removeNotePreference() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('notePaymentUser');
    setState(() {
      enableNoteUser = true;
    });
    showInSnackBar('¡Hecho! \n Nota borrada');
    valueDescriptionNote();
  }

  Widget formResult(
      double costoProducto, double costoEnvio, double descuento, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ListTile(
          dense: true,
          title: Text(
            "Monto a pagar",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          trailing: Icon(
            Icons.remove,
            color: Theme.of(context).accentColor.withOpacity(0.3),
          ),
        ),
        SizedBox(
          height: 17,
        ),
        Form(
          key: _formKeyCupon,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 60,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]),
                  ),
                ),
                child: TextFormField(
                  controller: _cupon,
                  onSaved: (value) => modelcupon.cupon = value,
                  onChanged: (value) async {
                    if (value.length == 0) {
                      SharedPreferences _preferences =
                          await SharedPreferences.getInstance();
                      _preferences.remove('cupon');
                      Provider.of<InterceptApp>(context).descSetDouble(0.0);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Ingrese su cupón',
                    hintStyle: Theme.of(context).textTheme.caption,
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
                child: RaisedButton(
                  onPressed: () {
                    queryCupon();
                  },
                  child: Text(
                    "Consultar",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  'Sub. Total:',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'Delivery:',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'Descuento:',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'Total:',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            SizedBox(
              width: 50.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  'S/.${costoProducto.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'S/.${costoEnvio.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'S/.${descuento.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'S/.${total.toStringAsFixed(2)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Consumer<InterceptApp>(
          builder: (BuildContext context, InterceptApp value, Widget child) {
            if (value.enableButtons() == false) {
              return Container();
            } else {
              if (value.enableButtonEfectivo() == true) {
                return child;
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        'Hablitando...',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }
            }
          },
          child: FadeAnimation(
              1,
              Container(
                margin: EdgeInsets.only(top: 10.0),
                height: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      height: 200,
                      child: valueLengthOptionPayemnt(
                          costoEnvio, costoProducto, descuento, total),
                    )
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget valueLengthOptionPayemnt(
      double costoEnvio, costoProducto, descuento, total) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: paymentItems.length,
      itemBuilder: (BuildContext context, int index) {
        return itemMethodPayment(DataDetailPayment(
          paymentOptions: paymentItems[index],
          business: widget.supermarkets,
          userModel: widget.userData,
          costoEnvio: costoEnvio,
          costoProducto: costoProducto,
          descuento: descuento,
          total: total,
        ));
      },
    );
  }

  Widget itemMethodPayment(DataDetailPayment data) {
    final size = MediaQuery.of(context).size;
    if (size.width > 500) {
      return Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 4.0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                image: AssetImage(
                  data.paymentOptions.photo,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 150.0,
                            child: CustomButton(
                              text: data.paymentOptions.name,
                              isInverse: true,
                              size: BtnSize.sm,
                              onPressed: () {
                                redirectionPayment(data);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 4.0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                image: AssetImage(
                  data.paymentOptions.photo,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 150.0,
                            child: CustomButton(
                              text: data.paymentOptions.name,
                              isInverse: true,
                              size: BtnSize.sm,
                              onPressed: () {
                                redirectionPayment(data);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void redirectionPayment(DataDetailPayment data) {
    if (data.total != 0.0) {
      if (data.total >= double.parse(widget.supermarkets.cantMinPayment)) {
        verifyShopPayment(data);
      } else {
        showInSnackBar("La compra minima es de :" +
            "S/." +
            widget.supermarkets.cantMinPayment);
      }
    } else {
      showInSnackBar('¡' +
          'No hay productos en el carrido de ' +
          widget.supermarkets.name +
          '!');
    }
  }

  void verifyShopPayment(DataDetailPayment data) async {
    if (data.paymentOptions.typePayment == 7) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            child: CheckoutWidget(
              userModel: data.userModel,
              business: data.business,
              payment: PaymetProductDetail(
                  desCupon: '',
                  costoProd: data.costoProducto,
                  costoEnv: data.costoEnvio,
                  descuento: data.descuento,
                  typeOptionPayment: data.paymentOptions.typePayment,
                  total: data.total),
            ),
            bloc: ShopBloc(),
          ),
        ),
      );
    } else {
      Provider.of<InterceptApp>(context).enableFunctionButtonEfectivo();
      routeView(data);
    }
  }

  void routeView(DataDetailPayment data) {
    _serviceTodoRapidAPI
        .verifyShopPaymet(widget.userData.idCliente.toString(),
            widget.supermarkets.uid.toString())
        .then((value) {
      if (value == 404 || value == 500) {
        Provider.of<InterceptApp>(context).removeEneableButtonEfectivo();
        showInSnackBar("Ocurrio un error al habilitar este metodo de pago");
      } else if (value == 1) {
        Provider.of<InterceptApp>(context).removeEneableButtonEfectivo();
        showInSnackBar(
            "Usted cuenta con una compra pendiente de pago, \n no se permite tener dos compras en el mismo estado.");
      } else if (value == 0) {
        if (data.paymentOptions.typePayment == 5) {
          _serviceTodoRapidAPI
              .queryOptionValuePaymentRepository(
                  data.paymentOptions.typePayment.toString(),
                  widget.supermarkets.uid.toString())
              .then(
            (status) {
              if (status == 200) {
                Provider.of<InterceptApp>(context)
                    .removeEneableButtonEfectivo();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => BlocProvider(
                      child: CheckoutDoneWidget(
                        userModel: widget.userData,
                        payment: PaymetProductDetail(
                            desCupon: '',
                            costoProd: data.costoProducto,
                            costoEnv: data.costoEnvio,
                            descuento: data.descuento,
                            total: data.total,
                            typeOptionPayment: data.paymentOptions.typePayment),
                        business: data.business,
                        titleView: "Pago en Efectivo",
                      ),
                      bloc: ShopBloc(),
                    ),
                  ),
                );
              } else if (status == 404) {
                Provider.of<InterceptApp>(context)
                    .removeEneableButtonEfectivo();
                showInSnackBar(
                    'La Empresa ${widget.supermarkets.name}, no cuenta con ese método de pago');
              } else {
                Provider.of<InterceptApp>(context)
                    .removeEneableButtonEfectivo();
                showInSnackBar('Kushi no pudo comunicarse con internet');
              }
            },
          );
        } else {
          _serviceTodoRapidAPI
              .queryOptionValuePaymentRepository(
                  data.paymentOptions.typePayment.toString(),
                  widget.supermarkets.uid.toString())
              .then(
            (status) {
              if (status == 200) {
                Provider.of<InterceptApp>(context)
                    .removeEneableButtonEfectivo();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => BlocProvider(
                      child: CheckoutDoneWidget(
                        userModel: widget.userData,
                        payment: PaymetProductDetail(
                            desCupon: '',
                            costoProd: data.costoProducto,
                            costoEnv: data.costoEnvio,
                            descuento: data.descuento,
                            total: data.total,
                            typeOptionPayment: data.paymentOptions.typePayment),
                        business: data.business,
                        titleView: "Paga con POS",
                      ),
                      bloc: ShopBloc(),
                    ),
                  ),
                );
              } else if (status == 404) {
                Provider.of<InterceptApp>(context)
                    .removeEneableButtonEfectivo();
                showInSnackBar(
                    'La Empresa ${widget.supermarkets.name}, no cuenta con ese método de pago');
              } else {
                Provider.of<InterceptApp>(context)
                    .removeEneableButtonEfectivo();
                showInSnackBar('Kushi no pudo comunicarse con internet');
              }
            },
          );
        }
      }
    });
  }

  void queryCupon() async {
    if (_formKeyCupon.currentState.validate()) {
      _formKeyCupon.currentState.save();
      if (modelcupon.cupon.length > 0) {
        _serviceTodoRapidAPI
            .queryDescCuponRepository(
                modelcupon.cupon, widget.supermarkets.uid.toString())
            .then((result) async {
          if (result.status == 200) {
            print(result.valueCupon);
            Provider.of<InterceptApp>(context).descSetDouble(result.valueCupon);
            showInSnackBar('Cupón Aceptado');
          } else if (result.status == 404) {
            SharedPreferences _preferences =
                await SharedPreferences.getInstance();
            _preferences.remove('cupon');
            if (result.errorCode == "CUP01") {
              _showAlertDialogMessage(result.message);
            } else if (result.errorCode == "CUP02") {
              _showAlertDialogMessage(result.message);
            } else if (result.errorCode == "CUP03") {
              _showAlertDialogMessage(result.message);
            } else {
              showInSnackBar('Algo no va bien, ingrese el cupón nuevamente');
            }
          } else {
            showInSnackBar('Ocurrio un error inesperado');
          }
        });
      } else {
        showInSnackBar('El campo cupón no puede estar vacío');
      }
    }
  }

  void _showAlertDialogMessage(String message) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Aceptar',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getAddressClient() {
    _serviceTodoRapidAPI
        .getAddressClient(widget.userData.idCliente.toString())
        .then((value) {
      setState(() {
        listAdreesClient = value.listAdrress;
      });
    });
  }

  Widget addessClient() {
    if (listAdreesClient != null) {
      if (itemAddressPrem == true) {
        if (listAdreesClient.length == 0) {
          return Container();
        } else {
          final data =
              listAdreesClient.where((a) => a.predeterminada == "1").toList();
          if (data.length == 0) {
            setState(() {
              widget.userData.idAdrres = 0;
              formPayment = false;
            });
            return listAddressClient
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/img/notfontAddress.png'),
                        Text(
                            'No encontre ninguna dirección predeterminada, para hacer seleccionar una direccion predeterinada  haga presione el boton "Escoger mi dirección"  y seleccione la direccion que desea dando precionando el boton azul',
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 320,
                          child: FlatButton(
                            onPressed: () {
                              setState(() => listAddressClient = false);
                            },
                            padding: EdgeInsets.symmetric(vertical: 14),
                            color: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Agregar dirección',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : listAdrees(listAdreesClient);
          } else {
            setState(() {
              widget.userData.idAdrres = data[0].id;
              formPayment = true;
            });
            return listAddressClient
                ? Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.location_on,
                        color: Theme.of(context).hintColor,
                        size: 30,
                      ),
                      title: Row(
                        children: <Widget>[
                          Text(
                            data[0].nameAdrres,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              setState(() => listAddressClient = false);
                            },
                          )
                        ],
                      ),
                      subtitle: Text(
                        data[0].address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  )
                : listAdrees(listAdreesClient);
          }
        }
      } else {
        setState(() {
          widget.userData.idAdrres = itemPermAddress.id;
          formPayment = true;
        });
        return listAddressClient
            ? Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.location_on,
                    color: Theme.of(context).hintColor,
                    size: 30,
                  ),
                  title: Row(
                    children: <Widget>[
                      Text(
                        itemPermAddress.nameAdrres,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          setState(() => listAddressClient = false);
                        },
                      )
                    ],
                  ),
                  subtitle: Text(
                    itemPermAddress.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              )
            : listAdrees(listAdreesClient);
      }
    } else {
      return Center(
        child: Text('Cargando...'),
      );
    }
  }

  Widget listAdrees(List<AddressClient> data) {
    return Offstage(
      offstage: this.layout != 'list' || data.isEmpty,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 15),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: data.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 15);
        },
        itemBuilder: (context, index) {
          return itemAddressClient(data.elementAt(index));
        },
      ),
    );
  }

  Widget itemAddressClient(AddressClient item) {
    return InkWell(
      child: Container(
        color: Theme.of(context).focusColor.withOpacity(0.15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            imagevaluePreference(item),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    item.nameAdrres,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .merge(TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Text(
                    item.address,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Container(
                    height: 30,
                    child: Row(
                      children: <Widget>[
                        valueButtonPreference(item),
                        RawMaterialButton(
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          shape: CircleBorder(),
                          elevation: 2,
                          splashColor: Colors.transparent,
                          fillColor: Colors.redAccent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            alertInfodeleteAddress(item.id.toString());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Provider.of<InterceptApp>(context).costRemoveDouble();
        Provider.of<InterceptApp>(context).removeEneableButton();
        queryCostoEnvio();
        setState(() {
          listAddressClient = true;
          itemPermAddress = item;
          itemAddressPrem = false;
        });
      },
    );
  }

  Widget imagevaluePreference(AddressClient item) {
    if (item.predeterminada == "0") {
      return Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
              image: AssetImage('assets/img/mylocations.png'),
              fit: BoxFit.cover),
        ),
      );
    } else {
      return Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
              image: AssetImage('assets/img/locationOn.png'),
              fit: BoxFit.cover),
        ),
      );
    }
  }

  Widget valueButtonPreference(AddressClient item) {
    if (item.predeterminada == "0") {
      return RawMaterialButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        elevation: 3,
        splashColor: Colors.transparent,
        fillColor: Theme.of(context).accentColor,
        highlightColor: Colors.transparent,
        onPressed: () {
          alertAddPreferenceAddressClient(
              widget.userData.idCliente.toString(), item.id.toString());
        },
      );
    } else {
      return RawMaterialButton(
        child: Icon(
          Icons.location_on,
          color: Colors.white,
        ),
        shape: CircleBorder(),
        elevation: 3,
        splashColor: Colors.transparent,
        fillColor: Theme.of(context).accentColor,
        highlightColor: Colors.transparent,
        onPressed: () {
          showInSnackBar('Esta es tu dirección que te llegara tus pedidos');
        },
      );
    }
  }

  void alertInfodeleteAddress(String idAdress) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('¿Seguro que desea eliminar esta dirección?'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'SI',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                deleAddrresClient(context, idAdress);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'NO',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  deleAddrresClient(BuildContext context, String idAdress) {
    if (listAdreesClient.length > 1) {
      _serviceTodoRapidAPI.removeAddressClient(idAdress).then(
        (value) {
          if (value == 200) {
            Navigator.pop(context);
            showInSnackBar('Hecho, dirección eliminada');
            getAddressClient();
          } else if (value == 404 || value == 401 || value == 403) {
            Navigator.pop(context);
            showInSnackBar('¡Vaya!, error al borrar esta dirección');
          } else {
            Navigator.pop(context);
            showInSnackBar('¡Chispas!, peticion no procesada');
          }
        },
      );
    } else {
      Navigator.pop(context);
      showInSnackBar(
          'Es necesario contar con al menos una dirección registrada.');
    }
  }

  void alertAddPreferenceAddressClient(String idClient, String idAddress) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('¿Desea agregar esta dirección como \n predeterminada?'),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'SI',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                addPreferenceAddressClient(context, idClient, idAddress);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                'NO',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  addPreferenceAddressClient(
      BuildContext context, String idClient, String idAddress) {
    _serviceTodoRapidAPI
        .addPreferenceAddressClient(idClient, idAddress)
        .then((value) {
      if (value == 200) {
        Navigator.pop(context);
        showInSnackBar(
            'Gracias por seleccionar su dirección \n y hacerla predeterminada');
        Provider.of<InterceptApp>(context).costRemoveDouble();
        Provider.of<InterceptApp>(context).removeEneableButton();
        queryCostoEnvio();
        setState(() {
          itemAddressPrem = true;
          listAddressClient = true;
        });
        getAddressClient();
      } else if (value == 404 || value == 401 || value == 403 || value == 400) {
        Navigator.pop(context);
        showInSnackBar('¡Vaya!, error al hacer predeterminada esta dirección');
      } else {
        Navigator.pop(context);
        showInSnackBar('No obtengo respuesta de internet');
      }
    });
  }
}
