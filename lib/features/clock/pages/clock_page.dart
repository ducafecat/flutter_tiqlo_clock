import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/clock_providers.dart';
import '../../../clock/clock_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/clock_wake.dart';
import '../widgets/clock_face.dart';

class ClockPage extends ConsumerStatefulWidget {
  const ClockPage({super.key});

  @override
  ConsumerState<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends ConsumerState<ClockPage>
    with WidgetsBindingObserver {
  bool _chromeVisible = false;
  Timer? _hideChromeTimer;

  @override
  void initState() {
    super.initState();
    ClockSystemUi.hide();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final engine = ref.read(clockEngineProvider);
      final session = engine.snapshot.session;
      if (session == null || session.status != SessionStatus.running) {
        ref.read(sessionAlertsProvider).cancel();
      }
      ClockWake.setEnabled(engine.keepAwake);
      NightBrightness.setEnabled(engine.nightMode);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _hideChromeTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final engine = ref.read(clockEngineProvider);
    final alerts = ref.read(sessionAlertsProvider);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      final session = engine.snapshot.session;
      if (session != null && session.status == SessionStatus.running) {
        alerts.schedule(session.remaining, session.kind);
      }
      return;
    }
    if (state == AppLifecycleState.resumed) {
      final session = engine.snapshot.session;
      if (session != null && session.status != SessionStatus.complete) {
        alerts.cancel();
      }
      ClockWake.setEnabled(engine.keepAwake);
      NightBrightness.setEnabled(engine.nightMode);
      ref.invalidate(clockSnapshotProvider);
    }
  }

