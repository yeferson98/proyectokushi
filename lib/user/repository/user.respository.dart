import 'package:kushi/user/model/address.client.model.dart';
import 'package:kushi/user/model/cities.model.dart';
import 'package:kushi/user/model/model.google/user.location.dart';
import 'package:kushi/user/model/notification.model.dart';
import 'package:kushi/user/model/response.list.address.dart';
import 'package:kushi/user/model/response.model.userexist.dart';
import 'package:kushi/user/model/result.reg.user.model.dart';
import 'package:kushi/user/model/smsEnvio.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/model/verify.code.dart';
import 'package:kushi/user/repository/location.user.dart';
import 'package:kushi/user/repository/user.service.api.dart';
import 'package:kushi/user/model/map.google.model.dart';

class UserRepository {
  final _serviceAPI = ServiceAPI();
  final _serviceLocation = LocationService();
  Future<MessageUserExist> verifyUserExist(String phone) =>
      _serviceAPI.verifyUserExist(phone);
  Future<ResultRegUser> getqueryResultUserRepository(String phone) =>
      _serviceAPI.getqueryResultUser(phone);
  Future<SMSENVIO> getMenssagePhone(String number) =>
      _serviceAPI.message(number);
  Future<int> updatedTokenNotificationRepository(
          String idClient, String token, tokenUser) =>
      _serviceAPI.updatedTokenNotification(idClient, token, tokenUser);
  Future<UserModel> getuserRepository(ResultRegUser data, String phone) =>
      _serviceAPI.getuser(data, phone);
  Future<VERIFICODE> verifycodeRepository(String numero, String code) =>
      _serviceAPI.verifycode(numero, code);
  Future<List<Cities>> getCitiesRepository() => _serviceAPI.getCities();
  Future<AdrresGoogle> getAddress(
          String address, UserLocation locationuser, bool typeQuery) =>
      _serviceAPI.getAddress(address, locationuser, typeQuery);
  Future<UserLocation> getLocationUser() => _serviceLocation.getLocationUser();
  Future<int> saveAdrresClient(AddressClient addressClient) =>
      _serviceAPI.saveAdrresClient(addressClient);
  Future<ListAddressClient> getAddressClient(String idClient) =>
      _serviceAPI.getAddressClient(idClient);
  Future<int> removeAddressClient(String idAddress) =>
      _serviceAPI.removeAddressClient(idAddress);
  Future<int> addPreferenceAddressClient(String idClient, String idAddress) =>
      _serviceAPI.addPreferenceAddressClient(idClient, idAddress);
  /*Future<List<NotificationModel>> getNotificationUserRepository(
          String idClient) =>
      _serviceAPI.getNotificationUser(idClient);*/

  /* query of firebase database CloudFirestore */
  Stream<List<NotificationModel>> listNotificationUser(String idClient) =>
      _serviceAPI.listNotificationUser(idClient);
  Future<bool> deleteNotification(NotificationModel item, String idClient) =>
      _serviceAPI.deleteNotification(item, idClient);
  Future<bool> updatedNotiicationViewAll(
          NotificationModel item, String idClient) =>
      _serviceAPI.updatedNotificationViewAll(item, idClient);
  Stream<List<NotificationModel>> listNotificationViewAllUserRepository(
          String idClient) =>
      _serviceAPI.listNotificationViewAllUser(idClient);
}
