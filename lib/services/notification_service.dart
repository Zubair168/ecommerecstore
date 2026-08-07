import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level handler for background Firebase messages (must be top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.initialize();
  await NotificationService.show(
    title: message.notification?.title ?? 'Order Update',
    body: message.notification?.body ?? '',
  );
}

class NotificationService {
  static final _fcm = FirebaseMessaging.instance;
  static final _localNotif = FlutterLocalNotificationsPlugin();
  static const _channelId = 'order_updates';
  static const _channelName = 'Order Updates';

  static bool _initialized = false;

  /// Initialize FCM + local notifications
  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // Request permission
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Android notification channel
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: 'Notifications for order status updates',
      importance: Importance.high,
    );

    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Local notifications init
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _localNotif.initialize(initSettings);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((msg) {
      final notif = msg.notification;
      if (notif != null) {
        show(title: notif.title ?? 'Update', body: notif.body ?? '');
      }
    });

    // Subscribe to order topic
    await _fcm.subscribeToTopic('order_updates');
  }

  /// Show a local notification
  static Future<void> show({required String title, required String body}) =>
      _localNotif.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: 'Order status notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );

  /// Get the FCM device token
  static Future<String?> getToken() => _fcm.getToken();
}
