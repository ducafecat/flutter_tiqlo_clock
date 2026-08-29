import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../clock/clock_engine.dart';
import '../../../clock/clock_providers.dart';
import '../../../clock/clock_settings_store.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/clock_wake.dart';
import '../../../core/ui/ui.dart';

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
    return AppPageScaffold(
      title: 'Settings',
      onBack: () => AppRoutes.backToClock(context),
      portraitMaxWidth: 426,
      builder: (context, layout) => _SettingsSections(
        landscape: layout.isLandscape,
        maxWidth: layout.contentWidth,
        sections: _buildSections(engine),
      ),
    );
  }

  List<Widget> _buildSections(ClockEngine engine) => [
    AppSection(
      title: 'Time & Date',
      children: [
        _switch(
          label: '24 Hour',
          value: engine.is24Hour,
          onChanged: (value) =>
              engine.setTimeFormat(value ? TimeFormat.h24 : TimeFormat.h12),
          refreshSnapshot: true,
        ),
        _switch(
          label: 'Show Leading Zero',
          value: engine.showLeadingZero,
          onChanged: engine.setShowLeadingZero,
          refreshSnapshot: true,
        ),
        _switch(
          label: 'Show Seconds',
          value: engine.showSeconds,
          onChanged: engine.setShowSeconds,
          refreshSnapshot: true,
        ),
        _switch(
          label: 'Date & Weekday',
          value: engine.showDate,
          onChanged: engine.setShowDate,
          refreshSnapshot: true,
        ),
      ],
    ),
    AppSection(
      title: 'Display',
      children: [
        _switch(
          label: 'Keep Screen Awake',
          value: engine.keepAwake,
          onChanged: engine.setKeepAwake,
        ),
        _switch(
          label: 'Night Mode',
          value: engine.nightMode,
          onChanged: engine.setNightMode,
          refreshSnapshot: true,
        ),
      ],
    ),
    AppSection(
      title: 'Alerts',
      children: [
        _switch(
          label: 'Sound',
          value: engine.soundEnabled,
          onChanged: engine.setSoundEnabled,
        ),
        _switch(
          label: 'Vibration',
          value: engine.vibrationEnabled,
          onChanged: engine.setVibrationEnabled,
        ),
      ],
    ),
  ];

  AppSwitch _switch({
    required String label,
    required bool value,
    required Future<void> Function(bool value) onChanged,
    bool refreshSnapshot = false,
  }) => AppSwitch(
    label: label,
    value: value,
    onChanged: (value) async {
      await onChanged(value);
      if (!mounted) return;
      if (refreshSnapshot) ref.invalidate(clockSnapshotProvider);
      setState(() {});
    },
  );
}

class _SettingsSections extends StatelessWidget {
  const _SettingsSections({
    required this.landscape,
    required this.maxWidth,
    required this.sections,
  });

  final bool landscape;
  final double maxWidth;
  final List<Widget> sections;

  static const _gap = StandardSpacing.lg;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = landscape
        ? StandardSpacing.lg
        : StandardSpacing.md;
    final availableWidth = maxWidth - horizontalPadding * 2;
    final scaleExtra = (MediaQuery.textScalerOf(context).scale(1) - 1)
        .clamp(0.0, 1.0)
        .toDouble();
    // 给最长标签和开关预留空间；放大字号时自动减少列数。
    final minTileWidth = 350 + scaleExtra * 180;
    final columns = landscape
        ? ((availableWidth + _gap) / (minTileWidth + _gap))
              .floor()
              .clamp(1, 3)
              .toInt()
        : 1;
    final tileWidth = (availableWidth - _gap * (columns - 1)) / columns;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        StandardSpacing.lg,
        horizontalPadding,
        StandardSpacing.xl,
      ),
      children: [
        if (landscape)
          Wrap(
            spacing: _gap,
            runSpacing: _gap,
            children: [
              for (final section in sections)
                SizedBox(width: tileWidth, child: section),
            ],
          )
        else
          for (var index = 0; index < sections.length; index++) ...[
            sections[index],
            if (index != sections.length - 1) const SizedBox(height: _gap),
          ],
      ],
    );
  }
}
