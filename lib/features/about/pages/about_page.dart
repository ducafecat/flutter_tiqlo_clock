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
    final tokens = PixelTokens.of(context);
    return PixelPageScaffold(
      title: 'About',
      onBack: () => AppRoutes.backToClock(context),
      portraitMaxWidth: 720,
      builder: (context, layout) => PixelPageList(
        layout: layout,
        children: [
          _AppIdentityPanel(tokens: tokens),
          PixelSection(
            title: 'Author',
            showDividers: false,
            children: [
              const PixelInfoRow(label: 'Name', value: 'ducafecat'),
              PixelLinkTile(
                label: 'Website',
                value: _authorSite.toString(),
                onPressed: () => _openLink(_authorSite),
              ),
            ],
          ),
          PixelSection(
            title: 'Tiqlo',
            showDividers: false,
            children: [
              PixelLinkTile(
                label: 'Official Website',
                value: _tiqloSite.toString(),
                onPressed: () => _openLink(_tiqloSite),
              ),
            ],
          ),
          PixelSection(
            title: 'Open Source',
            showDividers: false,
            children: [
              PixelLinkTile(
                label: 'Source Code',
                value: _sourceCode.toString(),
                onPressed: () => _openLink(_sourceCode),
              ),
            ],
          ),
          const PixelSection(
            title: 'Flutter Packages',
            showDividers: false,
            children: [
              PixelTextList(
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
          const PixelSection(
            title: 'Fonts',
            showDividers: false,
            children: [
              PixelTextList(
                values: [
                  'DotGothic16 — Digital clock',
                  'Jersey 25 — Flip clock',
                  'Pixelify Sans — Interface',
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
  const _AppIdentityPanel({required this.tokens});

  final PixelTokens tokens;

  @override
  Widget build(BuildContext context) => PixelPanel(
    child: Column(
      children: [
        Text('Tiqlo', style: tokens.heading(fontSize: 38)),
        SizedBox(height: tokens.spacingSm + tokens.spacingXs),
        Text(
          'Version ${AppConfig.version}',
          style: tokens.body(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: tokens.spacingXs),
        Text(
          'Build ${AppConfig.buildNumber}',
          style: tokens.body(fontSize: 16, color: tokens.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
