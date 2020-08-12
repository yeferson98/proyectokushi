import 'package:kushi/configs/config.route.dominio.kushi.dart';

class ShopContants {
  static const String GETRODUCTS = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/producto/cliente/';
  static const String GETCATEGORY =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/empresa/';
  static const String GETPROMOTIONS = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/promocion/getPromociones/';
  static const String GETPRODUCTCOLORS = DominioRouteKushi.DOMINIOROUTEKUSHI +'/api/producto/getColores/producto/';
  static const String GETPRODUCTSIZE =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/producto/getTallas/producto/';
  static const String GETWISHLISTPRODUCT =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/cliente/';
  static const String POSTADDPRODUCTFAVORITE =DominioRouteKushi.DOMINIOROUTEKUSHI +'/api/listaDeseo/saveProductoLDeseo';
  static const String DELETEPRODUCTFAVORITE = DominioRouteKushi.DOMINIOROUTEKUSHI +'/api/listaDeseo/removeProductoLDeseo';
  static const String QUERYCOSTENVI = DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/empresa/calcularCostoEnvio';
  static const String QUERYDESC =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/cupon/verify';
  static const String GETSTOCKEXIST =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/producto/validarStock';
  static const String SAVESHOPPRODUCT =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/compras/createCabecera';
  static const String QUERYMETHODPAYMENT = DominioRouteKushi.DOMINIOROUTEKUSHI +'/api/empresaTarjeta/consultarMedioPago';
  static const String GETORDERSCLIENT =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/compras/cliente/';
  static const String GETDETAILORDERPAYMENTCLIENT =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/compras/';
  static const String POSTSTATEORDERCLIENT =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/compras/changeEstado';
  static const String VERIFYSHOPPAYMENT =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/compras/checkCompras';
  static const String QUERYHOURDELIVERY =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/empresa/fechaEntrega';
  static const String QUERMETHODVALUEOPTIONPAYMENT=DominioRouteKushi.DOMINIOROUTEKUSHI +'/api/empresaTarjeta/consultarMedioPagoEfectivo';
  static const String SENDTOKENTARGET =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/culqi/checkout';
  static const String GETAPIKEYPAYMENT =DominioRouteKushi.DOMINIOROUTEKUSHI + '/api/culqi/publicKey';
}
