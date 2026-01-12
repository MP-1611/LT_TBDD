import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class WaterReminderService {
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
  }

  /// 🔔 Tạo notification lặp
  static Future<void> scheduleReminders({
    required int startHour,
    required int endHour,
    required int intervalMinutes,
  }) async {
    final plugin = FlutterLocalNotificationsPlugin();

    int id = 0;
    final now = tz.TZDateTime.now(tz.local);

    for (int hour = startHour; hour <= endHour; hour++) {
      for (int minute = 0; minute < 60; minute += intervalMinutes) {
        final time = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        if (time.isBefore(now)) continue;

        await plugin.zonedSchedule(
          id++,
          'Uống nước 💧',
          'Đến giờ uống nước rồi!',
          time,
          NotificationDetails(android: _channel),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    }

    /// 👉 Lưu lịch
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('startHour', startHour);
    prefs.setInt('endHour', endHour);
    prefs.setInt('interval', intervalMinutes);
  }
}
