import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/reminder.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  NotificationService(this._plugin);

  Future<void> scheduleReminder(Reminder reminder) async {
    await _plugin.zonedSchedule(
      body:
          '⏰ ${reminder.title}'
          'Es hora de revisar',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: reminder.id.toString(),
      id: reminder.id,
      scheduledDate: tz.TZDateTime.from(reminder.scheduledTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders_channel',
          'Recordatorios',
          channelDescription: 'Avisos de recordatorios programados',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id: id);
  }
}
