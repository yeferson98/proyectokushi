import 'package:flutter/cupertino.dart';
import 'package:kushi/pushproviders/push_notification_provider.dart';
import 'package:kushi/shops/model/post.json.cost.env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kushi/shops/model/product.color.model.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/model/product.size.model.dart';

class InterceptApp with ChangeNotifier {
  final List<ProductModel> _items = [];
  final List<ProductSizeModel> _itemProductZize = [];
  final List<ProductColorModel> _itemProductColor = [];
  final List<ProductCod> costoenvioList = [];

  InterceptApp() {
    _verifyAuthUser();
    //initNotification();
  }

  int quantity = 0;
  bool numberexit = false;
  Color alertcolor;
  String message;
  bool _loggendIn = false;
  SharedPreferences _preferences;

  List lista() => _items;
  List listaSize() => _itemProductZize;
  List listaColor() => _itemProductColor;
  int cantidad() => quantity;

  Color color() => alertcolor;
  String messageresult() => message;
  bool numberExit() => numberexit;
  void queryNumber(Color col, String mess) {
    numberexit = true;
    alertcolor = col;
    message = mess;
    notifyListeners();
  }

  void addProdCart(ProductModel item) {
    if (item.quantity == 0) {
      _items.removeWhere((p) => p.idprod == item.idprod);
      notifyListeners();
    } else if (item.quantity >= 1) {
      final data = _items.where((p) => p.idprod == item.idprod).toList();
      if (data.length == 0) {
        _items.add(item);
        notifyListeners();
      } else {
        _items.removeWhere((p) => p.idprod == data[0].idprod);
        _items.add(item);
        notifyListeners();
      }
    } else {}
  }

  void addProdCartMltp(ProductModel item) {
    if (item.quantity == 0) {
      _items.removeWhere((p) => p.id == item.id);
      notifyListeners();
    } else if (item.quantity >= 1) {
      final data = _items.where((p) => p.id == item.id).toList();
      if (data.length == 0) {
        _items.add(item);
        notifyListeners();
      } else {
        _items.removeWhere((p) => p.id == data[0].id);
        _items.add(item);
        notifyListeners();
      }
    } else {}
  }

  void addMlProduct(ProductModel item) {
    final data = _items.where((p) => p.idprod == item.idprod);
    if (data.length > 0) {
      final color =
          data.where((p) => p.idCol == item.idCol && p.idSize == item.idSize);
      if (color.length == 0) {
        _items.add(item);
        notifyListeners();
      } else {}
    } else {
      _items.add(item);
      notifyListeners();
    }
  }

  Future<int> queryexistSize(
    int idSize,
    int idcolor,
    int idProduct,
  ) async {
    final result = _items
        .where((i) =>
            i.idSize == idSize &&
            i.idCol == idcolor.toString() &&
            i.idprod == idProduct)
        .toList();
    return result.length;
  }

  List listaCodProdCostEnv() => costoenvioList;
  void addCostoEnvio(ProductCod costoenvio) {
    final costoexist = costoenvioList
        .where((c) => c.codProduct == costoenvio.codProduct)
        .toList();
    if (costoexist.length == 0) {
      costoenvioList.add(costoenvio);
    }
  }

  void clearListCostoEnvio() {
    costoenvioList.clear();
  }

  void removeCostoEnvio(String idProd) {
    costoenvioList.removeWhere((p) => p.codProduct == idProd);
    _preferences.remove('cupon');
  }

  /// remove product
  Future<bool> removeProductStockSop(
      List<GetProductEnStock> getstockprod) async {
    for (var item in getstockprod) {
      _items.removeWhere((p) =>
          p.idprod == int.parse(item.codProduct) &&
          p.idSize == item.codTalla &&
          p.idCol == item.codColor.toString());
    }
    notifyListeners();
    return true;
  }

  double tp = 0;
  double montoTotal() => tp;
  void sum() {
    notifyListeners();
  }

  double costoEnvio = 0.0;
  double costoEnvioProducto() => costoEnvio;
  void costSetDouble(double cant) {
    costoEnvio = cant;
    notifyListeners();
  }

  void costRemoveDouble() {
    costoEnvio = 0.0;
    notifyListeners();
  }

  double descuento = 0.0;
  double descuentoProduct() => descuento;
  void descSetDouble(double cant) {
    descuento = cant;
    notifyListeners();
  }

  void descRemoveDouble() {
    descuento = 0.0;
    notifyListeners();
  }

  void remobeProductCart(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void removeAllProductCart() {
    _items.clear();
    notifyListeners();
  }

  bool isLoggedIn() => _loggendIn;
  void _verifyAuthUser() async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey('isLoggedInUser')) {
      _loggendIn = true;
      notifyListeners();
    }
  }

  bool _isNotEmpityAdrres = true;
  bool isNotEmpityCostDv() => _isNotEmpityAdrres;
  void isValuetEmpityCostDv() {
    _isNotEmpityAdrres = false;
    notifyListeners();
  }

  void isValuetDateCostDv() {
    _isNotEmpityAdrres = true;
    notifyListeners();
  }

  bool _isNotEmpityCost = true;
  bool isNotEmptyCosto() => _isNotEmpityCost;
  void isNotEmptyCostoResl() {
    _isNotEmpityCost = false;
    notifyListeners();
  }

  void removeEmptyCosto() {
    _isNotEmpityCost = true;
    notifyListeners();
  }

  bool _enableButton = false;
  bool enableButtons() => _enableButton;
  void enableFunctionButtonCart() {
    _enableButton = true;
    notifyListeners();
  }

  void removeEneableButton() {
    _enableButton = false;
    notifyListeners();
  }

  bool _enableButtonEfectivo = true;
  bool enableButtonEfectivo() => _enableButtonEfectivo;
  void enableFunctionButtonEfectivo() {
    _enableButtonEfectivo = false;
    notifyListeners();
  }

  void removeEneableButtonEfectivo() {
    _enableButtonEfectivo = true;
    notifyListeners();
  }

  void singUpPrev() {
    _loggendIn = false;
    notifyListeners();
  }

  void initNotification() {
    final pushNotification = new PushNotificationProvider();
    pushNotification.initNotifications();
  }
}
