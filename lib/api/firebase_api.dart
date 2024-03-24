import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Payload: ${message.data}');
  }

  initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final getToken = await _firebaseMessaging.getToken();
    print('===================================================');
    //print(getToken);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    print('====================================================');
  }
}
