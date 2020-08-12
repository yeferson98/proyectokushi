import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:kushi/shops/model/category.model.dart';
import 'package:kushi/shops/model/hour.delivery.model.dart';
import 'package:kushi/shops/model/map.order.rest.dart';
import 'package:kushi/shops/model/order.detail.product.model.dart';
import 'package:kushi/shops/model/post.json.cost.env.dart';
import 'package:kushi/shops/model/product.color.model.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/model/product.size.model.dart';
import 'package:kushi/shops/model/promotions.model.dart';
import 'package:kushi/shops/model/response.model.costo.dart';
import 'package:kushi/shops/model/result.model.visa.shop.dart';
import 'package:kushi/shops/repository/shops.service.api.dart';
import 'package:kushi/shops/ui/payment/pages/model/mediopago.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/post.env.parms.delivery.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/shops/ui/payment/pages/model/request.apiKey.dart';
import 'package:kushi/user/model/response.list.address.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/model/verify.code.dart';
import 'package:kushi/user/repository/user.respository.dart';

class ShopRepository {
  final _shopRepository = ShopApi();
  final _userRepository = UserRepository();
  Future<List<ProductModel>> fetchProductRepository(
          String idBusiness, String idUser) =>
      _shopRepository.fetchProduct(idBusiness, idUser);
  Future<List<CategoryModel>> fetchCategoryRepository(String idBusiness) =>
      _shopRepository.fetchCategory(idBusiness);
  Future<List<PromotionsModel>> fetchPromotionsRepository(String id) =>
      _shopRepository.fetchPromotions(id);
  Future<List<ProductColorModel>> fetchProductColorsRepository(String id) =>
      _shopRepository.fetchProductColors(id);
  Future<List<ProductSizeModel>> fetchProductSizeRepository(
          String id, String idcolor) =>
      _shopRepository.fetchProductSize(id, idcolor);
  Future<List<ProductModel>> fetchWishListProductRepository(String idUser) =>
      _shopRepository.fetchWishListProduct(idUser);
  Future<bool> saveProduductFavoriteRepository(
          String idProduct, String idUser, String idBusiness) =>
      _shopRepository.saveProduductFavorite(idProduct, idUser, idBusiness);
  Future<bool> removeProduductFavoriteRepository(
          String idProduct, String idUser) =>
      _shopRepository.removeProduductFavorite(idProduct, idUser);
  Future<double> queryCostoEnvioRepositoy(
          String idBusiness, String idAdrees, List<ProductCod> products) =>
      _shopRepository.queryCostoEnvio(idBusiness, idAdrees, products);
  Future<RESPONSECOSTOMODEL> queryDescCuponRepository(
          String cupon, String idBusiness) =>
      _shopRepository.queryDescCupon(cupon, idBusiness);
  Future<List<GetProductEnStock>> getStockExistRepository(
          List<ProductModel> products) =>
      _shopRepository.getStockExist(products);
  Future<int> verifyShopPaymet(String idClient, String idBusiness) =>
      _shopRepository.verifyShopPaymet(idClient, idBusiness);

  //proceso de compra con los metodos yape, plin, efectivo, pos
  Future<VERIFICODE> saveShopProductRepository(
    String codmediPago,
    String formapago,
    String estadoCom,
    String targetTypeOption,
    Business business,
    TimedateEnd delivery,
    UserModel user,
    PaymetProductDetail payment,
    List<ProductModel> products,
  ) =>
      _shopRepository.saveShopProduct(
        codmediPago,
        formapago,
        estadoCom,
        targetTypeOption,
        business,
        delivery,
        user,
        payment,
        products,
      );
  //obtener apikey para generar un token
  Future<TokenApiKey> getApikeyTargetRepository() =>
      _shopRepository.getApikeyTarget();
  //procesar compra con visA
  Future<RESULTTARGET> saveShopProductTargetRepository(
          String codmediPago,
          String formapago,
          String estadoCom,
          String targetTypeOption,
          Business business,
          TimedateEnd delivery,
          UserModel user,
          PaymetProductDetail payment,
          List<ProductModel> products,
          String token) =>
      _shopRepository.saveShopProductVISA(codmediPago, formapago, estadoCom,
          targetTypeOption, business, delivery, user, payment, products, token);
//fin de proceso con visa

  Future<MedioPago> queryMethodPaymentRepository(
          String codTarget, Business business) =>
      _shopRepository.queryMethodPayment(codTarget, business);
  Future<ListAddressClient> getAddressClient(String idClient) =>
      _userRepository.getAddressClient(idClient);
  Future<int> removeAddressClient(String idAddress) =>
      _userRepository.removeAddressClient(idAddress);
  Future<int> addPreferenceAddressClient(String idClient, String idAddress) =>
      _userRepository.addPreferenceAddressClient(idClient, idAddress);
  Future<OrdersPaymentProduct> getOrderPaymentClientRepository(
          String idClient) =>
      _shopRepository.getOrderPaymentClient(idClient);
  Future<List<OrderDetailProduct>> fetchOrderPaymentDetailClientRepository(
          String idOrderPayment) =>
      _shopRepository.fetchOrderPaymentDetailClient(idOrderPayment);
  Future<int> updateStatusOrderClient(String idOrder) =>
      _shopRepository.updateStatusOrderClient(idOrder);
  Future<HourDeliveryModel> queryHourDeliveryRepository(
          ParamsDelivery params) =>
      _shopRepository.queryHourDelivery(params);
  Future<int> queryOptionValuePaymentRepository(
          String idPayment, String idBusiness) =>
      _shopRepository.queryOptionValuePayment(idPayment, idBusiness);
  Future<int> sendTokenTargetRepository(int amount, String tokenTarget) =>
      _shopRepository.sendTokenTarget(amount, tokenTarget);
}
