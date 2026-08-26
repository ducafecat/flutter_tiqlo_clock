import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../clock/clock_providers.dart';
import '../../../clock/clock_settings_store.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/clock_wake.dart';
import '../../../core/ui/pixel/pixel_ui.dart';

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
    final tokens = PixelTokens.of(context);
    _keepAwake = engine.keepAwake;
    return Scaffold(
      backgroundColor: tokens.chrome,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                PixelPageHeader(
                  title: 'Settings',
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                SizedBox(height: tokens.spacingLg),
                PixelSection(
                  title: 'Time & Date',
                  children: [
                    PixelSwitch(
                      label: '24 Hour',
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
                    PixelSwitch(
                      label: 'Show Leading Zero',
                      value: engine.showLeadingZero,
                      onChanged: (value) async {
                        await engine.setShowLeadingZero(value);
                        if (!mounted) return;
                        ref.invalidate(clockSnapshotProvider);
                        setState(() {});
                      },
                    ),
                    PixelSwitch(
                      label: 'Show Seconds',
                      value: engine.showSeconds,
                      onChanged: (value) async {
                        await engine.setShowSeconds(value);
                        if (!mounted) return;
                        ref.invalidate(clockSnapshotProvider);
                        setState(() {});
                      },
                    ),
                    PixelSwitch(
                      label: 'Date & Weekday',
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
                SizedBox(height: tokens.spacingLg),
                PixelSection(
                  title: 'Display',
                  children: [
                    PixelSwitch(
                      label: 'Keep Screen Awake',
                      value: engine.keepAwake,
                      onChanged: (value) async {
                        await engine.setKeepAwake(value);
                        if (!mounted) return;
                        setState(() {});
                      },
                    ),
                    PixelSwitch(
                      label: 'Night Mode',
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
                SizedBox(height: tokens.spacingLg),
                PixelSection(
                  title: 'Alerts',
                  children: [
                    PixelSwitch(
                      label: 'Sound',
                      value: engine.soundEnabled,
                      onChanged: (value) async {
                        await engine.setSoundEnabled(value);
                        if (!mounted) return;
                        setState(() {});
                      },
                    ),
                    PixelSwitch(
                      label: 'Vibration',
                      value: engine.vibrationEnabled,
                      onChanged: (value) async {
                        await engine.setVibrationEnabled(value);
                        if (!mounted) return;
                        setState(() {});
                      },
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
