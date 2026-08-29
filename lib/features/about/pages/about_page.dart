import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  static const _packages = [
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
    'package_info_plus',
  ];

  static const _fonts = [
    'DotGothic16 — Digital clock',
    'DSEG7 Classic — Standard digital clock',
    'Jersey 25 — Flip clock',
    'Pixelify Sans — Interface',
    'Roboto Condensed — Standard flip clock',
    'Tiny5 — Clock HUD',
  ];

  var _version = '';
  var _buildNumber = '';

  @override
  void initState() {
    super.initState();
    ClockSystemUi.show();
    _loadPackageInfo();
  }

  @override
  void dispose() {
    ClockSystemUi.hide();
    super.dispose();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
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
          _AppIdentityPanel(
            ui: ui,
            versionLabel: _version.isEmpty
                ? ''
                : 'Version $_version ($_buildNumber)',
          ),
          AppSection(
            title: 'Links',
            children: [
              const AppInfoRow(label: 'Author', value: 'ducafecat'),
              AppLinkTile(
                label: 'Website',
                value: _authorSite.toString(),
                onPressed: () => _openLink(_authorSite),
              ),
              AppLinkTile(
                label: 'Official Website',
                value: _tiqloSite.toString(),
                onPressed: () => _openLink(_tiqloSite),
              ),
              AppLinkTile(
                label: 'Source Code',
                value: _sourceCode.toString(),
                onPressed: () => _openLink(_sourceCode),
              ),
            ],
          ),
          const AppSection(
            title: 'Credits',
            showDividers: false,
            children: [
              _CreditBlock(title: 'Packages', values: _packages),
              _CreditBlock(title: 'Fonts', values: _fonts),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppIdentityPanel extends StatelessWidget {
  const _AppIdentityPanel({required this.ui, required this.versionLabel});

  final AppUiTheme ui;
  final String versionLabel;

  @override
  Widget build(BuildContext context) => AppPanel(
    padding: EdgeInsets.symmetric(
      horizontal: ui.spacingMd,
      vertical: ui.spacingSm,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppConfig.appName, style: ui.heading(fontSize: 22)),
        if (versionLabel.isNotEmpty) ...[
          SizedBox(height: ui.spacingXs / 2),
          Text(
            versionLabel,
            style: ui.body(fontSize: 13, color: ui.textSecondary),
          ),
        ],
      ],
    ),
  );
}

class _CreditBlock extends StatelessWidget {
  const _CreditBlock({required this.title, required this.values});

  final String title;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final ui = AppUiTheme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ui.spacingMd,
        ui.spacingSm,
        ui.spacingMd,
        ui.spacingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: ui.body(fontSize: 11, color: ui.textSecondary),
          ),
          SizedBox(height: ui.spacingXs / 2),
          Text(
            values.join('\n'),
            style: ui.body(fontSize: 13, color: ui.textSecondary),
          ),
        ],
      ),
    );
  }
}
