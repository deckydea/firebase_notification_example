import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notification_example/util/notification_utils.dart';
import 'package:flutter/foundation.dart';

class FirebaseUtils {
  static const String _logName = "FIREBASE";
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) handleMessageData(message: initialMessage);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) => handleMessageData(message: message));

      FirebaseMessaging.onMessage.listen((RemoteMessage message) => handleMessageData(message: message));

      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

      _initialized = true;

    await _loadToken();

  }

  static Future<void> handleMessageData({required RemoteMessage message}) async {
    //TODO: Handle this message
    log("Title: ${message.notification?.title}",  name: _logName);
    log("Body: ${message.notification?.body}",  name: _logName);
    log("Payload: ${message.data}",  name: _logName);
    log("Payload: ${message.notification.toString()}",  name: _logName);

    NotificationUtils.showNotification(remoteMessage: message);

  }

  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    //TODO: Handle background message
    if (kDebugMode) log("Handling a background message: ${message.messageId}", name: _logName);
    //For now, just print the message
    handleMessageData(message: message);
  }

  //Load FCM Token
  static Future<void> _loadToken() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    _firebaseMessaging.getToken().then((token) => _setFirebaseToken(token));
  }

  static Future<void> _setFirebaseToken(String? token) async {
    if (token == null || token == '') return;

    log("Token: $token", name: _logName);
  }
}
