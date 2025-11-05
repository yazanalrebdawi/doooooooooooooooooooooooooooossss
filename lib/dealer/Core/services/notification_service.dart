import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request notification permission for Android 13+
      if (Platform.isAndroid) {
        final androidInfo = await _localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();

        debugPrint('📱 Android notification permission: $androidInfo');

        // Also request via permission_handler for Android 13+
        final status = await Permission.notification.request();
        debugPrint('📱 Notification permission status: $status');
      }

      // Android initialization
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Combined initialization settings
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // Initialize the plugin
      final initialized = await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          _handleNotificationTap(details.payload);
        },
      );

      debugPrint('✅ Notification plugin initialized: $initialized');

      // Create notification channel for Android
      if (Platform.isAndroid) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
        debugPrint('✅ Notification channel created');
      }

      _isInitialized = true;
      debugPrint('✅ Local notification service initialized');
    } catch (e) {
      debugPrint('❌ Error initializing notification service: $e');
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      // Ensure service is initialized
      if (!_isInitialized) {
        debugPrint(
            '⚠️ Notification service not initialized, initializing now...');
        await initialize();
      }

      // Check permission on Android 13+
      if (Platform.isAndroid) {
        final permissionStatus = await Permission.notification.status;
        if (permissionStatus.isDenied) {
          debugPrint('⚠️ Notification permission denied, requesting...');
          final requested = await Permission.notification.request();
          if (requested.isDenied) {
            debugPrint('❌ Notification permission still denied');
            return;
          }
        }
      }

      debugPrint('📤 Showing notification: $title - $body');

      await _localNotifications.show(
        id,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            vibrationPattern: Int64List.fromList([
              0, // Start immediately
              500, // Vibrate for 500ms
              250, // Pause for 250ms
              500, // Vibrate again for 500ms
              250, // Pause
              500, // Final vibration
            ]),
            icon: '@mipmap/ic_launcher',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            showWhen: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: payload,
      );

      debugPrint('✅ Notification shown successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error showing notification: $e');
      debugPrint('❌ Stack trace: $stackTrace');
    }
  }

  void _handleNotificationTap(String? payload) {
    debugPrint('Notification tapped with payload: $payload');
    // Handle navigation or actions based on payload
  }
}
