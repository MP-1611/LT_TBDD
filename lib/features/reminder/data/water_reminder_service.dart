import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/notification_service.dart';

class WaterReminderService {
  static const int _baseId = 1000;
  static const _channel = AndroidNotificationDetails(
    'water_reminder',
    'Water Reminder',
    importance: Importance.max,
    priority: Priority.high,
  );

  /// 🔥 Hủy toàn bộ notification cũ
  static Future<void> cancelAll() async {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.cancelAll();
    await NotificationService.cancelAll();
  }

  /// 🔔 Tạo notification lặp
  static Future<void> scheduleReminders({
    required int startHour,
    required int endHour,
    required int intervalMinutes,
  }) async {
    if (intervalMinutes <= 0) return;

    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime start = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      startHour,
    );

    tz.TZDateTime end = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      endHour,
    );

    // Nếu bedtime < wakeup → sang ngày hôm sau
    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }

    int id = _baseId;
    tz.TZDateTime time = start;

    while (time.isBefore(end)) {
      // Không schedule quá khứ
      if (time.isAfter(now)) {
        await _scheduleDaily(id, time);
        id++;
      }
      time = time.add(Duration(minutes: intervalMinutes));
    }
  }

  /// 🔔 Schedule 1 notification lặp hàng ngày
  static Future<void> _scheduleDaily(int id, tz.TZDateTime time) async {
    const android = AndroidNotificationDetails(
      'water_reminder',
      'Water Reminder',
      channelDescription: 'Nhắc uống nước',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: android);

    await NotificationService.local.zonedSchedule(
      id,
      '💧 Uống nước',
      'Đến giờ uống nước rồi!',
      time,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
  WaterReminderService.saveSettings({
    required bool enabled,
    required TimeOfDay wakeUp,
    required TimeOfDay bedTime,
    required int intervalMinutes,
  });
  WaterReminderService.cancelALL();
  WaterReminderService.scheduleDaily({
    required TimeOfDay wakeUp,
    required TimeOfDay bedTime,
    required int intervalMinutes,
  });
  static Future<void> scheduleAtTimes({
    required List<DateTime> times,
    required String title,
    required String body,
  }) async {
    int id = 100;

    for (final time in times) {
      await NotificationService.schedule(
        id: id++,
        dateTime: time,
        title: title,
        body: body,
      );
    }
  }

}
