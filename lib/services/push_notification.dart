
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebasePushNotificationService {
  static final _pushNotification = FirebaseMessaging.instance;

  static Future<String?> getToken() async {

    final token = await _pushNotification.getToken();
    return token;
  }

  static Future<void> init() async {
    // push notification yuborish uchun ruxsat so'raymiz
    final notificationSettings = await _pushNotification.requestPermission();

    // qurilmani TOKEN'ni olamiz
    // shu orqali qaysi qurilmaga xabarnoma yuborishni aniqlaymiz
    // final token = await _pushNotification.getToken();
    // backgrounda xabar kelsa ishlaydi
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print("XABAR ORQALI DASTURNI OCHGANDA KELDI");
    //   print('XAbar: $message');
    // });

    // // foregroundda xabar kelsa ishlaydi
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('DASTURDA BO\'LGANDA XABAR KELDI');
    //   print('Xabar: ${message.data}');

    //   if (message.notification != null) {
    //     print(
    //         'Message also contained a notification: ${message.notification!.title}');
    //   }
    // });
    // await FirebaseMessaging.instance.subscribeToTopic("Motivatsiya");
  }

  static void sendNotificationMessage(
      String token, String fromUSer, String message) async {
    await Future.delayed(Duration(seconds: 2));
    final jsonCredentials = await rootBundle.loadString('service-account.json');

    var accountCredentials =
    ServiceAccountCredentials.fromJson(jsonCredentials);

    var scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);

    // print(client.credentials.accessToken);
    final notificationData = {
      'message': {
        'token': token,
        'notification': {

          'title': fromUSer,
          'body': message,
        }
      },
    };

    const projectId = "telegram-chat-tg";
    Uri url = Uri.parse(
        "https://fcm.googleapis.com/v1/projects/$projectId/messages:send");

    final response = await client.post(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${client.credentials.accessToken}',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      print("YUBORILDI");
    }

    // print('Notification Sending Error Response status: ${response.statusCode}');
    // print('Notification Response body: ${response.body}');
  }


  static void sendNotificationImage(
      String token, String fromUSer, String image) async {
    await Future.delayed(const Duration(seconds: 2));
    final jsonCredentials = await rootBundle.loadString('service-account.json');

    var accountCredentials =
    ServiceAccountCredentials.fromJson(jsonCredentials);

    var scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);

    final notificationData = {
      'message': {
        'token': token,
        'notification': {

          'title': fromUSer,
          'image': image,
        }
      },
    };

    const projectId = "telegram-chat-tg";
    Uri url = Uri.parse(
        "https://fcm.googleapis.com/v1/projects/$projectId/messages:send");

    final response = await client.post(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${client.credentials.accessToken}',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      print("YUBORILDI");
    }

    // print('Notification Sending Error Response status: ${response.statusCode}');
    // print('Notification Response body: ${response.body}');
  }

}
