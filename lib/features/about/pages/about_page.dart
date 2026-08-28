import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/ui.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  static final _authorSite = Uri.parse('https://ducafecat.com');
  static final _tiqloSite = Uri.parse('https://tiqlo.link');
  static final _sourceCode = Uri.parse(
    'https://github.com/ducafecat/flutter_tiqlo_clock',
  );

  @override
  void initState() {
    super.initState();
    ClockSystemUi.show();
  }

  @override
  void dispose() {
    ClockSystemUi.hide();
    super.dispose();
  }

  Future<void> _openLink(Uri link) async {
    try {
      final launched = await launchUrl(
        link,
        mode: LaunchMode.externalApplication,
      );
      if (!mounted || launched) return;
    } on PlatformException {
      if (!mounted) return;
      _showLinkError('链接服务尚未加载，请完全重启应用后重试。');
      return;
    }
    _showLinkError('无法打开 ${link.host}');
  }

  void _showLinkError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final ui = AppUiTheme.of(context);
    return AppPageScaffold(
      title: 'About',
      onBack: () => AppRoutes.backToClock(context),
      portraitMaxWidth: 720,
      builder: (context, layout) => AppPageList(
        layout: layout,
        children: [
          _AppIdentityPanel(ui: ui),
          AppSection(
            title: 'Author',
            showDividers: false,
            children: [
              const AppInfoRow(label: 'Name', value: 'ducafecat'),
              AppLinkTile(
                label: 'Website',
                value: _authorSite.toString(),
                onPressed: () => _openLink(_authorSite),
              ),
            ],
          ),
          AppSection(
            title: 'Tiqlo',
            showDividers: false,
            children: [
              AppLinkTile(
                label: 'Official Website',
                value: _tiqloSite.toString(),
                onPressed: () => _openLink(_tiqloSite),
              ),
            ],
          ),
          AppSection(
            title: 'Open Source',
            showDividers: false,
            children: [
              AppLinkTile(
                label: 'Source Code',
                value: _sourceCode.toString(),
                onPressed: () => _openLink(_sourceCode),
              ),
            ],
          ),
          const AppSection(
            title: 'Flutter Packages',
            showDividers: false,
            children: [
              AppTextList(
                values: [
                  'flutter',
                  'cupertino_icons',
                  'image',
                  'path',
                  'flutter_riverpod',
                  'riverpod_annotation',
                  'go_router',
                  'freezed_annotation',
                  'json_annotation',
                  'shared_preferences',
                  'logger',
                  'intl',
                  'flutter_local_notifications',
                  'timezone',
                  'wakelock_plus',
                  'screen_brightness',
                  'flutter_fullscreen',
                  'flutter_native_splash',
                  'url_launcher',
                ],
              ),
            ],
          ),
          const AppSection(
            title: 'Fonts',
            showDividers: false,
            children: [
              AppTextList(
                values: [
                  'DotGothic16 — Digital clock',
                  'DSEG7 Classic — Standard digital clock',
                  'Jersey 25 — Flip clock',
                  'Pixelify Sans — Interface',
                  'Roboto Condensed — Standard flip clock',
                  'Tiny5 — Clock HUD',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppIdentityPanel extends StatelessWidget {
  const _AppIdentityPanel({required this.ui});

  final AppUiTheme ui;

  @override
  Widget build(BuildContext context) => AppPanel(
    child: Column(
      children: [
        Text('Tiqlo', style: ui.heading(fontSize: 38)),
        SizedBox(height: ui.spacingSm + ui.spacingXs),
        Text(
          'Version ${AppConfig.version}',
          style: ui.body(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ui.spacingXs),
        Text(
          'Build ${AppConfig.buildNumber}',
          style: ui.body(fontSize: 16, color: ui.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
