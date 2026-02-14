import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/yoga_routine.dart';

class RoutineState {
  final YogaRoutine routine;
  final int currentIndex;
  final int remainingSeconds;
  final bool isRunning;
  final bool isCompleted;
  final bool hasStarted;
  final int? manualStepIndex;

  const RoutineState({
    required this.routine,
    required this.currentIndex,
    required this.remainingSeconds,
    required this.isRunning,
    required this.isCompleted,
    required this.hasStarted,
    required this.manualStepIndex,
  });

  factory RoutineState.initial(YogaRoutine routine) {
    final firstDuration = routine.exercises.isEmpty
        ? 0
        : routine.exercises.first.duration;
    return RoutineState(
      routine: routine,
      currentIndex: 0,
      remainingSeconds: firstDuration,
      isRunning: false,
      isCompleted: false,
      hasStarted: false,
      manualStepIndex: null,
    );
  }

  RoutineState copyWith({
    int? currentIndex,
    int? remainingSeconds,
    bool? isRunning,
    bool? isCompleted,
    bool? hasStarted,
    int? manualStepIndex,
    bool clearManualStep = false,
  }) {
    return RoutineState(
      routine: routine,
      currentIndex: currentIndex ?? this.currentIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
      hasStarted: hasStarted ?? this.hasStarted,
      manualStepIndex: clearManualStep
          ? null
          : manualStepIndex ?? this.manualStepIndex,
    );
  }

  double get progress {
    if (routine.exercises.isEmpty) {
      return 0;
    }
    if (isCompleted) {
      return 1;
    }
    final currentExercise = routine.exercises[currentIndex];
    final currentDuration = currentExercise.duration;
    final currentProgress = currentDuration == 0
        ? 0
        : (currentDuration - remainingSeconds) / currentDuration;
    return (currentIndex + currentProgress) / routine.exercises.length;
  }
}

class RoutineController extends StateNotifier<RoutineState> {
  RoutineController(this._routine) : super(RoutineState.initial(_routine));

  final YogaRoutine _routine;
  Timer? _timer;

  void startOrResume() {
    if (state.isCompleted || state.isRunning) {
      return;
    }
    _timer?.cancel();
    state = state.copyWith(isRunning: true, hasStarted: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void pause() {
    if (!state.isRunning) {
      return;
    }
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void toggle() {
    if (state.isRunning) {
      pause();
    } else {
      startOrResume();
    }
  }

  void reset() {
    _timer?.cancel();
    state = RoutineState.initial(_routine);
  }

  void selectExercise(int index) {
    if (index < 0 || index >= _routine.exercises.length) {
      return;
    }
    _timer?.cancel();
    final duration = _routine.exercises[index].duration;
    state = state.copyWith(
      currentIndex: index,
      remainingSeconds: duration,
      isRunning: false,
      isCompleted: false,
      hasStarted: false,
      clearManualStep: true,
    );
  }

  void setManualStepIndex(int index) {
    final stepsCount = state.routine.exercises[state.currentIndex].steps.length;
    if (stepsCount == 0) {
      return;
    }
    final safeIndex = index.clamp(0, stepsCount - 1);
    state = state.copyWith(manualStepIndex: safeIndex);
  }

  void clearManualStepIndex() {
    state = state.copyWith(clearManualStep: true);
  }

  void nextStep() {
    final stepsCount = state.routine.exercises[state.currentIndex].steps.length;
    if (stepsCount == 0) {
      return;
    }
    final base = state.manualStepIndex ?? _autoStepIndex();
    final next = (base + 1).clamp(0, stepsCount - 1);
    state = state.copyWith(manualStepIndex: next);
  }

  void previousStep() {
    final stepsCount = state.routine.exercises[state.currentIndex].steps.length;
    if (stepsCount == 0) {
      return;
    }
    final base = state.manualStepIndex ?? _autoStepIndex();
    final prev = (base - 1).clamp(0, stepsCount - 1);
    state = state.copyWith(manualStepIndex: prev);
  }

  void _tick() {
    if (state.remainingSeconds > 1) {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      return;
    }
    _advance();
  }

  void _advance() {
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= _routine.exercises.length) {
      _timer?.cancel();
      state = state.copyWith(
        isRunning: false,
        isCompleted: true,
        remainingSeconds: 0,
        clearManualStep: true,
      );
      return;
    }
    final nextDuration = _routine.exercises[nextIndex].duration;
    state = state.copyWith(
      currentIndex: nextIndex,
      remainingSeconds: nextDuration,
      isRunning: true,
      hasStarted: true,
      clearManualStep: true,
    );
  }

  int _autoStepIndex() {
    final stepsCount = state.routine.exercises[state.currentIndex].steps.length;
    if (stepsCount == 0) {
      return 0;
    }
    if (!state.hasStarted) {
      return 0;
    }
    final total = state.routine.exercises[state.currentIndex].duration;
    if (total == 0) {
      return 0;
    }
    final elapsed = (total - state.remainingSeconds).clamp(0, total);
    final stepDuration = total / stepsCount;
    final index = (elapsed / stepDuration).floor();
    return index.clamp(0, stepsCount - 1);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final routineControllerProvider = StateNotifierProvider.autoDispose
    .family<RoutineController, RoutineState, YogaRoutine>((ref, routine) {
      return RoutineController(routine);
    });
