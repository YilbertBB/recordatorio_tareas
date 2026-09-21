class Reminder {
  final int id;
  final String title;
  final DateTime scheduledTime;
  final bool isActive;

  Reminder({
    required this.id,
    required this.title,
    required this.scheduledTime,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'scheduledTime': scheduledTime.toIso8601String(),
    'isActive': isActive,
  };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    id: json['id'],
    title: json['title'],
    scheduledTime: DateTime.parse(json['scheduledTime']),
    isActive: json['isActive'] ?? true,
  );
}
