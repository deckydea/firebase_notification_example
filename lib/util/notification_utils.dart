import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  static const String _channelId = "Example";
  static const String channelName = "Example";
  static const String channelDescription = "Example Notification";

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static void initialize() {
    if (_initialized) return;

    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings iOSInitializationSettings = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onReceiveNotificationResponse,
    );

    _initialized = true;
  }

  static Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  static Future<void> onReceiveNotificationResponse(NotificationResponse response) async {}

  static Future<void> showNotification({required RemoteMessage remoteMessage}) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      _channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound("notification"),
      playSound: true,
    );
    DarwinNotificationDetails iOSNotificationDetails = const DarwinNotificationDetails(sound: 'notification');
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    String encodedPayload = "";
    await _flutterLocalNotificationsPlugin.show(0, remoteMessage.notification?.title, remoteMessage.notification?.body, notificationDetails, payload: encodedPayload);
  }
}
