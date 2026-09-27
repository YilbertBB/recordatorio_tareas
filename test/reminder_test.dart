import 'package:flutter_test/flutter_test.dart';
import 'package:recordatorio_tareas/models/reminder.dart';

void main() {
  test('Reminder se serializa y deserializa correctamente', () {
    final original = Reminder(
      id: 1,
      title: 'Agua hirviendo',
      scheduledTime: DateTime(2026, 9, 21, 10, 30),
      isCompleted: true,
      completedAt: DateTime(2026, 9, 21, 10, 30),
    );
    final restored = Reminder.fromJson(original.toJson());
    expect(restored.title, original.title);
    expect(restored.scheduledTime, original.scheduledTime);
    expect(restored.isCompleted, isTrue);
    expect(restored.completedAt, original.completedAt);
  });
}
