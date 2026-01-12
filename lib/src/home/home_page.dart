import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pomidorec/src/home/home_page_controller.dart';
import 'package:pomidorec/src/localization/app_localizations.dart';
import 'package:pomidorec/src/settings/settings_view.dart';

/// {@template home_page}
/// The home page of the Pomidorec application.
/// {@endtemplate}
class HomePage extends StatefulWidget {
  /// {@macro home_page}
  const HomePage({
    super.key,
  });
  static const routeName = '/home';

  /// Returns the [_HomePageState] associated with the closest [HomePage]
  /// ancestor of the given [context], or `null` if no such ancestor exists.
  @internal
  static _HomePageState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_HomePageState>();

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State for widget HomePage.
class _HomePageState extends State<HomePage> {
  late final HomePageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomePageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, SettingsView.routeName),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundColor: _controller.timerColor,
                ),
                Text(
                  _controller.formatTime(_controller.remainingTime),
                  style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:
                          _controller.isRunning ? null : _controller.startTimer,
                      child: Text(AppLocalizations.of(context)!.start),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed:
                          _controller.isRunning ? _controller.stopTimer : null,
                      child: Text(AppLocalizations.of(context)!.stop),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _controller.resetTimer,
                      child: Text(AppLocalizations.of(context)!.reset),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
