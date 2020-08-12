import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/repository/business.respository.dart';
import 'package:kushi/shops/model/map.order.rest.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/user/model/notification.model.dart';
import 'package:kushi/user/repository/user.respository.dart';
import 'package:wakelock/wakelock.dart';

class BusinessBloc implements Bloc {
  final _getBusinessRepository = BusinessRepository();
  final _getShopRepository = ShopRepository();
  final _getUserRepository = UserRepository();
  Future<List<Business>> fetchBusinesBusinesBloc(String idClient) =>
      _getBusinessRepository.fetchBusinesRepository(idClient);
  Future<bool> wakelock() => Wakelock.isEnabled;
  Future<OrdersPaymentProduct> getOrderPaymentClientBloc(String idClient) =>
      _getShopRepository.getOrderPaymentClientRepository(idClient);
  Future<List<ProductModel>> fetchProductRepository(
          String idBusiness, String idUser) =>
      _getShopRepository.fetchProductRepository(idBusiness, idUser);
  Future<bool> updatedNotiicationViewAll(
          NotificationModel item, String idClient) =>
      _getUserRepository.updatedNotiicationViewAll(item, idClient);
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
  }
}
