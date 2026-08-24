import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../clock/clock_providers.dart';
import '../../../clock/clock_settings_store.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/clock_wake.dart';
import '../../../core/ui/ui.dart';
import '../../../shared/widgets/widgets.dart';

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
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeader(title: 'Time & Date'),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsGroup(
                    children: [
                      SwitchListTile(
                        title: const Text('24 Hour'),
                        value: engine.is24Hour,
                        onChanged: (value) async {
                          await engine.setTimeFormat(
                            value ? TimeFormat.h24 : TimeFormat.h12,
                          );
                          if (!mounted) return;
                          ref.invalidate(clockSnapshotProvider);
                          setState(() {});
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Show Leading Zero'),
                        value: engine.showLeadingZero,
                        onChanged: (value) async {
                          await engine.setShowLeadingZero(value);
                          if (!mounted) return;
                          ref.invalidate(clockSnapshotProvider);
                          setState(() {});
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Show Seconds'),
                        value: engine.showSeconds,
                        onChanged: (value) async {
                          await engine.setShowSeconds(value);
                          if (!mounted) return;
                          ref.invalidate(clockSnapshotProvider);
                          setState(() {});
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Date & Weekday'),
                        value: engine.showDate,
                        onChanged: (value) async {
                          await engine.setShowDate(value);
                          if (!mounted) return;
                          ref.invalidate(clockSnapshotProvider);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const SectionHeader(title: 'Display'),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsGroup(
                    children: [
                      SwitchListTile(
                        title: const Text('Keep Screen Awake'),
                        value: engine.keepAwake,
                        onChanged: (value) async {
                          await engine.setKeepAwake(value);
                          if (!mounted) return;
                          setState(() {});
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Night Mode'),
                        value: engine.nightMode,
                        onChanged: (value) async {
                          await engine.setNightMode(value);
                          if (!mounted) return;
                          ref.invalidate(clockSnapshotProvider);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const SectionHeader(title: 'Alerts'),
                  const SizedBox(height: AppSpacing.sm),
                  SettingsGroup(
                    children: [
                      SwitchListTile(
                        title: const Text('Sound'),
                        value: engine.soundEnabled,
                        onChanged: (value) async {
                          await engine.setSoundEnabled(value);
                          if (!mounted) return;
                          setState(() {});
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Vibration'),
                        value: engine.vibrationEnabled,
                        onChanged: (value) async {
                          await engine.setVibrationEnabled(value);
                          if (!mounted) return;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
