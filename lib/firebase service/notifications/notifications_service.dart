import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHandler {
  static final NotificationHandler _singleton = NotificationHandler._internal();
  factory NotificationHandler() => _singleton;

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Private constructor and initialization of notifications
  NotificationHandler._internal() {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    // Initialize Android and iOS notification settings
    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    // Initialize the plugin with the settings
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // Configure Firebase Messaging to handle incoming messages
  Future<void> configureFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message.data, message.notification);
    });
  }

  // Display the local notification using the data received from FCM
  void _showNotification(Map<String, dynamic> data, RemoteNotification? notification) {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your_channel_id', // Replace with your own channel ID
      'Your Channel Name', // Replace with your own channel name
      // 'Your Channel Description', // Replace with your own channel description
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    // Show the notification with title, body, and payload
    _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      notification?.title ?? data['title'], // Notification title
      notification?.body ?? data['body'], // Notification body
      platformChannelSpecifics,
      payload: 'customData',
    );
  }
}
