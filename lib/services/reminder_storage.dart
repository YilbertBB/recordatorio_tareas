import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';

class ReminderStorage {
  static const _key = 'reminders';

  Future<List<Reminder>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((e) => Reminder.fromJson(jsonDecode(e))).toList();
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
}
