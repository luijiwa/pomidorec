import 'package:flutter/material.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Glue the SettingsController to the theme selection DropdownButton.
            //
            // When a user selects a theme from the dropdown list, the
            // SettingsController is updated, which rebuilds the MaterialApp.
            DropdownMenu<ThemeMode>(
              // Read the selected themeMode from the controller
              initialSelection: controller.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onSelected: controller.updateThemeMode,
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                    value: ThemeMode.system, label: 'System Theme'),
                DropdownMenuEntry(value: ThemeMode.light, label: 'Light Theme'),
                DropdownMenuEntry(value: ThemeMode.dark, label: 'Dark Theme')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
