import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:provider/provider.dart';
import 'package:kushi/route_generator.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/user/bloc/bloc.user.dart';
import 'package:kushi/splashkushi.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/app_config.dart' as config;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Ioc.setupIocDependency();
  runApp(Kushi());
}

class Kushi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InterceptApp>(
      builder: (BuildContext context) => InterceptApp(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'splashKushi',
        onGenerateRoute: RouteGenerator.generateRoute,
        routes: {
          'splashKushi': (BuildContext context) {
            var satate = Provider.of<InterceptApp>(context);
            return BlocProvider(
              child: SplashKushi(isLoggedIn: satate.isLoggedIn()),
              bloc: UserBloc(),
            );
          }
        },
        darkTheme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Color(0xFF252525),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF2C2C2C),
          accentColor: config.Colors().mainDarkColor(1),
          hintColor: config.Colors().secondDarkColor(1),
          focusColor: config.Colors().accentDarkColor(1),
          textTheme: TextTheme(
            button: TextStyle(color: Color(0xFF252525)),
            headline1: TextStyle(
                fontSize: 20.0, color: config.Colors().secondDarkColor(1)),
            headline2: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondDarkColor(1)),
            headline3: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondDarkColor(1)),
            headline4: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: config.Colors().mainDarkColor(1)),
            headline5: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w300,
                color: config.Colors().secondDarkColor(1)),
            subtitle1: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: config.Colors().secondDarkColor(1)),
            headline6: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().mainDarkColor(1)),
            bodyText1: TextStyle(
                fontSize: 12.0, color: config.Colors().secondDarkColor(1)),
            bodyText2: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondDarkColor(1)),
            caption: TextStyle(
                fontSize: 12.0, color: config.Colors().secondDarkColor(0.7)),
          ),
        ),
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.white,
          brightness: Brightness.light,
          accentColor: config.Colors().mainColor(1),
          focusColor: config.Colors().accentColor(1),
          hintColor: config.Colors().secondColor(1),
          textTheme: TextTheme(
            button: TextStyle(color: Colors.white),
            headline1: TextStyle(
                fontSize: 20.0, color: config.Colors().secondColor(1)),
            headline2: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondColor(1)),
            headline3: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondColor(1)),
            headline4: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: config.Colors().mainColor(1)),
            headline5: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w300,
                color: config.Colors().secondColor(1)),
            subtitle1: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: config.Colors().secondColor(1)),
            headline6: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().mainColor(1)),
            bodyText1: TextStyle(
                fontSize: 12.0, color: config.Colors().secondColor(1)),
            bodyText2: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: config.Colors().secondColor(1)),
            caption: TextStyle(
                fontSize: 12.0, color: config.Colors().secondColor(0.6)),
          ),
        ),
      ),
    );
  }
}
