import 'package:kushi/configs/config.route.dominio.kushi.dart';

class UserConstants {
  static const String MESSAGEPOST = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/send';
  static const String VERFICODEPOST =  DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/verify';
  static const String UPDATETOKENNOTIFICATION = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/cliente/setFirebaseToken';
  static const String CITIESGET = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/ciudad/getCiudades';
  static const String SAVEUSER = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/user/updateUserInfo';
  static const String VERIFIUSEREXIST = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/user/checkPhone';
  static const String GETUSER =  DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/user/getUser';
  static const String VERIFYUSER = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/user/getUserToken';
  static const String GETADDRESSGOOGLE ='https://maps.googleapis.com/maps/api/geocode/json';
  static const String SAVEADDRESSCLIENT =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/cliente/saveDireccion';
  static const String GETADDRESSCLIENT = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/cliente/';
  static const String REMOVEADDRESSCLIENT = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/cliente/removeDireccion';
  static const String ADDPREFERENCEADDRESSCLIENT = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/cliente/setPredeterminada';
  static const String GETNOTIFICATIONUSER = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/cliente/';
  static const String NOTIFICATION_USER_GET = "notificaciones-usuario/cliente-";
  static const String RUTE_CONTINUE_NOTIFICATION_USER = "/notificaciones";
}
