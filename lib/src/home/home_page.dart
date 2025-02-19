import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// {@template home_page}
/// HomePage widget.
/// {@endtemplate}
class HomePage extends StatefulWidget {
  /// {@macro home_page}
  const HomePage({
    super.key,
  });
  static const routeName = '/home';

  /// The state from the closest instance of this class
  /// that encloses the given context, if any.
  @internal
  static _HomePageState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_HomePageState>();

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State for widget HomePage.
class _HomePageState extends State<HomePage> with HomePageController {
  /* #region Lifecycle */

  @override
  void dispose() {
    _timer.cancel();
    _timerColor.dispose();
    _isRunningNotifier.dispose();
    _remainingTimeNotifier.dispose();

    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appTitle),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<Color>(
                  valueListenable: _timerColor,
                  builder: (context, value, _) => CircleAvatar(
                    radius: 100,
                    backgroundColor: value,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _remainingTimeNotifier,
                  builder: (context, remainingTime, _) => Text(
                    _formatTime(remainingTime),
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _isRunningNotifier,
                      builder: (context, isRunning, _) => ElevatedButton(
                        onPressed: isRunning ? null : _startTimer,
                        child: Text(AppLocalizations.of(context)!.start),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ValueListenableBuilder(
                      valueListenable: _isRunningNotifier,
                      builder: (context, isRunning, _) => ElevatedButton(
                        onPressed: isRunning ? _stopTimer : null,
                        child: Text(AppLocalizations.of(context)!.stop),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _resetTimer,
                      child: Text(AppLocalizations.of(context)!.reset),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

/// Controller for widget HomePage
mixin HomePageController {
  late Timer _timer;
  final ValueNotifier<int> _remainingTimeNotifier =
      ValueNotifier<int>(25 * 60); // Начальное время (25 минут)
  final ValueNotifier<bool> _isRunningNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<Color> _timerColor = ValueNotifier<Color>(Colors.red);
  int _pomodoroCount = 0;

  final List<int> _timers = [
    25 * 60, // Рабочий таймер (25 минут)
    5 * 60, // Короткий перерыв (5 минут)
    15 * 60 // Длительный перерыв (15 минут)
  ];

  void _startTimer() {
    if (_isRunningNotifier.value) return;

    _isRunningNotifier.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeNotifier.value > 0) {
        _remainingTimeNotifier.value--;
      } else {
        _stopTimer();
        _nextTimer();
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();

    _isRunningNotifier.value = false;
  }

  void _resetTimer() {
    _stopTimer();

    _remainingTimeNotifier.value = 25 * 60; // Сброс к начальному времени
    _pomodoroCount = 0;
  }

  void _nextTimer() {
    _pomodoroCount++;
    if (_pomodoroCount % 4 == 0) {
      // После каждых 4 рабочих таймеров - длительный перерыв
      _remainingTimeNotifier.value = _timers[2];
      _timerColor.value = Colors.blue;
    } else {
      // Чередование рабочего таймера и короткого перерыва
      final isRest = _pomodoroCount % 2 == 1;
      _remainingTimeNotifier.value = isRest ? _timers[1] : _timers[0];
      _timerColor.value = isRest ? Colors.green : Colors.red;
    }
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
