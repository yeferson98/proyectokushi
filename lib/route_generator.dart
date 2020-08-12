import 'package:flutter/material.dart';
import 'package:kushi/routes/routes.arguments.dart';
import 'package:kushi/shops/ui/screens/product.dart';
import 'package:kushi/user/ui/screens/Login/login_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;
    final args = settings.arguments;
    switch (settings.name) {
      case '/numberPhone':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/Product':
        return MaterialPageRoute(builder: (_) => ProductWidget(routeArgument: args as RouteArgumentProd));
      /*case '/Dashboard':
        return MaterialPageRoute(builder: (_) => DashboardUser());*/
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
