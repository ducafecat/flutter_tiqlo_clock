import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../clock/clock_providers.dart';
import '../../../clock/clock_settings_store.dart';
import '../../../core/router/app_router.dart';
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
    _keepAwake = engine.keepAwake;
    return Scaffold(
      backgroundColor: const Color(0xFF11100E),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.5, -0.8),
            radius: 1.2,
            colors: [Color(0xFF1A1916), Color(0xFF171612)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 426),
              child: Column(
                children: [
                  PixelPageHeader(
                    title: 'Settings',
                    onBack: () => AppRoutes.backToClock(context),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                      children: [
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
                        const SizedBox(height: 25),
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
                        const SizedBox(height: 25),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
