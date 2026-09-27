class Reminder {
  final int id;
  final String title;
  final DateTime scheduledTime;
  final bool isActive;
  final bool isCompleted;
  final DateTime? completedAt;

  Reminder({
    required this.id,
    required this.title,
    required this.scheduledTime,
    this.isActive = true,
    this.isCompleted = false,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'scheduledTime': scheduledTime.toIso8601String(),
        'isActive': isActive,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory Reminder.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final scheduledTime = json['scheduledTime'];

    if (id is! int || title is! String || scheduledTime is! String) {
      throw const FormatException('Formato de recordatorio inválido');
    }

    return Reminder(
      id: id,
      title: title,
      scheduledTime: DateTime.parse(scheduledTime),
      isActive: json['isActive'] is bool ? json['isActive'] as bool : true,
        isCompleted: json['isCompleted'] is bool
          ? json['isCompleted'] as bool
          : false,
        completedAt: json['completedAt'] is String
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }

  Reminder copyWith({
    String? title,
    DateTime? scheduledTime,
    bool? isActive,
    bool? isCompleted,
    DateTime? completedAt,
    bool clearCompletedAt = false,
  }) =>
      Reminder(
        id: id,
        title: title ?? this.title,
        scheduledTime: scheduledTime ?? this.scheduledTime,
        isActive: isActive ?? this.isActive,
        isCompleted: isCompleted ?? this.isCompleted,
        completedAt: clearCompletedAt ? completedAt : completedAt ?? this.completedAt,
      );
}