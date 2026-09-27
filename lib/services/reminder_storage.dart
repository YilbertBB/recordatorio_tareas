import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';

class ReminderStorage {
  static const _key = 'reminders';

  Future<List<Reminder>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final list = <Reminder>[];
    for (final value in raw) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          list.add(Reminder.fromJson(decoded));
        }
      } on FormatException {
        // Ignorar entradas dañadas para que una preferencia no bloquee la app.
      } on JsonUnsupportedObjectError {
        // Ignorar entradas que no contienen JSON válido.
      }
    }
    // Ordenar por hora programada
    list.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return list;
  }

  Future<void> saveAll(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      reminders.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> add(Reminder reminder) async {
    final list = await loadAll();
    list.add(reminder);
    await saveAll(list);
  }

  Future<void> delete(int id) async {
    final list = await loadAll();
    list.removeWhere((r) => r.id == id);
    await saveAll(list);
  }

  Future<void> update(Reminder reminder) async {
    final list = await loadAll();
    final index = list.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      list[index] = reminder;
      await saveAll(list);
    }
  }
}