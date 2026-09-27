import 'package:flutter/foundation.dart';
import '../models/reminder.dart';
import 'reminder_storage.dart';
import 'notification_service.dart';

class ReminderController extends ChangeNotifier {
  final ReminderStorage _storage = ReminderStorage();
  final NotificationService _notifications = NotificationService();

  List<Reminder> _reminders = [];
  bool _checkingExpired = false;
  List<Reminder> get reminders => _reminders;

  Future<void> load() async {
    _reminders = await _storage.loadAll();
    await markExpiredRemindersCompleted(notify: false);
    notifyListeners();
  }

  Future<void> markExpiredRemindersCompleted({bool notify = true}) async {
    if (_checkingExpired) {
      return;
    }

    final expired = _reminders
        .where(
          (reminder) =>
              reminder.isActive &&
              !reminder.isCompleted &&
              !reminder.scheduledTime.isAfter(DateTime.now()),
        )
        .toList();

    if (expired.isEmpty) {
      return;
    }

    _checkingExpired = true;
    try {
      final completedAt = DateTime.now();
      for (final reminder in expired) {
        await _storage.update(
          reminder.copyWith(
            isActive: false,
            isCompleted: true,
            completedAt: completedAt,
          ),
        );
      }

      _reminders = await _storage.loadAll();
      if (notify) {
        notifyListeners();
      }
    } finally {
      _checkingExpired = false;
    }
  }

  // ─── Crear ─────────────────────────────────────────────────
  Future<void> addReminder({
    required String title,
    required Duration duration,
  }) async {
    final existingIds = _reminders.map((reminder) => reminder.id).toSet();
    var id = DateTime.now().microsecondsSinceEpoch.remainder(2147483647);
    while (existingIds.contains(id)) {
      id = (id + 1).remainder(2147483647);
    }
    final reminder = Reminder(
      id: id,
      title: title,
      scheduledTime: DateTime.now().add(duration),
    );
    await _storage.add(reminder);
    await _notifications.scheduleReminder(reminder);
    _reminders = await _storage.loadAll();
    notifyListeners();
  }

  // ─── Eliminar ──────────────────────────────────────────────
  Future<void> deleteReminder(Reminder reminder) async {
    await _notifications.cancelReminder(reminder.id);
    await _storage.delete(reminder.id);
    _reminders = await _storage.loadAll();
    notifyListeners();
  }

  Future<void> completeReminder(Reminder reminder) async {
    await _notifications.cancelReminder(reminder.id);
    final completed = reminder.copyWith(
      isActive: false,
      isCompleted: true,
      completedAt: DateTime.now(),
    );
    await _storage.update(completed);
    _reminders = await _storage.loadAll();
    notifyListeners();
  }

  // ─── Actualizar (edición completa) ─────────────────────────
  Future<void> updateReminder(
    Reminder old, {
    required String title,
    required Duration duration,
  }) async {
    final updated = old.copyWith(
      title: title,
      scheduledTime: DateTime.now().add(duration),
      isActive: true,
      isCompleted: false,
      completedAt: null,
      clearCompletedAt: true,
    );
    // Cancelar la alarma vieja antes de reprogramar
    await _notifications.cancelReminder(old.id);
    await _storage.update(updated);
    await _notifications.scheduleReminder(updated);
    _reminders = await _storage.loadAll();
    notifyListeners();
  }

  // ─── Posponer (snooze) ─────────────────────────────────────
  Future<void> snoozeReminder(Reminder reminder, Duration extra) async {
    final updated = reminder.copyWith(
      scheduledTime: DateTime.now().add(extra),
    );
    // Cancelar alarma actual y programar la nueva
    await _notifications.cancelReminder(reminder.id);
    await _storage.update(updated);
    await _notifications.scheduleReminder(updated);
    _reminders = await _storage.loadAll();
    notifyListeners();
  }

  Future<void> toggleReminder(Reminder reminder) async {
    final shouldActivate = !reminder.isActive;
    final updated = reminder.copyWith(
      isActive: shouldActivate,
      scheduledTime: shouldActivate && reminder.scheduledTime.isBefore(DateTime.now())
          ? DateTime.now().add(const Duration(minutes: 1))
          : reminder.scheduledTime,
    );

    if (shouldActivate) {
      await _notifications.scheduleReminder(updated);
    } else {
      await _notifications.cancelReminder(reminder.id);
    }
    await _storage.update(updated);
    _reminders = await _storage.loadAll();
    notifyListeners();
  }
}