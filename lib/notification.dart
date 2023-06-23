import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future init({bool scheduled = false}) async {
    var initAndoidSettings = const AndroidInitializationSettings('app');
    final settings = InitializationSettings(android: initAndoidSettings);
    await _notification.initialize(settings);
  }

  //instant notif
  static Future showNotification() async => _notification.periodicallyShow(
      0, 'title', 'body', RepeatInterval.everyMinute, notificationDetails());

  //cancel notif daily
  static Future cancelInstant() async => _notification.cancel(0);

  //schedule notif
  static Future showScheduleNotification(
          {required DateTime scheduletime}) async =>
      _notification.zonedSchedule(0, 'title', 'body',
          tz.TZDateTime.from(scheduletime, tz.local), notificationDetails(),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);

  //schedule notif daily
  static Future showScheduleDailyNotification(TimeOfDay time) async =>
      _notification.zonedSchedule(
        1,
        'Pengingat Absen',
        'Mohon periksa kehadiran anda hari ini',
        _scheduleDaily(time),
        notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  //cancel notif daily
  static Future cancelDaily() async => _notification.cancel(1);

  //time
  static tz.TZDateTime _scheduleDaily(TimeOfDay time) {
    var indoTimeZone = tz.getLocation('Asia/Jakarta');
    final now = tz.TZDateTime.now(indoTimeZone);
    final scheduleTime = tz.TZDateTime(
        indoTimeZone, now.year, now.month, now.day, time.hour, time.minute);
    print(now);
    print(scheduleTime);
    return scheduleTime.isBefore(now)
        ? scheduleTime.add(const Duration(days: 1))
        : scheduleTime;
  }

  static notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
      color: Colors.white,
      'channelId 1',
      'channelName',
      importance: Importance.max,
      priority: Priority.max,
    ));
  }
}
