import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:kushi/pushproviders/push_notification_provider.dart';
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
import 'package:kushi/user/repository/user.respository.dart';
import 'package:kushi/user/model/map.google.model.dart';
import 'package:wakelock/wakelock.dart';

class UserBloc implements Bloc {
  final _getUserRepository = UserRepository();
  final pushNotification = new PushNotificationProvider();
  //consulta codigo por el celular
  Future<MessageUserExist> verifyUserExistBloc(String phone) =>
      _getUserRepository.verifyUserExist(phone);
  Future<ResultRegUser> getqueryResultUserBloc(String phone) =>
      _getUserRepository.getqueryResultUserRepository(phone);
  Future<SMSENVIO> getMenssage(String number) =>
      _getUserRepository.getMenssagePhone(number);
  Future<int> updatedTokenNotificationBloc(
          String idClient, String token, tokenUser) =>
      _getUserRepository.updatedTokenNotificationRepository(
          idClient, token, tokenUser);
  Future<UserModel> getuserUserBloc(ResultRegUser data, String phone) =>
      _getUserRepository.getuserRepository(data, phone);
  Future<VERIFICODE> verifycodeUserBloc(String numero, String code) =>
      _getUserRepository.verifycodeRepository(numero, code);
  Future<List<Cities>> getCitiesUserBloc() =>
      _getUserRepository.getCitiesRepository();
  Future<AdrresGoogle> getAddress(
          String address, UserLocation locationuser, bool typeQuery) =>
      _getUserRepository.getAddress(address, locationuser, typeQuery);
  Future<UserLocation> getLocationUser() =>
      _getUserRepository.getLocationUser();
  Future<bool> wakelock() => Wakelock.isEnabled;
  Future<int> saveAdrresClientBloc(AddressClient addressClient) =>
      _getUserRepository.saveAdrresClient(addressClient);
  Future<int> removeAddressClientBloc(String idAddress) =>
      _getUserRepository.removeAddressClient(idAddress);
  Future<int> addPreferenceAddressClient(String idClient, String idAddress) =>
      _getUserRepository.addPreferenceAddressClient(idClient, idAddress);
  Future<ListAddressClient> getAddressClient(String idClient) =>
      _getUserRepository.getAddressClient(idClient);
  Future<String> getTokenNotification() => pushNotification.getToken();
  /*Future<List<NotificationModel>> getNotificationUserRepository(
          String idClient) =>
      _getUserRepository.getNotificationUserRepository(idClient);*/
  Future<bool> deleteNotificationUserBloc(
          NotificationModel item, String idClient) =>
      _getUserRepository.deleteNotification(item, idClient);
  Future<bool> updatedNotiicationViewAll(
          NotificationModel item, String idClient) =>
      _getUserRepository.updatedNotiicationViewAll(item, idClient);

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
  }
}
