String formatSeconds(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  final secondsPadded = seconds.toString().padLeft(2, '0');
  return '$minutes:$secondsPadded';
}

String formatMinutesShort(int totalSeconds) {
  final minutes = (totalSeconds / 60).ceil();
  return '$minutes мин';
}
