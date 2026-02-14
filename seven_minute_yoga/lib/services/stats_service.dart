import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/workout_session.dart';

const _storageKey = 'workout_sessions';

class DailyStat {
  final DateTime date;
  final int minutes;
  final int calories;

  const DailyStat({
    required this.date,
    required this.minutes,
    required this.calories,
  });
}

class StatsSummary {
  final int totalDays;
  final int totalSessions;
  final int totalCalories;
  final int streak;
  final List<DailyStat> last7Days;

  const StatsSummary({
    required this.totalDays,
    required this.totalSessions,
    required this.totalCalories,
    required this.streak,
    required this.last7Days,
  });
}

class StatsService {
  Future<List<WorkoutSession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => WorkoutSession.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveSessions(List<WorkoutSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final data = sessions.map((s) => s.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  Future<void> addSession(WorkoutSession session) async {
    final sessions = await loadSessions();
    sessions.add(session);
    await saveSessions(sessions);
  }

  Future<StatsSummary> getSummary() async {
    final sessions = await loadSessions();
    return buildSummary(sessions);
  }

  StatsSummary buildSummary(List<WorkoutSession> sessions) {
    if (sessions.isEmpty) {
      return StatsSummary(
        totalDays: 0,
        totalSessions: 0,
        totalCalories: 0,
        streak: 0,
        last7Days: _last7Days(const []),
      );
    }

    final totalCalories = sessions.fold<int>(0, (sum, s) => sum + s.calories);

    final uniqueDays = <DateTime>{for (final s in sessions) _dateOnly(s.date)};

    final streak = _calculateStreak(uniqueDays);

    return StatsSummary(
      totalDays: uniqueDays.length,
      totalSessions: sessions.length,
      totalCalories: totalCalories,
      streak: streak,
      last7Days: _last7Days(sessions),
    );
  }

  int _calculateStreak(Set<DateTime> days) {
    final today = _dateOnly(DateTime.now());
    var current = today;
    var count = 0;

    while (days.contains(current)) {
      count += 1;
      current = current.subtract(const Duration(days: 1));
    }

    return count;
  }

  List<DailyStat> _last7Days(List<WorkoutSession> sessions) {
    final today = _dateOnly(DateTime.now());
    final result = <DailyStat>[];

    for (int i = 6; i >= 0; i -= 1) {
      final day = today.subtract(Duration(days: i));
      final daySessions = sessions.where((s) => _dateOnly(s.date) == day);
      final minutes = daySessions.fold<int>(
        0,
        (sum, s) => sum + s.durationMinutes,
      );
      final calories = daySessions.fold<int>(0, (sum, s) => sum + s.calories);
      result.add(DailyStat(date: day, minutes: minutes, calories: calories));
    }

    return result;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

final statsServiceProvider = Provider<StatsService>((ref) => StatsService());

final statsSummaryProvider = FutureProvider<StatsSummary>((ref) async {
  final service = ref.read(statsServiceProvider);
  return service.getSummary();
});
