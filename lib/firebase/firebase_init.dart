import 'package:algo_trade/utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'trade_fill_channel', // id
    'trade fill notifications', // title
    description: "This channel is used for Trade Fill.", // description
    importance: Importance.high,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future initLocalNotifcations() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(settings);
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // do stuff like navigating to a route
      }
    });

    // this is for when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      // do stuff like navigating to a route
    });
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    });
  }

  Future<void> initNotifcations() async {
    await _firebaseMessaging.requestPermission();
    final isWeb = GetPlatform.isWeb;
    final fcmToken = isWeb
        ? await _firebaseMessaging.getToken(
            vapidKey:
                "BFDwwUlcHQbCQqSYFPn_MxvmffDyg8Wv0OoD91oRXm4rx5jk8wp2uM6o39QfdYc3G4CCd5g5uWJbzqgUOMvkAb4")
        : await _firebaseMessaging.getToken();

    firebaseToken = fcmToken ?? '';

    print('Firebase Token: $firebaseToken');

    initPushNotifications();
    initLocalNotifcations();
  }
}
