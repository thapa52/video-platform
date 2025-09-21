import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../presentation/dashboard/controllers/dashboard.controller.dart';
import '../../../navigation/bindings/controller_handler.dart';
import '../../../theme/app_colors.dart';
import '../../daos/printlog.dart';
import '../api/api_service.dart';

final userRole = ''.obs;

Future<void> _navigateToDashboardThenNotifications() async {
  final dashboardHandler = ControllerHandler<DashboardController>(
    creator: () => DashboardController(),
    onFound: (controller) {
      printLog('DashboardController already exists');
    },
  );

  dashboardHandler.handle(); // ensure DashboardController is ready

  Get.offAllNamed('dashboard'); // triggers onInit
  await Future.delayed(Duration(seconds: 1));
  Get.toNamed('notifications');
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  printLog('fCM bg Title->${message.notification?.title}');
  printLog('fCM bg Body->${message.notification?.body}');
  printLog('fCM bg Payload->${message.data}');

  if (userRole.value != 'employee') {
    await _navigateToDashboardThenNotifications();
  }
}

class FirebasePushNotification {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final androidChannel = const AndroidNotificationChannel(
    'ecoland_channel',
    'General Notifications',
    description: 'This channel is used for important notification',
    importance: Importance.high,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> handleMessage(RemoteMessage? message) async {
    if (message == null) return;

    printLog('fCM Title->${message.notification!.title}');
    printLog('fCM Body->${message.notification!.body}');
    printLog('fCM Payload->${message.data}');

    if (userRole.value != 'employee') {
      if (Get.currentRoute != '/notifications' &&
          Get.currentRoute != 'notifications') {
        Get.toNamed('notifications');
      } else {
        printLog('Already on notifications screen. Skipping navigation.');
      }
    } else {
      printLog('userRole->$userRole');
    }
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    userRole.value = GetStorage().read('userRole').toString().toLowerCase();
    printLog('fcm userRole=$userRole');

    final fcmToken = await _firebaseMessaging.getToken();
    await fCMToken(fcmToken.toString());

    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ecoland_icon');
    const settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        final payload = notificationResponse.payload;
        if (payload == null) return;

        try {
          final message = RemoteMessage.fromMap(jsonDecode(payload));
          handleMessage(message);
        } catch (e) {
          printLog('Error decoding notification payload: $e');
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        if (message != null) await handleMessage(message);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        await handleMessage(message);
      },
    );

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        final notification = message.notification;
        if (notification == null) return;

        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              color: AppColors.brand[700],
              playSound: true,
              icon: '@drawable/ecoland_icon',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: jsonEncode(message.toMap()),
        );
      },
    );
  }

  Future<void> fCMToken(String fcmToken) async {
    try {
      printLog('fcmToken = $fcmToken');
      final data = {
        "fcmToken": fcmToken,
      };
      final response = await ApiService().post(
        'fcm-token',
        body: data,
      );
      if (response['status'] == true) {
        printLog('fcmToken response = $response');
      }
    } catch (e) {
      printLog('Error while post fcm token: $e');
    }
  }
}
