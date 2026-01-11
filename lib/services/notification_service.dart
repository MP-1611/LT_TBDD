import 'package:firebase_messaging/firebase_messaging.dart';
import '../routes/app_routes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'navigation_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📩 Background message: ${message.notification?.title}");
}

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final _local = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
  AndroidNotificationChannel(
    'default_channel',
    'General Notifications',
    description: 'General notifications',
    importance: Importance.high,
  );

  static Future<void> init() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _local.initialize(initSettings);

    await _local
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    FirebaseMessaging.onMessage.listen(_handleForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpen);
    final initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleOpen(initialMessage);
    }

    final token = await _messaging.getToken();
    print("🔥 FCM TOKEN: $token");
  }

  static void _handleForeground(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _local.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  static void _handleOpen(RemoteMessage message) {
    final data = message.data;

    if (data['screen'] == 'mission') {
      NavigationService.navigatorKey.currentState
          ?.pushNamed(AppRoutes.missions);
    }
  }
}
