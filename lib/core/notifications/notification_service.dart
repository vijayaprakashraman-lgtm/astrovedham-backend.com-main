import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';

import 'notification_navigation.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  GlobalKey<NavigatorState>? navigatorKey;

  Future<void> init(GlobalKey<NavigatorState> navKey) async {
    navigatorKey = navKey;
    NotificationNavigation.navigatorKey = navKey;

    if (kIsWeb) {
      if (kDebugMode) {
        print('[NOTIFICATIONS] Web platform detected; native local notifications skipped.');
      }
      return;
    }

    // 2. Initialize Local Notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationPayload(response.payload);
      },
    );

    // Create Android Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'astrovedham_channel',
      'AstroVedham Notifications',
      description: 'Notifications for horoscope reports and downloads',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 3. Register FCM Token if authenticated
    await registerFcmToken();

    // 4. Token refresh listener
    _fcm.onTokenRefresh.listen((newToken) {
      _sendTokenToBackend(newToken);
    });

    // 5. Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    // 6. Handle Background / Terminated Message Taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleRemoteMessageData(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleRemoteMessageData(message.data);
      }
    });
  }

  Future<bool> requestNotificationPermission() async {
    try {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      if (kDebugMode) {
        print('[NOTIFICATIONS] Error requesting permission: $e');
      }
      return false;
    }
  }

  Future<void> registerFcmToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null && token.isNotEmpty) {
        await _sendTokenToBackend(token);
      }
    } catch (e) {
      if (kDebugMode) {
        print('[NOTIFICATIONS] Error getting FCM token: $e');
      }
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    // The current customer API (https://astrovedham.com/api) does not support an FCM token registration endpoint.
    if (kDebugMode) {
      print('[NOTIFICATIONS] FCM token registration skipped (unsupported by backend API contract)');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      final orderNumber = message.data['orderNumber']?.toString() ?? '';
      final type = message.data['type']?.toString() ?? 'horoscope_ready';

      if (kDebugMode) {
        print('[NOTIFICATIONS] Received foreground message type: $type for order: $orderNumber');
      }

      _localNotifications.show(
        notification.hashCode,
        notification.title ?? 'orders.horoscope_ready_title'.tr(),
        notification.body ?? 'orders.horoscope_ready_body'.tr(),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'astrovedham_channel',
            'AstroVedham Notifications',
            channelDescription: 'Notifications for horoscope reports and downloads',
            importance: Importance.high,
            priority: Priority.high,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: orderNumber,
      );
    }
  }

  void _handleNotificationPayload(String? orderNumber) {
    if (orderNumber != null && orderNumber.isNotEmpty) {
      NotificationNavigation.handle(orderNumber: orderNumber, type: 'horoscope_ready');
    }
  }

  void _handleRemoteMessageData(Map<String, dynamic> data) {
    final orderNumber = data['orderNumber']?.toString();
    final type = data['type']?.toString();
    if (orderNumber != null && orderNumber.isNotEmpty) {
      NotificationNavigation.handle(orderNumber: orderNumber, type: type);
    }
  }

  Future<void> showDownloadSuccessNotification(String orderNumber) async {
    if (kIsWeb) return;
    try {
      NotificationSettings settings = await _fcm.getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        if (kDebugMode) {
          print('[NOTIFICATIONS] Notification permission denied; skipping download notification');
        }
        return;
      }

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'astrovedham_channel',
        'AstroVedham Notifications',
        channelDescription: 'Notifications for horoscope reports and downloads',
        importance: Importance.high,
        priority: Priority.high,
      );
      const NotificationDetails details = NotificationDetails(android: androidDetails);

      await _localNotifications.show(
        orderNumber.hashCode,
        'orders.download_notification_title'.tr(),
        'orders.download_notification_body'.tr(),
        details,
        payload: orderNumber,
      );
    } catch (e) {
      if (kDebugMode) {
        print('[NOTIFICATIONS] Error showing download notification: $e');
      }
    }
  }
}
