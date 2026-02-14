class WorkoutSession {
  final DateTime date;
  final int durationMinutes;
  final int calories;

  const WorkoutSession({
    required this.date,
    required this.durationMinutes,
    required this.calories,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'durationMinutes': durationMinutes,
    'calories': calories,
  };

  static WorkoutSession fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      date: DateTime.parse(json['date'] as String),
      durationMinutes: json['durationMinutes'] as int,
      calories: json['calories'] as int,
    );
  }
}
