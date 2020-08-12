import 'dart:convert';
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:http/http.dart' as http;
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/shops/model/favorite.model.dart';
import 'package:kushi/shops/model/hour.delivery.model.dart';
import 'package:kushi/shops/model/map.order.rest.dart';
import 'package:kushi/shops/model/order.detail.product.model.dart';
import 'package:kushi/shops/model/post.json.cost.env.dart';
import 'package:kushi/shops/model/response.model.costo.dart';
import 'package:kushi/shops/model/result.model.visa.shop.dart';
import 'package:kushi/shops/ui/payment/pages/model/mediopago.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/post.env.parms.delivery.dart';
import 'package:kushi/shops/ui/payment/pages/model/product,payment.save.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/shops/ui/payment/pages/model/request.apiKey.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/model/verify.code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kushi/shops/constants/shop.constant.dart';
import 'package:kushi/shops/model/category.model.dart';
import 'package:kushi/shops/model/product.color.model.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/model/product.size.model.dart';
import 'package:kushi/shops/model/promotions.model.dart';

class ShopApi {
  List<ProductModel> parseProduct(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ProductModel>((json) => ProductModel.formJson(json))
        .toList();
  }

  Future<List<ProductModel>> fetchProduct(
      String idBusiness, String idUser) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String token = _preferences.getString('Token');
    Map<String, String> headers = {
      "Authorization": "bearer" + token
    }; //http://api.todorapid.com/api/producto/cliente/{clientId}/getProductos/{empId}
    final response = await http.get(
        ShopContants.GETRODUCTS + idUser + '/getProductos/' + idBusiness,
        headers: headers);

