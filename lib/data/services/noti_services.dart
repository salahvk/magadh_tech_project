import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:magadh_tech/presentation/screens/home_page.dart';
import 'package:magadh_tech/utils/app.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');
    // await _firebaseMessaging.requestPermission();
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final payload = notificationResponse.payload;
        handleNotificationClick(payload);
      },
    );
    // FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );
  }

  void handleNotificationClick(String? payload) {
    if (payload != null) {
      final data = parsePayload(payload);

      if (data != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    }
  }

  Map<String, dynamic>? parsePayload(String payload) {
    try {
      return jsonDecode(payload);
    } catch (e) {
      print('Error parsing notification payload: $e');
      return null;
    }
  }

  Future<void> handleBackgroundNotification(RemoteMessage message) async {
    final notificationData = message.data;
    print(notificationData);
  }
}
