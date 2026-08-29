import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/digital_theme.dart';
import '../../../clock/flip_palette.dart';
import '../../../clock/clock_providers.dart';
import '../../../clock/clock_theme.dart';
import '../../../core/providers/app_appearance_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_full_screen.dart';
import '../../../core/ui/ui.dart';
import '../services/clock_platform_coordinator.dart';
import '../widgets/clock_face.dart';
import '../widgets/clock_more_sheet.dart';
import '../widgets/clock_theme_sheet.dart';

class ClockPage extends ConsumerStatefulWidget {
  const ClockPage({super.key});

  @override
  ConsumerState<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends ConsumerState<ClockPage> {
  bool _chromeVisible = false;
  bool _isFullScreen = ClockFullScreen.isFullScreen.value;
  Timer? _hideChromeTimer;
  final _themeFocusNode = FocusNode(debugLabel: 'Theme trigger');
  final _moreFocusNode = FocusNode(debugLabel: 'More trigger');
  late final ClockPlatformCoordinator _platformCoordinator;

  @override
  void initState() {
    super.initState();
    _platformCoordinator = ClockPlatformCoordinator(
      readEngine: () => ref.read(clockEngineProvider),
      readAlerts: () => ref.read(sessionAlertsProvider),
      refreshSnapshot: () {
        if (mounted) ref.invalidate(clockSnapshotProvider);
      },
    )..start();
    if (ClockFullScreen.isSupported) {
      ClockFullScreen.isFullScreen.addListener(_onFullScreenChanged);
    }
  }

  @override
  void dispose() {
    _platformCoordinator.dispose();
    if (ClockFullScreen.isSupported) {
      ClockFullScreen.isFullScreen.removeListener(_onFullScreenChanged);
    }
    _hideChromeTimer?.cancel();
    _themeFocusNode.dispose();
    _moreFocusNode.dispose();
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
    AppSheet.show<void>(
      context: context,
      restoreFocus: _themeFocusNode,
      layout: AppSheetLayout.theme,
      builder: (_) => const _ClockThemeSheetHost(),
    ).whenComplete(() {
      if (mounted) _showChrome();
    });
  }

  void _openMore() {
    _hideChromeTimer?.cancel();
    AppSheet.show<void>(
      context: context,
      restoreFocus: _moreFocusNode,
      builder: (sheetContext) => _ClockMoreSheetHost(
        onSettings: () => _openRouteFromSheet(sheetContext, AppRoutes.settings),
        onAbout: () => _openRouteFromSheet(sheetContext, AppRoutes.about),
      ),
    ).whenComplete(() {
      if (mounted) _showChrome();
    });
  }

  void _openRouteFromSheet(BuildContext sheetContext, String route) {
    Navigator.pop(sheetContext);
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final ui = AppUiTheme.of(context);
    final style = ref.watch(appUiStyleProvider);
    final snapshot = ref.watch(clockSnapshotProvider);
    ref.listen(clockSnapshotProvider, (previous, next) {
      _platformCoordinator.handleSnapshotChange(previous, next);
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
    final chromeActions = _chromeActions(snapshot);

    return Scaffold(
      key: const ValueKey('clock-scaffold'),
      backgroundColor: backgroundColor,
      body: SafeArea(
        left: !landscape,
        right: !landscape,
        child: Padding(
          key: const ValueKey('clock-safe-content'),
          padding: EdgeInsets.symmetric(
            horizontal: landscape ? ui.spacingSm + ui.spacingXs : 0,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggleChrome,
            child: Stack(
              children: [
                AnimatedOpacity(
                  key: const ValueKey('clock-night-dim'),
                  opacity: snapshot.nightMode ? 0.35 : 1,
                  duration: ui.motionDuration(
                    context,
                    const Duration(milliseconds: 240),
                  ),
                  child: ClockFace(
                    style: style,
                    themeId: themeId,
                    digitalThemeId: engine.digitalThemeId,
                    flipPaletteId: engine.flipPaletteId,
                    snapshot: snapshot,
                    landscape: landscape,
                  ),
                ),
                if (_chromeVisible)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: ui.spacingSm + ui.spacingXs,
                      ),
                      child: AppToolbar(
                        key: const ValueKey('clock-chrome'),
                        actions: chromeActions,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<AppToolbarAction> _chromeActions(ClockSnapshot snapshot) {
    final session = snapshot.session;
    final fullScreenButton = ClockFullScreen.isSupported
        ? AppToolbarAction(
            label: _isFullScreen ? 'Exit Fullscreen' : 'Fullscreen',
            onPressed: _toggleFullScreen,
          )
        : null;
    if (session == null) {
      return [
        AppToolbarAction(
          label: 'Theme',
          focusNode: _themeFocusNode,
          onPressed: _openClockTheme,
        ),
        AppToolbarAction(
          label: 'More',
          focusNode: _moreFocusNode,
          onPressed: _openMore,
        ),
        ?fullScreenButton,
      ];
    }
    if (session.status == SessionStatus.complete) {
      return [
        AppToolbarAction(
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
      AppToolbarAction(
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
      AppToolbarAction(
        label: 'Stop',
        tone: AppButtonTone.danger,
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

class _ClockThemeSheetHost extends ConsumerStatefulWidget {
  const _ClockThemeSheetHost();

  @override
  ConsumerState<_ClockThemeSheetHost> createState() =>
      _ClockThemeSheetHostState();
}

class _ClockThemeSheetHostState extends ConsumerState<_ClockThemeSheetHost> {
  Future<void> _update(Future<void> Function(ClockEngine engine) update) async {
    await update(ref.read(clockEngineProvider));
    if (!mounted) return;
    ref.invalidate(clockSnapshotProvider);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final engine = ref.read(clockEngineProvider);
    return ClockThemeSheet(
      clockThemeId: engine.clockThemeId,
      flipPaletteId: engine.flipPaletteId,
      digitalThemeId: engine.digitalThemeId,
      onClockThemeSelected: (id) =>
          _update((engine) => engine.setClockTheme(id)),
      onFlipPaletteSelected: (id) =>
          _update((engine) => engine.setFlipPalette(id)),
      onDigitalThemeSelected: (id) =>
          _update((engine) => engine.setDigitalTheme(id)),
    );
  }
}

class _ClockMoreSheetHost extends ConsumerStatefulWidget {
  const _ClockMoreSheetHost({required this.onSettings, required this.onAbout});

  final VoidCallback onSettings;
  final VoidCallback onAbout;

  @override
  ConsumerState<_ClockMoreSheetHost> createState() =>
      _ClockMoreSheetHostState();
}

class _ClockMoreSheetHostState extends ConsumerState<_ClockMoreSheetHost> {
  Future<void> _setPixelUiEnabled(bool value) async {
    try {
      await ref.read(appUiStyleProvider.notifier).setPixelUiEnabled(value);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to update Pixel UI.')),
      );
    }
  }

  Future<void> _setNightMode(bool value) async {
    await ref.read(clockEngineProvider).setNightMode(value);
    if (!mounted) return;
    ref.invalidate(clockSnapshotProvider);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final engine = ref.read(clockEngineProvider);
    final style = ref.watch(appUiStyleProvider);
    return ClockMoreSheet(
      pixelUiEnabled: style == AppUiStyle.pixel,
      onPixelUiChanged: _setPixelUiEnabled,
      nightMode: engine.nightMode,
      onNightModeChanged: _setNightMode,
      onSettings: widget.onSettings,
      onAbout: widget.onAbout,
    );
  }
}
