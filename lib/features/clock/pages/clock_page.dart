import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../clock/clock_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_system_ui.dart';

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
    final timeSize = landscape ? 120.0 : 72.0;
    final dateSize = landscape ? 24.0 : 18.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _showChrome,
        child: Stack(
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        snapshot.timeLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: timeSize,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        snapshot.dateLabel,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: dateSize,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_chromeVisible)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ChromeButton(label: 'Theme', onPressed: _showChrome),
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
