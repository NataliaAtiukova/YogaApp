import 'exercise.dart';

class YogaRoutine {
  final String id;
  final String title;
  final String description;
  final List<Exercise> exercises;

  const YogaRoutine({
    required this.id,
    required this.title,
    required this.description,
    required this.exercises,
  });

  int get totalDuration =>
      exercises.fold(0, (sum, exercise) => sum + exercise.duration);
}
