import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class LocalNotificationService {
  static final _flutterLocalNotification = FlutterLocalNotificationsPlugin();

  static bool isNotificationEnabled = false;

  static Future<void> _requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      isNotificationEnabled = await _flutterLocalNotification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                sound: true,
                badge: true,
              ) ??
          false;
//* it for MacOS
      // await _flutterLocalNotification
      //         .resolvePlatformSpecificImplementation<
      //             MacOSFlutterLocalNotificationsPlugin>()
      //         ?.requestPermissions(
      //           alert: true,
      //           badge: true,
      //           sound: true,
      //         ) ??
      //     false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      final bool? grantedScheduledNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();

      isNotificationEnabled = grantedNotificationPermission ?? false;
      isNotificationEnabled = grantedScheduledNotificationPermission ?? false;
    }
  }

  static Future<void> init() async {
    await _requestPermission();

    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const androidInit = AndroidInitializationSettings("mipmap/ic_launcher");
    final iosInit = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          "telegram_notification",
          actions: [
            DarwinNotificationAction.plain('id_1', 'Action 1'),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );
    final initialNotification = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _flutterLocalNotification.initialize(
      initialNotification,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        print(notificationResponse.payload);
      },
    );
  }

  static void showNotification({
    int id = 0,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      "telegram_not",
      "telegram",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: "ticker",
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('id_1', 'Read'),
      ],
    );
    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: "telegram_notifaction",
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotification.show(
      id,
      title,
      body,
      notificationDetails,
      payload: "Hello World",
    );
  }
}
