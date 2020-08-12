
import 'package:get_it/get_it.dart';
import 'package:kushi/bussiness/repository/business.respository.dart';
import 'package:kushi/shops/repository/shops.repository.dart';
import 'package:kushi/user/repository/user.respository.dart';

final GetIt ioc= new GetIt();
class Ioc {
   static setupIocDependency(){
     ioc.registerSingleton<ShopRepository>(new ShopRepository());
     ioc.registerSingleton<UserRepository>(new UserRepository());
     ioc.registerSingleton<BusinessRepository>(new BusinessRepository());
   }
  static T get<T>(){
    return ioc<T>();
  }
}