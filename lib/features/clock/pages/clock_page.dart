import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/digital_theme.dart';
import '../../../clock/flip_palette.dart';
import '../../../clock/clock_providers.dart';
import '../../../clock/clock_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_full_screen.dart';
import '../../../core/ui/pixel/pixel_ui.dart';
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
    PixelSheet.show<void>(
      context: context,
      restoreFocus: _themeFocusNode,
      layout: PixelSheetLayout.theme,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final engine = ref.read(clockEngineProvider);
          bool sheetIsMounted() => mounted && sheetContext.mounted;
          return ClockThemeSheet(
            clockThemeId: engine.clockThemeId,
            flipPaletteId: engine.flipPaletteId,
            digitalThemeId: engine.digitalThemeId,
            onClockThemeSelected: (id) async {
              await engine.setClockTheme(id);
              _refreshThemeSheet(sheetIsMounted, setSheetState);
            },
            onFlipPaletteSelected: (id) async {
              await engine.setFlipPalette(id);
              _refreshThemeSheet(sheetIsMounted, setSheetState);
            },
            onDigitalThemeSelected: (id) async {
              await engine.setDigitalTheme(id);
              _refreshThemeSheet(sheetIsMounted, setSheetState);
            },
          );
        },
      ),
    ).whenComplete(() {
      if (mounted) _showChrome();
    });
  }

  void _refreshThemeSheet(
    bool Function() sheetIsMounted,
    StateSetter setSheetState,
  ) {
    if (!sheetIsMounted()) return;
    ref.invalidate(clockSnapshotProvider);
    setState(() {});
    setSheetState(() {});
  }

  void _openMore() {
    _hideChromeTimer?.cancel();
    PixelSheet.show<void>(
      context: context,
      restoreFocus: _moreFocusNode,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final engine = ref.read(clockEngineProvider);
          return ClockMoreSheet(
            nightMode: engine.nightMode,
            onNightModeChanged: (value) async {
              await engine.setNightMode(value);
              if (!mounted || !sheetContext.mounted) return;
              ref.invalidate(clockSnapshotProvider);
              setSheetState(() {});
              setState(() {});
            },
            onSettings: () =>
                _openRouteFromSheet(sheetContext, AppRoutes.settings),
            onAbout: () => _openRouteFromSheet(sheetContext, AppRoutes.about),
          );
        },
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
    final tokens = PixelTokens.of(context);
    final chromeInset = _chromeVisible
        ? _chromeReservedHeight(context, chromeActions.length, landscape)
        : 0.0;

    return Scaffold(
      key: const ValueKey('clock-scaffold'),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleChrome,
          child: Stack(
            children: [
              AnimatedPadding(
                key: const ValueKey('clock-face-inset'),
                duration: tokens.motionDuration(
                  context,
                  const Duration(milliseconds: 180),
                ),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(bottom: chromeInset),
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
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PixelToolbar(
                      key: const ValueKey('clock-chrome'),
                      actions: chromeActions,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _chromeReservedHeight(
    BuildContext context,
    int actionCount,
    bool landscape,
  ) {
    final tokens = PixelTokens.of(context);
    final portraitMenu = !landscape && MediaQuery.sizeOf(context).width < 600;
    if (!portraitMenu) return 12 + 48;
    return 12 + actionCount * 56 + (actionCount - 1) * tokens.spacingSm;
  }

  List<PixelToolbarAction> _chromeActions(ClockSnapshot snapshot) {
    final session = snapshot.session;
    final fullScreenButton = ClockFullScreen.isSupported
        ? PixelToolbarAction(
            label: _isFullScreen ? 'Exit Fullscreen' : 'Fullscreen',
            onPressed: _toggleFullScreen,
          )
        : null;
    if (session == null) {
      return [
        PixelToolbarAction(
          label: 'Theme',
          focusNode: _themeFocusNode,
          onPressed: _openClockTheme,
        ),
        PixelToolbarAction(
          label: 'More',
          focusNode: _moreFocusNode,
          onPressed: _openMore,
        ),
        ?fullScreenButton,
      ];
    }
    if (session.status == SessionStatus.complete) {
      return [
        PixelToolbarAction(
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
      PixelToolbarAction(
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
      PixelToolbarAction(
        label: 'Stop',
        tone: PixelButtonTone.danger,
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
