import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService() {
    initNotifications();
  }
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();

  String? FCMToken;
  
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    FCMToken = await _firebaseMessaging.getToken();
    print("Token: $FCMToken");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    await _fln.initialize(InitializationSettings(android:  AndroidInitializationSettings('@mipmap/ic_launcher')));
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Handling background message: $message |id: ${message.messageId}");
}