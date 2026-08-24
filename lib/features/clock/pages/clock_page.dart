import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/digital_theme.dart';
import '../../../clock/flip_palette.dart';
import '../../../clock/clock_providers.dart';
import '../../../clock/clock_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_full_screen.dart';
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
  bool _isFullScreen = ClockFullScreen.isFullScreen.value;
  Timer? _hideChromeTimer;

  @override
  void initState() {
    super.initState();
    ClockSystemUi.hide();
    WidgetsBinding.instance.addObserver(this);
    if (ClockFullScreen.isSupported) {
      ClockFullScreen.isFullScreen.addListener(_onFullScreenChanged);
    }
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
    if (ClockFullScreen.isSupported) {
      ClockFullScreen.isFullScreen.removeListener(_onFullScreenChanged);
    }
    _hideChromeTimer?.cancel();
    super.dispose();
  }

  void _onFullScreenChanged() {
    if (mounted) {
      setState(() => _isFullScreen = ClockFullScreen.isFullScreen.value);
    }
  }

  void _toggleFullScreen() {
    ClockFullScreen.toggle();
    _showChrome();
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
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFF1C1C1E),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final engine = ref.read(clockEngineProvider);
            final currentStyle = engine.clockThemeId;
            final currentFlipPalette = engine.flipPaletteId;
            final currentDigitalTheme = engine.digitalThemeId;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _ThemeSectionTitle('Clock Style'),
                    for (final id in ClockThemeId.values)
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        title: Text(
                          id.label,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: currentStyle == id
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                        selected: currentStyle == id,
                        selectedColor: Colors.white,
                        selectedTileColor: Colors.white.withValues(alpha: 0.08),
                        onTap: () async {
                          await engine.setClockTheme(id);
                          if (!mounted || !sheetContext.mounted) return;
                          ref.invalidate(clockSnapshotProvider);
                          setState(() {});
                          setSheetState(() {});
                        },
                      ),
                    if (currentStyle == ClockThemeId.flip) ...[
                      const SizedBox(height: 12),
                      const _ThemeSectionTitle('Color Theme'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final id in FlipPaletteId.values)
                            ChoiceChip(
                              key: ValueKey('palette-${id.name}'),
                              avatar: CircleAvatar(
                                backgroundColor: id.palette.cardTop,
                                foregroundColor: id.palette.digit,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: id.palette.digit,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              label: Text(id.label),
                              selected: currentFlipPalette == id,
                              selectedColor: Colors.white.withValues(
                                alpha: 0.16,
                              ),
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.06,
                              ),
                              side: BorderSide(
                                color: currentFlipPalette == id
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : Colors.white.withValues(alpha: 0.12),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                              checkmarkColor: Colors.white,
                              onSelected: (_) async {
                                await engine.setFlipPalette(id);
                                if (!mounted || !sheetContext.mounted) return;
                                ref.invalidate(clockSnapshotProvider);
                                setState(() {});
                                setSheetState(() {});
                              },
                            ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 12),
                      const _ThemeSectionTitle('Color Theme'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final id in DigitalThemeId.values)
                            ChoiceChip(
                              key: ValueKey('digital-theme-${id.name}'),
                              avatar: CircleAvatar(
                                backgroundColor: id.theme.background,
                                foregroundColor: id.theme.digit,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: id.theme.digit,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              label: Text(id.label),
                              selected: currentDigitalTheme == id,
                              selectedColor: Colors.white.withValues(
                                alpha: 0.16,
                              ),
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.06,
                              ),
                              side: BorderSide(
                                color: currentDigitalTheme == id
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : Colors.white.withValues(alpha: 0.12),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                              checkmarkColor: Colors.white,
                              onSelected: (_) async {
                                await engine.setDigitalTheme(id);
                                if (!mounted || !sheetContext.mounted) return;
                                ref.invalidate(clockSnapshotProvider);
                                setState(() {});
                                setSheetState(() {});
                              },
                            ),
                        ],
                      ),
                    ],
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
                    onChanged: (value) async {
                      await engine.setNightMode(value);
                      if (!mounted || !sheetContext.mounted) return;
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
    final engine = ref.watch(clockEngineProvider);
    final themeId = engine.clockThemeId;
    final digitalTheme = engine.digitalThemeId.theme;
    final flipPalette = engine.flipPaletteId.palette;
    final backgroundColor = themeId == ClockThemeId.flip
        ? flipPalette.background
        : digitalTheme.background;
    final notch = defaultTargetPlatform == TargetPlatform.iOS
        ? MediaQuery.viewPaddingOf(context)
        : EdgeInsets.zero;

    return Scaffold(
      key: const ValueKey('clock-scaffold'),
      backgroundColor: backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleChrome,
        child: Stack(
          children: [
            Opacity(
              opacity: snapshot.nightMode ? 0.35 : 1,
              child: ClockFace(
                themeId: themeId,
                digitalTheme: digitalTheme,
                flipPalette: flipPalette,
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
    final fullScreenButton = ClockFullScreen.isSupported
        ? _ChromeButton(
            label: _isFullScreen ? 'Exit Fullscreen' : 'Fullscreen',
            onPressed: _toggleFullScreen,
          )
        : null;
    if (session == null) {
      return [
        _ChromeButton(label: 'Theme', onPressed: _openClockTheme),
        _ChromeButton(label: 'More', onPressed: _openMore),
        ?fullScreenButton,
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
        ?fullScreenButton,
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
      ?fullScreenButton,
    ];
  }
}

class _ThemeSectionTitle extends StatelessWidget {
  const _ThemeSectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
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
