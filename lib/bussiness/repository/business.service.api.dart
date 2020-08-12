import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kushi/bussiness/constants/busines.contants.dart';
import 'package:kushi/bussiness/model/business.model.dart';

class BusinessAPI {
  List<Business> parseBusiness(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Business>((json) => Business.formJson(json)).toList();
  }

  Future<List<Business>> fetchBusines(String idClient) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String token = _preferences.getString('Token');
    //String phone = _preferences.getString('phone');
    Map<String, String> headers = {"Authorization": "bearer" + token};
    final response =
        await http.get(BusinessConstants.GETBUSINESS+idClient, headers: headers);

    return parseBusiness(response.body);
  }

  List<TimeAttentionBusiness> parseTimeBusiness(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TimeAttentionBusiness>((json) => TimeAttentionBusiness.formJson(json)).toList();
  }

  Future<List<TimeAttentionBusiness>> fetchTimeBusines(String idBusiness) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String token = _preferences.getString('Token');
    Map<String, String> headers = {"Authorization": "bearer" + token};
    final response =  await http.get(BusinessConstants.GETTIMEATTENTION+idBusiness+"/horarioAtencion", headers: headers);

    return parseTimeBusiness(response.body);
  }
}
