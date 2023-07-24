import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _firebaseMessaging = FirebaseMessaging.instance;
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
    // Check if payload is not null and handle the navigation accordingly
    if (payload != null) {
      print(payload);
      // For example, parse the payload JSON or handle data based on payload contents
      final data = parsePayload(payload);

      if (data != null) {
        print(data);
        // Navigate to the appropriate screen based on the data from the payload
        // For example:
        // navigatorKey.currentState?.push(
        //   MaterialPageRoute(
        //     builder: (context) => TargetScreen(data: data),
        //   ),
        // );
      }
    }
  }

  // Helper method to parse the JSON payload if needed
  Map<String, dynamic>? parsePayload(String payload) {
    try {
      return jsonDecode(payload);
    } catch (e) {
      print('Error parsing notification payload: $e');
      return null;
    }
  }

  Future<void> handleBackgroundNotification(RemoteMessage message) async {
    // Extract information from the notification payload
    final notificationData = message.data;
    print(notificationData);

    // Handle the background notification here based on the payload data
    // For example, you might want to navigate to a specific screen
    // or update data in your app.
  }
}
