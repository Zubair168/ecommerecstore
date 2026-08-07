import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ordersSubscription;
  static StreamSubscription<String?>? _tokenRefreshSubscription;
  static final Map<String, String> _knownStatuses = {};

  /// Initialize FCM + local notifications
  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // Request permission
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    if (!kIsWeb) {
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
    }

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((msg) {
      final notif = msg.notification;
      if (notif != null) {
        show(title: notif.title ?? 'Update', body: notif.body ?? '');
      }
    });

    // Subscribe to order topic (Not supported on Web)
    if (!kIsWeb) {
      await _fcm.subscribeToTopic('order_updates');
    }

    // Listen for auth changes so we can subscribe to the user's order documents
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _startOrderStatusListener(user.uid);
        _saveTokenForUser(user.uid);

        // Listen for token refresh and persist new token
        _tokenRefreshSubscription = _fcm.onTokenRefresh.listen((token) async {
          if (token != null) {
            await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
              {'fcmToken': token},
              SetOptions(merge: true),
            );
          }
        });
      } else {
        _stopOrderStatusListener();
        _tokenRefreshSubscription?.cancel();
        _tokenRefreshSubscription = null;
      }
    });
  }

  /// Show a local notification
  static Future<void> show({required String title, required String body}) async {
    if (kIsWeb) return; // Local notifications plugin not fully supported/needed same way on web for this demo

    await _localNotif.show(
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
  }

  /// Get the FCM device token
  static Future<String?> getToken() => _fcm.getToken();

  static Future<void> _saveTokenForUser(String uid) async {
    try {
      final token = await getToken();
      if (token == null) return;
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {'fcmToken': token},
        SetOptions(merge: true),
      );
    } catch (e) {
      // ignore token save errors - non-fatal
    }
  }

  /// Start listening to Firestore orders for the given user and show local
  /// notifications when an order's `status` field changes.
  static void _startOrderStatusListener(String uid) {
    _stopOrderStatusListener();
    final ref = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: uid);

    _ordersSubscription = ref.snapshots().listen((snap) {
      for (final change in snap.docChanges) {
        final id = change.doc.id;
        final data = change.doc.data();
        final status = (data?['status'] ?? '').toString();

        // Track initial status on added docs
        if (change.type == DocumentChangeType.added && status.isNotEmpty) {
          _knownStatuses[id] = status;
          continue;
        }

        // On modified, compare status
        if (change.type == DocumentChangeType.modified) {
          final prev = _knownStatuses[id];
          if (prev == null) {
            _knownStatuses[id] = status;
          } else if (prev != status) {
            _knownStatuses[id] = status;
            // Show a local notification about the status change
            show(title: 'Order Update', body: 'Order ${id.substring(0, 6)} is now $status');
          }
        }
      }
    }, onError: (e) {
      // ignore - listener may fail if permissions or connectivity change
    });
  }

  static void _stopOrderStatusListener() {
    _ordersSubscription?.cancel();
    _ordersSubscription = null;
    _knownStatuses.clear();
  }
}