    return parseProduct(response.body);
  }

  List<CategoryModel> parseCategory(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CategoryModel>((json) => CategoryModel.formJson(json))
        .toList();
  }

  Future<List<CategoryModel>> fetchCategory(String idBusiness) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String token = _preferences.getString('Token');
    Map<String, String> headers = {"Authorization": "bearer" + token};
    final response = await http.get(
        ShopContants.GETCATEGORY + idBusiness + '/categorias',
        headers: headers);

    return parseCategory(response.body);
  }

  List<PromotionsModel> parsePromotions(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<PromotionsModel>((json) => PromotionsModel.formJson(json))
        .toList();
  }

  Future<List<PromotionsModel>> fetchPromotions(String id) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String token = _preferences.getString('Token');
    Map<String, String> headers = {"Authorization": "bearer" + token};
    final response =
        await http.get(ShopContants.GETPROMOTIONS + id, headers: headers);

    return parsePromotions(response.body);
  }

  List<ProductColorModel> parseProductColor(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ProductColorModel>((json) => ProductColorModel.formJson(json))
        .toList();
  }

  Future<List<ProductColorModel>> fetchProductColors(String id) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String token = _preferences.getString('Token');
    Map<String, String> headers = {"Authorization": "bearer" + token};
    final response =
        await http.get(ShopContants.GETPRODUCTCOLORS + id, headers: headers);

    return parseProductColor(response.body);
  }

  List<ProductSizeModel> parseProductSize(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ProductSizeModel>((json) => ProductSizeModel.formJson(json))
        .toList();
  }

  Future<List<ProductSizeModel>> fetchProductSize(
      String id, String idcolor) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String token = _preferences.getString('Token');
    Map<String, String> headers = {"Authorization": "bearer" + token};
    final response = await http.get(
        ShopContants.GETPRODUCTSIZE + id + '/color/' + idcolor,
        headers: headers);

    return parseProductSize(response.body);
  }

  List<ProductModel> parseWishListProduct(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ProductModel>((json) => ProductModel.formJson(json))
        .toList();
  }

  Future<List<ProductModel>> fetchWishListProduct(String idUser) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String token = _preferences.getString('Token');
    Map<String, String> headers = {"Authorization": "bearer" + token};
    final response = await http.get(
        ShopContants.GETWISHLISTPRODUCT + idUser + '/listaDeseos',
        headers: headers);

    return parseWishListProduct(response.body);
  }

  Future<bool> saveProduductFavorite(
      String idProduct, String idUser, String idBusiness) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {"Authorization": "bearer" + token};
      var map = Map<String, dynamic>();
      map['Prod_Codigo'] = idProduct;
      map['Cli_Codigo'] = idUser;
      map['Emp_Codigo'] = idBusiness;
      var response = await http.post(ShopContants.POSTADDPRODUCTFAVORITE,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        FavoriteResultPost list = parseResponseCode(response.body);
        return list.error;
      } else if (response.statusCode == 400) {
        FavoriteResultPost list = parseResponseCode(response.body);
        return list.error;
      } else if (response.statusCode == 401) {
        FavoriteResultPost list = parseResponseCode(response.body);
        return list.error;
      } else {
        FavoriteResultPost list = parseResponseCode(response.body);
        return list.error;
      }
    } catch (e) {
      print('error =>' + e);
      return false;
    }
  }

  Future<bool> removeProduductFavorite(String idProduct, String idUser) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {"Authorization": "bearer" + token};
      var map = Map<String, dynamic>();
      map['Prod_Codigo'] = idProduct;
      map['Cli_Codigo'] = idUser;
      var response = await http.post(ShopContants.DELETEPRODUCTFAVORITE,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        FavoriteResultPost list = parseResponseCode(response.body);
        return list.error;
      } else if (response.statusCode == 400) {
        FavoriteResultPost list = parseResponseCode(response.body);
        return list.error;
      } else if (response.statusCode == 401) {
        FavoriteResultPost list = parseResponseCode(response.body);
        return list.error;
      } else {
        FavoriteResultPost list = parseResponseCode(response.body);
        return list.error;
      }
    } catch (e) {
      print('error =>' + e);
      return false;
    }
  }

  static FavoriteResultPost parseResponseCode(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    FavoriteResultPost result = FavoriteResultPost.formJson(map);
    return result;
  }

  Future<double> queryCostoEnvio(
      String idBusiness, String idAdrees, List<ProductCod> products) async {
    try {
      List<Map> carOptionJson = new List();
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
        'Content-type': 'application/json'
      };
      for (var items in products) {
        ProductCod carJson = new ProductCod(items.codProduct);
        carOptionJson.add(carJson.TojsonData());
      }
      var body = json.encode({
        "Emp_Codigo": idBusiness,
        "Cdi_Codigo": idAdrees,
        "Productos": carOptionJson
      });
      var response = await http.post(ShopContants.QUERYCOSTENVI,
          body: body, headers: headers);
      if (response.statusCode == 200) {
        return double.parse(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return -404.01;
      } else if (response.statusCode == 401) {
        return -401.01;
      } else {
        return -500.01;
      }
    } catch (e) {
      print(e);
      return -500.01;
    }
  }

  Future<RESPONSECOSTOMODEL> queryDescCupon(
      String cuponDesc, String idBusiness) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
      };
      var map = Map<String, dynamic>();
      map['Emp_Codigo'] = idBusiness;
      map['Cup_Serie'] = cuponDesc;
      var response =
          await http.post(ShopContants.QUERYDESC, body: map, headers: headers);
      if (response.statusCode == 200) {
        _preferences.setString('cupon', cuponDesc);
        return RESPONSECOSTOMODEL(
            valueCupon: double.parse(json.decode(response.body)), status: 200);
      } else if (response.statusCode == 404) {
        return fetchDescCupon(response.body);
      } else if (response.statusCode == 401) {
        return RESPONSECOSTOMODEL(status: 401);
      } else {
        return RESPONSECOSTOMODEL(status: 500);
      }
    } catch (e) {
      print(e);
      return RESPONSECOSTOMODEL(status: 500);
    }
  }

  static RESPONSECOSTOMODEL fetchDescCupon(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    RESPONSECOSTOMODEL enviosms = RESPONSECOSTOMODEL.formJson(map);
    return enviosms;
  }

  Future<List<GetProductEnStock>> getStockExist(
      List<ProductModel> products) async {
    try {
      List<Map> carOptionJson = new List();
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
        'Content-type': 'application/json'
      };
      for (var items in products) {
        ProductEnStock carJson = new ProductEnStock(
            codProduct: items.idprod.toString(),
            codColor: items.idCol,
            codTalla: items.idSize.toString(),
            cantidad: items.quantity.toString());
        carOptionJson.add(carJson.TojsonData());
      }
      var body = json.encode({"Productos": carOptionJson});
      var response = await http.post(ShopContants.GETSTOCKEXIST,
          body: body, headers: headers);
      if (response.statusCode == 200) {
        return getstockExist(response.body);
      } else if (response.statusCode == 404) {
        return null;
      } else if (response.statusCode == 401) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<GetProductEnStock> getstockExist(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<GetProductEnStock>((json) => GetProductEnStock.formJson(json))
        .toList();
  }

  Future<int> verifyShopPaymet(String idClient, String idBusiness) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
      };
      var map = Map<String, dynamic>();
      map['Cli_Codigo'] = idClient;
      map['Emp_Codigo'] = idBusiness;
      var response = await http.post(ShopContants.VERIFYSHOPPAYMENT,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        return 404;
      } else if (response.statusCode == 500) {
        return 500;
      } else {
        return 500;
      }
    } catch (e) {
      print(e);
      return 500;
    }
  }

  Future<VERIFICODE> saveShopProduct(
      String codmediPago,
      String formapago,
      String estadoCom,
      String targetTypeOption,
      Business business,
      TimedateEnd delivery,
      UserModel user,
      PaymetProductDetail payment,
      List<ProductModel> products) async {
    try {
      List<Map> carOptionJson = new List();
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String seriecupon = _preferences.getString('cupon');
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
        'Content-type': 'application/json'
      };
      for (var items in products) {
        double montototal = double.parse(items.price) * items.quantity;
        ProductPayment carJson = new ProductPayment(
            cantidadPoducto: items.quantity.toString(),
            precioProducto: items.price,
            montoTotal: montototal.toStringAsFixed(2).toString(),
            codigoProducto: items.idprod.toString(),
            color: items.idCol,
            talla: items.idSize.toString(),
            image: items.imageList);
        carOptionJson.add(carJson.TojsonData());
      }
      var body;
      if (formapago == '1') {
        body = json.encode(
          {
            "Cdi_Codigo": user.idAdrres,
            "Com_SubTotal": payment.costoProd,
            "Com_Total": payment.total,
            "Com_Delivery": payment.costoEnv,
            "Com_CuponMonto": payment.descuento,
            "Com_Comentarios": user.descriptionNote,
            "Cup_Serie": seriecupon,
            "Ciu_Codigo": business.idcity,
            "Pais_Codigo": user.idPais,
            "Emp_Codigo": business.uid,
            "Pta_Codigo": targetTypeOption,
            "Com_FormaPago": formapago,
            "Cli_Codigo": user.idCliente,
            "Con_Estado": estadoCom,
            "Com_Fecha_Atencion": delivery.fecha,
            "Com_Hora_Atencion": delivery.hora,
            "Detalle": carOptionJson
          },
        );
      } else {
        body = json.encode(
          {
            "Cdi_Codigo": user.idAdrres,
            "Com_SubTotal": payment.costoProd,
            "Com_Total": payment.total,
            "Com_Delivery": payment.costoEnv,
            "Com_CuponMonto": payment.descuento,
            "Com_Comentarios": user.descriptionNote,
            "Cup_Serie": seriecupon,
            "Ciu_Codigo": business.idcity,
            "Pais_Codigo": user.idPais,
            "Emp_Codigo": business.uid,
            "Pta_Codigo": targetTypeOption,
            "Com_FormaPago": formapago,
            "ETar_Codigo": codmediPago,
            "Cli_Codigo": user.idCliente,
            "Con_Estado": estadoCom,
            "Com_Fecha_Atencion": delivery.fecha,
            "Com_Hora_Atencion": delivery.hora,
            "Detalle": carOptionJson
          },
        );
      }
      var response = await http.post(ShopContants.SAVESHOPPRODUCT,
          body: body, headers: headers);

      if (response.statusCode == 200) {
        return fetchResponseCode(response.body);
      } else if (response.statusCode == 401) {
        return VERIFICODE(status: 401);
      } else {
        return fetchResponseCode(response.body);
      }
    } catch (e) {
      print(e);
      return VERIFICODE(status: 002);
    }
  }

  static VERIFICODE fetchResponseCode(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    VERIFICODE enviosms = VERIFICODE.formJson(map);
    return enviosms;
  }

  Future<TokenApiKey> getApikeyTarget() async {
    try {
      var response = await http.get(ShopContants.GETAPIKEYPAYMENT);
      if (response.statusCode == 200) {
        return fetchApiKeyPayment(response.body, response.statusCode, true);
      } else {
        return fetchApiKeyPayment('', response.statusCode, false);
      }
    } catch (e) {
      print(e);
      return fetchApiKeyPayment('', 500, false);
    }
  }

  static TokenApiKey fetchApiKeyPayment(
      String responseBody, int code, bool status) {
    //final map = jsonDecode(responseBody) as Map<String, dynamic>;
    return TokenApiKey.fromJson(responseBody, code, status);
  }

  Future<RESULTTARGET> saveShopProductVISA(
      String codmediPago,
      String formapago,
      String estadoCom,
      String targetTypeOption,
      Business business,
      TimedateEnd delivery,
      UserModel user,
      PaymetProductDetail payment,
      List<ProductModel> products,
      String tokenTerget) async {
    try {
      List<Map> carOptionJson = new List();
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String seriecupon = _preferences.getString('cupon');
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
        'Content-type': 'application/json'
      };
      for (var items in products) {
        double montototal = double.parse(items.price) * items.quantity;
        ProductPayment carJson = new ProductPayment(
            cantidadPoducto: items.quantity.toString(),
            precioProducto: items.price,
            montoTotal: montototal.toStringAsFixed(2).toString(),
            codigoProducto: items.idprod.toString(),
            color: items.idCol,
            talla: items.idSize.toString(),
            image: items.imageList);
        carOptionJson.add(carJson.TojsonData());
      }
      var body = json.encode(
        {
          "token": tokenTerget,
          "email": user.emailTarget,
          "Cdi_Codigo": user.idAdrres,
          "Com_SubTotal": payment.costoProd,
          "Com_Total": payment.total,
          "Com_Delivery": payment.costoEnv,
          "Com_CuponMonto": payment.descuento,
          "Com_Comentarios": user.descriptionNote,
          "Cup_Serie": seriecupon,
          "Ciu_Codigo": business.idcity,
          "Pais_Codigo": user.idPais,
          "Emp_Codigo": business.uid,
          "Pta_Codigo": targetTypeOption,
          "ETar_Codigo": codmediPago,
          "Com_FormaPago": formapago,
          "Cli_Codigo": user.idCliente,
          "Con_Estado": estadoCom,
          "Com_Fecha_Atencion": delivery.fecha,
          "Com_Hora_Atencion": delivery.hora,
          "Detalle": carOptionJson
        },
      );
      var response = await http.post(ShopContants.SAVESHOPPRODUCT,
          body: body, headers: headers);

      if (response.statusCode == 200) {
        return RESULTTARGET(status: 200);
      } else if (response.statusCode == 400) {
        return fetchResponseCodeVISA(response.body);
      } else {
        return RESULTTARGET(status: 401);
      }
    } catch (e) {
      print(e);
      return RESULTTARGET(status: 002);
    }
  }

  static RESULTTARGET fetchResponseCodeVISA(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    RESULTTARGET enviosms = RESULTTARGET.formJson(map);
    return enviosms;
  }

  Future<MedioPago> queryMethodPayment(
      String codTarget, Business business) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
      };
      var map = Map<String, dynamic>();
      map['Pta_Codigo'] = codTarget;
      map['Emp_Codigo'] = business.uid.toString();
      var response = await http.post(ShopContants.QUERYMETHODPAYMENT,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        return fetchResponseCodeMetodPayment(response.body);
      } else if (response.statusCode == 401 || response.statusCode == 404) {
        return MedioPago(cod: 404);
      } else if (response.statusCode == 500) {
        return MedioPago(cod: 500);
      } else {
        return MedioPago(cod: 500);
      }
    } catch (e) {
      print(e);
      return MedioPago(cod: 500);
    }
  }

  static MedioPago fetchResponseCodeMetodPayment(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    MedioPago enviosms = MedioPago.formJson(map);
    return enviosms;
  }

  Future<OrdersPaymentProduct> getOrderPaymentClient(String idClient) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
      };
      var response = await http.get(ShopContants.GETORDERSCLIENT + idClient,
          headers: headers);
      if (response.statusCode == 200) {
        return fetchResponseOrderClient(response.body);
      } else if (response.statusCode == 401) {
        return OrdersPaymentProduct(code: 401);
      } else if (response.statusCode == 500) {
        return OrdersPaymentProduct(code: 500);
      } else {
        return OrdersPaymentProduct(code: 500);
      }
    } catch (e) {
      print(e);
      return OrdersPaymentProduct(code: 500);
    }
  }

  static OrdersPaymentProduct fetchResponseOrderClient(String responseBody) {
    if (responseBody == "[]") {
      Map<String, dynamic> map;
      OrdersPaymentProduct enviosms = OrdersPaymentProduct.fromJson(map);
      return enviosms;
    } else {
      final map = jsonDecode(responseBody) as Map<String, dynamic>;
      OrdersPaymentProduct enviosms = OrdersPaymentProduct.fromJson(map);
      return enviosms;
    }
  }

  List<OrderDetailProduct> parseOrderDetailPaymentClient(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<OrderDetailProduct>((json) => OrderDetailProduct.formJson(json))
        .toList();
  }

  Future<List<OrderDetailProduct>> fetchOrderPaymentDetailClient(
      String idOrderPayment) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String token = _preferences.getString('Token');
    Map<String, String> headers = {"Authorization": "bearer" + token};
    final response = await http.get(
        ShopContants.GETDETAILORDERPAYMENTCLIENT + idOrderPayment + '/detalle',
        headers: headers);

    return parseOrderDetailPaymentClient(response.body);
  }

  Future<int> updateStatusOrderClient(String idOrder) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
      };
      var map = Map<String, dynamic>();
      map['Com_Codigo'] = idOrder;
      map['Con_Estado'] = '6';
      var response = await http.post(ShopContants.POSTSTATEORDERCLIENT,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        return -200;
      } else if (response.statusCode == 404) {
        return -404;
      } else if (response.statusCode == 500) {
        return -500;
      } else {
        return -19980;
      }
    } catch (e) {
      print(e);
      return -19980;
    }
  }

  Future<HourDeliveryModel> queryHourDelivery(ParamsDelivery params) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {"Authorization": "bearer" + token};
      var map = Map<String, dynamic>();
      map['Fecha'] = params.date;
      map['Hora'] = params.hour;
      map['Tipo'] = params.type;
      map['Emp_Codigo'] = params.idBusiness;
      var response = await http.post(ShopContants.QUERYHOURDELIVERY,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        return parseHourDelivery(response.body);
      } else if (response.statusCode == 400) {
        return HourDeliveryModel(status: 400);
      } else if (response.statusCode == 401) {
        return HourDeliveryModel(status: 401);
      } else {
        return HourDeliveryModel(status: -998);
      }
    } catch (e) {
      print('error =>' + e);
      return HourDeliveryModel(status: -0021);
    }
  }

  HourDeliveryModel parseHourDelivery(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    HourDeliveryModel enviosms = HourDeliveryModel.formJson(map);
    return enviosms;
  }

  Future<int> queryOptionValuePayment(
      String idPayment, String idBusiness) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {"Authorization": "bearer" + token};
      var map = Map<String, dynamic>();
      map['Pta_Codigo'] = idPayment;
      map['Emp_Codigo'] = idBusiness;
      var response = await http.post(ShopContants.QUERMETHODVALUEOPTIONPAYMENT,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        return 200;
      } else if (response.statusCode == 404) {
        return 404;
      } else if (response.statusCode == 401) {
        return 401;
      } else {
        return 500;
      }
    } catch (e) {
      print('error =>' + e);
      return 500;
    }
  }

  Future<int> sendTokenTarget(int amount, String tokenTarget) async {
    try {
      var map = Map<String, dynamic>();
      map['token'] = tokenTarget;
      map['amount'] = amount.toString();
      var response = await http.post(ShopContants.SENDTOKENTARGET, body: map);
      if (response.statusCode == 200) {
        return -200;
      } else if (response.statusCode == 404) {
        return -404;
      } else if (response.statusCode == 500) {
        return -500;
      } else {
        return -19980;
      }
    } catch (e) {
      print(e);
      return -19980;
    }
  }
}
