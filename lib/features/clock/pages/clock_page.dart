import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../clock/clock_providers.dart';
import '../../../clock/clock_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../widgets/clock_face.dart';

class ClockPage extends ConsumerStatefulWidget {
  const ClockPage({super.key});

  @override
  ConsumerState<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends ConsumerState<ClockPage> {
  bool _chromeVisible = false;
  Timer? _hideChromeTimer;

  @override
  void initState() {
    super.initState();
    ClockSystemUi.hide();
  }

  @override
  void dispose() {
    _hideChromeTimer?.cancel();
    super.dispose();
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

  void _openMore() {
    _hideChromeTimer?.cancel();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _moreTile(sheetContext, 'Settings', AppRoutes.settings),
              _moreTile(sheetContext, 'About', AppRoutes.about),
            ],
          ),
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
            Padding(
              padding: notch,
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
                  padding: EdgeInsets.only(bottom: 48 + notch.bottom),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ChromeButton(label: 'Theme', onPressed: _openClockTheme),
                      _ChromeButton(label: 'Focus', onPressed: _showChrome),
                      _ChromeButton(label: 'Timer', onPressed: _showChrome),
                      _ChromeButton(label: 'More', onPressed: _openMore),
                    ],
                  ),
                ),
              ),
          ],
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
