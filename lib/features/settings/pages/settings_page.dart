import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../clock/clock_providers.dart';
import '../../../clock/clock_settings_store.dart';
import '../../../core/ui/clock_system_ui.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    ClockSystemUi.show();
  }

  @override
  void dispose() {
    ClockSystemUi.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engine = ref.watch(clockEngineProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('24 Hour'),
            value: engine.is24Hour,
            onChanged: (value) {
              engine.setTimeFormat(value ? TimeFormat.h24 : TimeFormat.h12);
              ref.invalidate(clockSnapshotProvider);
              setState(() {});
            },
          ),
          SwitchListTile(
            title: const Text('Show Seconds'),
            value: engine.showSeconds,
            onChanged: (value) {
              engine.setShowSeconds(value);
              ref.invalidate(clockSnapshotProvider);
              setState(() {});
            },
          ),
          SwitchListTile(
            title: const Text('Date & Weekday'),
            value: engine.showDate,
            onChanged: (value) {
              engine.setShowDate(value);
              ref.invalidate(clockSnapshotProvider);
              setState(() {});
            },
          ),
          SwitchListTile(
            title: const Text('Sound'),
            value: engine.soundEnabled,
            onChanged: (value) {
              engine.setSoundEnabled(value);
              setState(() {});
            },
          ),
          SwitchListTile(
            title: const Text('Vibration'),
            value: engine.vibrationEnabled,
            onChanged: (value) {
              engine.setVibrationEnabled(value);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
