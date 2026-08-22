import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../clock/clock_providers.dart';
import '../../../clock/clock_settings_store.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/clock_wake.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  var _keepAwake = true;

  @override
  void initState() {
    super.initState();
    ClockSystemUi.show();
    ClockWake.setEnabled(false);
  }

  @override
  void dispose() {
    ClockSystemUi.hide();
    ClockWake.setEnabled(_keepAwake);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engine = ref.watch(clockEngineProvider);
    _keepAwake = engine.keepAwake;
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
            title: const Text('Show Leading Zero'),
            value: engine.showLeadingZero,
            onChanged: (value) {
              engine.setShowLeadingZero(value);
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
            title: const Text('Keep Screen Awake'),
            value: engine.keepAwake,
            onChanged: (value) {
              engine.setKeepAwake(value);
              setState(() {});
            },
          ),
          SwitchListTile(
            title: const Text('Night Mode'),
            value: engine.nightMode,
            onChanged: (value) {
              engine.setNightMode(value);
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
