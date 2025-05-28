import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final notifications = FlutterLocalNotificationsPlugin();

// 1. 앱 로드 시 실행할 기본 설정
Future<void> initNotification() async {
  // Android 13 이상: 알림 권한 요청
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // 안드로이드용 아이콘 설정 - 기본 앱 아이콘 사용
  const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettings = InitializationSettings(
    android: androidSetting,
    // iOS 설정 비활성화 중
  );

  await notifications.initialize(initializationSettings);
}

// 2. 알림 표시 함수
Future<void> showNotification(String title, String body) async {
  var androidDetails = AndroidNotificationDetails(
    'unique_channel_id', // 채널 ID
    'Cinemagix 알림',       // 채널 이름 (사용자에게 보임)
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  notifications.show(
    1, // 알림 ID
    title,
    body,
    NotificationDetails(android: androidDetails),
  );
}
