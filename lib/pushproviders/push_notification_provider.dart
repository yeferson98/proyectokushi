import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _messageStreamController = StreamController<String>.broadcast();

  Stream<String> get mensaje => _messageStreamController.stream;
  Future<String> getToken() async {
    //String getToken = "";
    _firebaseMessaging.requestNotificationPermissions();
    return _firebaseMessaging.getToken();
  }

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(onMessage: (info) async {
      print('====OnMessage====');
      String argumento = 'no-data';
      if (Platform.isAndroid) {
        argumento = info['data']['description'] ?? 'no data';
        print(info);
      }
      _messageStreamController.sink.add(argumento);
    }, onLaunch: (info) async {
      print('====OnLunch====');
    }, onResume: (info) async {
      print('====OnResume====');
      final argumento = 'Notification1998';
      _messageStreamController.sink.add(argumento);
    });
  }

  dispose() {
    _messageStreamController.close();
  }
}
