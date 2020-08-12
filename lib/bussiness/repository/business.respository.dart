import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:kushi/bussiness/repository/business.service.api.dart';

class BusinessRepository {
  final _businessAPI = BusinessAPI();
  //final _userAPI=ServiceAPI();
  Future<List<Business>> fetchBusinesRepository(String idClient) =>
      _businessAPI.fetchBusines(idClient);
  Future<List<TimeAttentionBusiness>> fetchTimeBusinesRepository(
          String idBusiness) =>
      _businessAPI.fetchTimeBusines(idBusiness);
  //Future<AdrresGoogle> getAddressRepository()=> _userAPI.getAddress();
}
