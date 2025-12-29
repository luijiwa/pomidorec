import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Controller for the Pomodoro timer based on ChangeNotifier
class HomePageController extends ChangeNotifier {
  Timer? _timer;
  int _remainingTime = 25 * 60;
  bool _isRunning = false;
  Color _timerColor = Colors.red;
  int _pomodoroCount = 0;

  static const int workDuration = 25 * 60;
  static const int shortBreakDuration = 5 * 60;
  static const int longBreakDuration = 15 * 60;

  int get remainingTime => _remainingTime;
  bool get isRunning => _isRunning;
  Color get timerColor => _timerColor;

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    notifyListeners();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        stopTimer();
        _nextTimer();
        notifyListeners();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    _remainingTime = workDuration;
    _pomodoroCount = 0;
    _timerColor = Colors.red;
    notifyListeners();
  }

  void _nextTimer() {
    _pomodoroCount++;
    if (_pomodoroCount % 4 == 0) {
      _remainingTime = longBreakDuration;
      _timerColor = Colors.blue;
    } else {
      final isRest = _pomodoroCount % 2 == 1;
      _remainingTime = isRest ? shortBreakDuration : workDuration;
      _timerColor = isRest ? Colors.green : Colors.red;
    }
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    try {
      _timer?.cancel();
    } on Object catch (error, stackTrace) {
      // Explicitly ignored: timer cancellation during dispose should be safe.
    }
    super.dispose();
  }
}

// String _formatTime(int seconds) {
//   final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
//   final secs = (seconds % 60).toString().padLeft(2, '0');
//   return '$minutes:$secs';
// }
