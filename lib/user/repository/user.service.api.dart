import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:kushi/user/constants/constant.user.dart';
import 'package:kushi/user/model/address.client.model.dart';
import 'package:kushi/user/model/cities.model.dart';
import 'package:kushi/user/model/map.google.model.dart';
import 'package:kushi/user/model/model.google/user.location.dart';
import 'package:kushi/user/model/notification.model.dart';
import 'package:kushi/user/model/response.list.address.dart';
import 'package:kushi/user/model/response.model.userexist.dart';
import 'package:kushi/user/model/result.reg.user.model.dart';
import 'package:kushi/user/model/smsEnvio.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:kushi/user/model/verify.code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceAPI {
  Firestore _db = Firestore.instance;

  Future<MessageUserExist> verifyUserExist(String phone) async {
    try {
      var map = Map<String, dynamic>();
      map['Usu_Celular'] = phone;
      final response =
          await http.post(UserConstants.VERIFIUSEREXIST, body: map);

      if (response.statusCode == 200) {
        MessageUserExist result = parseResponseUserExist(response.body);
        return result;
      } else {
        MessageUserExist result = parseResponseUserExist(response.body);
        return result;
      }
    } catch (e) {
      print(e);
      return MessageUserExist(error: true, status: 500);
    }
  }

  static MessageUserExist parseResponseUserExist(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    MessageUserExist data = MessageUserExist.formJson(map);
    return data;
  }

  Future<ResultRegUser> getqueryResultUser(String phone) async {
    try {
      var map = Map<String, dynamic>();
      map['Usu_Celular'] = phone;
      final response = await http.post(UserConstants.VERIFYUSER, body: map);
      if (response.statusCode == 200) {
        ResultRegUser list = parseResponseUserAuth(response.body);
        return list;
      } else {
        ResultRegUser list = parseResponseUserAuth(response.body);
        return list;
      }
    } catch (e) {
      print(e);
      ResultRegUser list = ResultRegUser();
      return list;
    }
  }

  static ResultRegUser parseResponseUserAuth(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    ResultRegUser data = ResultRegUser.formJson(map);
    return data;
  }

  Future<SMSENVIO> message(String number) async {
    try {
      var map = Map<String, dynamic>();
      map['Usu_Celular'] = number;
      var response = await http.post(UserConstants.MESSAGEPOST, body: map);
      print(response.body);
      if (200 == response.statusCode) {
        SMSENVIO list = parseResponse(response.body);
        return list;
      } else if (500 == response.statusCode) {
        SMSENVIO list = parseResponse(response.body);
        return list;
      } else {
        SMSENVIO end = new SMSENVIO();
        return end;
      }
    } catch (e) {
      print(e);
      SMSENVIO end = new SMSENVIO();
      return end;
    }
  }

  static SMSENVIO parseResponse(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    SMSENVIO enviosms = SMSENVIO.formJson(map);
    return enviosms;
  }

  Future<int> updatedTokenNotification(
      String idClient, String tokenNotifiation, tokenUser) async {
    try {
      Map<String, String> headers = {
        "Authorization": "bearer" + tokenUser,
      };
      var map = Map<String, dynamic>();
      map['Cli_Codigo'] = idClient;
      map['Cli_TokenCel'] = tokenNotifiation;
      var response = await http.post(UserConstants.UPDATETOKENNOTIFICATION,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        return 200;
      } else if (response.statusCode == 401) {
        return 401;
      } else if (response.statusCode == 500) {
        return 500;
      } else {
        return 403;
      }
    } catch (e) {
      print(e);
      return 500;
    }
  }

  Future<UserModel> getuser(ResultRegUser data, String phone) async {
    try {
      Map<String, String> headers = {
        "Authorization": "bearer" + ' ' + data.token
      };
      var map = Map<String, dynamic>();
      map['Usu_Celular'] = phone;
      final response =
          await http.post(UserConstants.GETUSER, headers: headers, body: map);

      if (response.statusCode == 200) {
        UserModel list = parseUser(response.body);
        return list;
      } else {
        return UserModel();
      }
    } catch (e) {
      print(e);
      return UserModel();
    }
  }

  static UserModel parseUser(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    UserModel enviosms = UserModel.formJson(map);
    return enviosms;
  }

  Future<VERIFICODE> verifycode(String numero, String code) async {
    try {
      var map = Map<String, dynamic>();
      map['Usu_CodValid'] = code;
      map['Usu_Celular'] = numero;
      var response = await http.post(UserConstants.VERFICODEPOST, body: map);
      if (200 == response.statusCode) {
        VERIFICODE list = parseResponseCode(response.body);
        return list;
      } else if (400 == response.statusCode) {
        VERIFICODE list = parseResponseCode(response.body);
        return list;
      }
      VERIFICODE end = new VERIFICODE();
      return end;
    } catch (e) {
      print(e);
      VERIFICODE end = new VERIFICODE();
      return end;
    }
  }

  static VERIFICODE parseResponseCode(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    VERIFICODE enviosms = VERIFICODE.formJson(map);
    return enviosms;
  }

  Future<List<Cities>> getCities() async {
    try {
      final response = await http.get(UserConstants.CITIESGET);

      if (response.statusCode == 200) {
        List<Cities> list = parseCities(response.body);
        return list;
      } else {
        return List<Cities>();
      }
    } catch (e) {
      print(e);
      return List<Cities>();
    }
  }

  static List<Cities> parseCities(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Cities>((json) => Cities.formJson(json)).toList();
  }

  Future<AdrresGoogle> getAddress(
      String address, UserLocation locationuser, bool typeQuery) async {
    try {
      String key = "AIzaSyA3qGGc7JNlxZ9NvH4sQGd7mhFI-4Ue05k";
      if (typeQuery == true) {
        final response = await http.get(
            "https://maps.googleapis.com/maps/api/geocode/json?address=${address.toString()}&key=${key.toString()}&components=country:PE&location_type=ROOFTOP");

        if (response.statusCode == 200) {
          AdrresGoogle list = parseGoogle(response.body);
          return list;
        } else {
          return AdrresGoogle(status: "errorQuery");
        }
      } else {
        final response = await http.get(
            "https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationuser.latitud},${locationuser.longitud}&key=${key.toString()}");
        if (response.statusCode == 200) {
          AdrresGoogle list = parseGoogle(response.body);
          return list;
        } else {
          return AdrresGoogle(status: "errorQuery");
        }
      }
    } catch (e) {
      print(e);
      return AdrresGoogle(status: "errorQuery");
    }
  }

  static AdrresGoogle parseGoogle(String responseBody) {
    final parsed = json.decode(responseBody) as Map<String, dynamic>;
    AdrresGoogle adressGogle = AdrresGoogle.fromJson(parsed);
    return adressGogle;
  }

  Future<int> saveAdrresClient(AddressClient addressClient) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
      };
      var map = Map<String, dynamic>();
      map['Cli_Codigo'] = addressClient.idClient.toString();
      map['Cdi_Titulo'] = addressClient.nameAdrres;
      map['Cdi_Direccion'] = addressClient.address;
      map['Cdi_DireAdicional'] = addressClient.addressAdd;
      map['Cdi_Referencial'] = addressClient.reference;
      map['Cdi_X'] = addressClient.longitud.toString();
      map['Cdi_Y'] = addressClient.latitud.toString();
      map['Prov_desc'] = addressClient.descriptionProv;
      map['Dist_desc'] = addressClient.descriptionDis;
      map['Depa_desc'] = addressClient.descriptionDepa;
      var response = await http.post(UserConstants.SAVEADDRESSCLIENT,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        return 200;
      } else if (response.statusCode == 401) {
        return 401;
      } else if (response.statusCode == 500) {
        return 500;
      } else {
        return 403;
      }
    } catch (e) {
      print(e);
      return 500;
    }
  }

  Future<ListAddressClient> getAddressClient(String idClient) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
      };
      var response = await http.get(
          UserConstants.GETADDRESSCLIENT +
              '${idClient.toString()}' +
              '/direcciones',
          headers: headers);
      if (response.statusCode == 200) {
        return fetchResponseAddressLocation(response.body);
      } else if (response.statusCode == 401) {
        return fetchResponseAddressLocation(response.body);
      } else if (response.statusCode == 500) {
        return fetchResponseAddressLocation(response.body);
      } else {
        return fetchResponseAddressLocation(response.body);
      }
    } catch (e) {
      print(e);
      return ListAddressClient(status: 500, error: false);
    }
  }

  static ListAddressClient fetchResponseAddressLocation(String responseBody) {
    final map = jsonDecode(responseBody) as Map<String, dynamic>;
    ListAddressClient data = ListAddressClient.fromJson(map);
    return data;
  }

  Future<int> removeAddressClient(String idAddress) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
      };
      var map = Map<String, dynamic>();
      map['Cdi_Codigo'] = idAddress;
      var response = await http.post(UserConstants.REMOVEADDRESSCLIENT,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        return 200;
      } else if (response.statusCode == 401) {
        return 401;
      } else if (response.statusCode == 500) {
        return 500;
      } else {
        return 403;
      }
    } catch (e) {
      print(e);
      return 500;
    }
  }

  Future<int> addPreferenceAddressClient(
      String idClient, String idAddress) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
      };
      var map = Map<String, dynamic>();
      map['Cdi_Codigo'] = idAddress;
      map['Cli_Codigo'] = idClient;
      var response = await http.post(UserConstants.ADDPREFERENCEADDRESSCLIENT,
          body: map, headers: headers);
      if (response.statusCode == 200) {
        return 200;
      } else if (response.statusCode == 401) {
        return 401;
      } else if (response.statusCode == 500) {
        return 500;
      } else if (response.statusCode == 400) {
        return 400;
      } else {
        return 403;
      }
    } catch (e) {
      print(e);
      return 500;
    }
  }

  Future<List<NotificationModel>> getNotificationUser(String idClient) async {
    try {
      SharedPreferences _preferences = await SharedPreferences.getInstance();
      String token = _preferences.getString('Token');
      Map<String, String> headers = {
        "Authorization": "bearer" + token,
      };
      var response = await http.get(
        UserConstants.GETNOTIFICATIONUSER +
            '${idClient.toString()}' +
            '/notificaciones',
        headers: headers,
      );
      if (response.statusCode == 200) {
        return parseNotificationUser(response.body);
      } else if (response.statusCode == 401) {
        return [];
      } else if (response.statusCode == 500) {
        return [];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  List<NotificationModel> parseNotificationUser(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<NotificationModel>((json) => NotificationModel.formJson(json))
        .toList();
  }

  /*query cloudFirestore get notification */
  Stream<List<NotificationModel>> listNotificationUser(String idClient) => _db
      .collection(UserConstants.NOTIFICATION_USER_GET +
          idClient +
          UserConstants.RUTE_CONTINUE_NOTIFICATION_USER)
      .orderBy('dato', descending: true)
      .snapshots()
      .map((QuerySnapshot q) => q.documents
          .map((DocumentSnapshot d) => NotificationModel.fomSnapshot(d))
          .toList());
  Stream<List<NotificationModel>> listNotificationViewAllUser(
          String idClient) =>
      _db
          .collection(UserConstants.NOTIFICATION_USER_GET +
              idClient +
              UserConstants.RUTE_CONTINUE_NOTIFICATION_USER)
          .where('leido', isEqualTo: 0)
          .snapshots()
          .map((QuerySnapshot q) => q.documents
              .map((DocumentSnapshot d) => NotificationModel.fomSnapshot(d))
              .toList());
  Future<bool> deleteNotification(
      NotificationModel item, String idClient) async {
    try {
      await _db
          .collection(UserConstants.NOTIFICATION_USER_GET +
              idClient +
              UserConstants.RUTE_CONTINUE_NOTIFICATION_USER)
          .document(item.keyDocument)
          .delete();
      return true;
    } catch (e) {
      return await Future.value(false);
    }
  }

  Future<bool> updatedNotificationViewAll(
      NotificationModel item, String idClient) async {
    try {
      final DocumentSnapshot document = await _db
          .collection(UserConstants.NOTIFICATION_USER_GET +
              idClient +
              UserConstants.RUTE_CONTINUE_NOTIFICATION_USER)
          .document(item.keyDocument)
          .snapshots()
          .first;

      Map<String, dynamic> dataToUpdate = item.toJson();
      dataToUpdate.remove('key');
      document.reference.updateData(dataToUpdate);

      return true;
    } catch (e) {
      return await Future.value(false);
    }
  }
}
