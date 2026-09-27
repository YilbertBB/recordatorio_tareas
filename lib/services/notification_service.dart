import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import '../models/reminder.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      flutterLocalNotificationsPlugin;

  // Rango válido para el id en Android (int de 32 bits)
  static const int _minId = -2147483648;
  static const int _maxId = 2147483647;

  bool _isValidId(int id) => id >= _minId && id <= _maxId;

  Future<void> scheduleReminder(Reminder reminder) async {
    if (!reminder.isActive) {
      return;
    }

    // Validación defensiva: no programar si el id está fuera de rango
    if (!_isValidId(reminder.id)) {
      debugPrint('ID fuera de rango, no se programa: ${reminder.id}');
      return;
    }

    // Verificar permiso de alarma exacta antes de programar
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final canExact =
        await androidImpl?.canScheduleExactNotifications() ?? false;

    await _plugin.zonedSchedule(
      id: reminder.id,
      title: '⏰ ${reminder.title}',
      body: 'Es hora de revisar',
      scheduledDate: tz.TZDateTime.from(reminder.scheduledTime, tz.local),
      androidScheduleMode: canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      payload: reminder.id.toString(),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders_channel_v2',
          'Recordatorios',
          channelDescription: 'Avisos de recordatorios programados',
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          channelShowBadge: true,
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.reminder,
          autoCancel: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> cancelReminder(int id) async {
    if (!_isValidId(id)) {
      debugPrint('ID fuera de rango, se ignora cancel($id)');
      return;
    }
    await _plugin.cancel( id: id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}