  void _showChrome() {
    _hideChromeTimer?.cancel();
    setState(() => _chromeVisible = true);
    _hideChromeTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _chromeVisible = false);
    });
  }

  void _hideChrome() {
    _hideChromeTimer?.cancel();
    setState(() => _chromeVisible = false);
  }

  void _toggleChrome() {
    if (_chromeVisible) {
      _hideChrome();
    } else {
      _showChrome();
    }
  }

  void _openClockTheme() {
    _hideChromeTimer?.cancel();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final current = ref.read(clockEngineProvider).clockThemeId;
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final id in ClockThemeId.values)
                      ListTile(
                        title: Text(
                          id.label,
                          style: const TextStyle(color: Colors.white),
                        ),
                        selected: current == id,
                        selectedColor: Colors.white,
                        onTap: () {
                          ref.read(clockEngineProvider).setClockTheme(id);
                          ref.invalidate(clockSnapshotProvider);
                          setState(() {});
                          setSheetState(() {});
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      if (mounted) _showChrome();
    });
  }

  void _openFocus() {
    _openSessionPicker(
      kind: SessionKind.focus,
      presets: const [15, 25, 45, 60],
      defaultMinutes: 25,
      customMax: 90,
      highlightMinutes: 25,
      showToday: true,
    );
  }

  void _openTimer() {
    _openSessionPicker(
      kind: SessionKind.timer,
      presets: const [1, 5, 10, 30],
      defaultMinutes: 1,
      customMax: 180,
    );
  }

  void _openSessionPicker({
    required SessionKind kind,
    required List<int> presets,
    required int defaultMinutes,
    required int customMax,
    int? highlightMinutes,
    bool showToday = false,
  }) {
    _hideChromeTimer?.cancel();
    var minutes = defaultMinutes;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final today = ref.read(clockEngineProvider).snapshot;
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final value in presets)
                      ListTile(
                        title: Text(
                          '$value',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: value == highlightMinutes ? 22 : 16,
                            fontWeight: value == highlightMinutes
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                        selected: minutes == value,
                        selectedColor: Colors.white,
                        onTap: () => setSheetState(() => minutes = value),
                      ),
                    ListTile(
                      title: const Text(
                        'Custom',
                        style: TextStyle(color: Colors.white),
                      ),
                      selected: !presets.contains(minutes),
                      selectedColor: Colors.white,
                      onTap: () async {
                        final custom = await _pickCustomMinutes(
                          minutes,
                          max: customMax,
                        );
                        if (custom != null) {
                          setSheetState(() => minutes = custom);
                        }
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Start',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        Navigator.pop(sheetContext);
                        try {
                          await ref
                              .read(sessionAlertsProvider)
                              .requestPermissionOnFirstStart();
                        } catch (_) {}
                        ref
                            .read(clockEngineProvider)
                            .start(kind, Duration(minutes: minutes));
                        ref.invalidate(clockSnapshotProvider);
                        setState(() {});
                      },
                    ),
                    if (showToday)
                      ListTile(
                        title: Text(
                          'Today ${today.todayFocusCount} · ${today.todayFocusMinutes} min',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      if (mounted) _showChrome();
    });
  }

  Future<int?> _pickCustomMinutes(int current, {required int max}) {
    var value = current.clamp(1, max);
    return showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Custom', style: TextStyle(color: Colors.white)),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$value',
                    style: const TextStyle(color: Colors.white, fontSize: 32),
                  ),
                  Slider(
                    min: 1,
                    max: max.toDouble(),
                    divisions: max - 1,
                    value: value.toDouble(),
                    onChanged: (next) {
                      setDialogState(() => value = next.round());
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, value),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _openMore() {
    _hideChromeTimer?.cancel();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final engine = ref.read(clockEngineProvider);
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Night Mode',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: engine.nightMode,
                    onChanged: (value) {
                      engine.setNightMode(value);
                      ref.invalidate(clockSnapshotProvider);
                      setSheetState(() {});
                      setState(() {});
                    },
                  ),
                  _moreTile(sheetContext, 'Settings', AppRoutes.settings),
                  _moreTile(sheetContext, 'About', AppRoutes.about),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      if (mounted) _showChrome();
    });
  }

  Widget _moreTile(BuildContext sheetContext, String label, String route) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(sheetContext);
        context.push(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(clockSnapshotProvider);
    ref.listen(clockSnapshotProvider, (previous, next) {
      if (previous?.nightMode != next.nightMode) {
        NightBrightness.setEnabled(next.nightMode);
      }
      if (next.session?.status == SessionStatus.complete &&
          previous?.session?.status != SessionStatus.complete) {
        final engine = ref.read(clockEngineProvider);
        if (engine.soundEnabled) {
          SystemSound.play(SystemSoundType.alert);
        }
        if (engine.vibrationEnabled) {
          HapticFeedback.vibrate();
        }
      }
    });
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final themeId = ref.watch(clockEngineProvider).clockThemeId;
    final notch = defaultTargetPlatform == TargetPlatform.iOS
        ? MediaQuery.viewPaddingOf(context)
        : EdgeInsets.zero;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleChrome,
        child: Stack(
          children: [
            Opacity(
              opacity: snapshot.nightMode ? 0.35 : 1,
              child: ClockFace(
                themeId: themeId,
                snapshot: snapshot,
                landscape: landscape,
              ),
            ),
            if (_chromeVisible)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12 + notch.bottom),
                  child: Material(
                    key: const ValueKey('clock-chrome'),
                    color: const Color(0xE61C1C1E),
                    elevation: 16,
                    shadowColor: Colors.black,
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: _chromeButtons(snapshot),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _chromeButtons(ClockSnapshot snapshot) {
    final session = snapshot.session;
    if (session == null) {
      return [
        _ChromeButton(label: 'Theme', onPressed: _openClockTheme),
        _ChromeButton(label: 'Focus', onPressed: _openFocus),
        _ChromeButton(label: 'Timer', onPressed: _openTimer),
        _ChromeButton(label: 'More', onPressed: _openMore),
      ];
    }
    if (session.status == SessionStatus.complete) {
      return [
        _ChromeButton(
          label: 'Done',
          onPressed: () {
            ref.read(clockEngineProvider).acknowledgeComplete();
            ref.invalidate(clockSnapshotProvider);
            _showChrome();
          },
        ),
      ];
    }
    return [
      _ChromeButton(
        label: session.status == SessionStatus.paused ? 'Resume' : 'Pause',
        onPressed: () {
          final engine = ref.read(clockEngineProvider);
          if (session.status == SessionStatus.paused) {
            engine.resume();
          } else {
            engine.pause();
          }
          ref.invalidate(clockSnapshotProvider);
          _showChrome();
        },
      ),
      _ChromeButton(
        label: 'Stop',
        onPressed: () {
          ref.read(clockEngineProvider).stop();
          ref.read(sessionAlertsProvider).cancel();
          ref.invalidate(clockSnapshotProvider);
          _showChrome();
        },
      ),
    ];
  }
}

class _ChromeButton extends StatelessWidget {
  const _ChromeButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
