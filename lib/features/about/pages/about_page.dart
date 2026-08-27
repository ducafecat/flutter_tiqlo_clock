import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/adaptive_page_frame.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/pixel/pixel_pressable.dart';
import '../../../core/ui/pixel/pixel_ui.dart';

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
    return Scaffold(
      backgroundColor: tokens.chrome,
      body: AdaptivePageFrame(
        portraitMaxWidth: 720,
        builder: (context, layout) => Column(
          children: [
            PixelPageHeader(
              title: 'About',
              onBack: () => AppRoutes.backToClock(context),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  layout.isLandscape ? 24 : 16,
                  24,
                  layout.isLandscape ? 24 : 16,
                  32,
                ),
                children: [
                  _AppIdentityPanel(tokens: tokens),
                  const SizedBox(height: 24),
                  _AboutSection(
                    title: 'AUTHOR',
                    children: [
                      const _InfoRow(label: 'Name', value: 'ducafecat'),
                      _LinkRow(
                        label: 'Website',
                        link: _authorSite,
                        onPressed: () => _openLink(_authorSite),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _AboutSection(
                    title: 'TIQLO',
                    children: [
                      _LinkRow(
                        label: 'Official Website',
                        link: _tiqloSite,
                        onPressed: () => _openLink(_tiqloSite),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _AboutSection(
                    title: 'OPEN SOURCE',
                    children: [
                      _LinkRow(
                        label: 'Source Code',
                        link: _sourceCode,
                        onPressed: () => _openLink(_sourceCode),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _AboutSection(
                    title: 'FLUTTER PACKAGES',
                    children: [
                      _TextList(
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
                  const SizedBox(height: 24),
                  const _AboutSection(
                    title: 'FONTS',
                    children: [
                      _TextList(
                        values: [
                          'Doto — Digital clock',
                          'Jersey 25 — Flip clock',
                          'Pixelify Sans — Interface',
                          'Tiny5 — Clock HUD',
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
        const SizedBox(height: 12),
        Text(
          'Version ${AppConfig.version}',
          style: tokens.body(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Build ${AppConfig.buildNumber}',
          style: tokens.body(fontSize: 16, color: tokens.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            title,
            style: tokens
                .heading(fontSize: 19)
                .copyWith(color: tokens.section, letterSpacing: 1.52),
          ),
        ),
        const SizedBox(height: 9),
        PixelPanel(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          Text(
            label,
            style: tokens.body(fontSize: 16, color: tokens.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: tokens.body(fontSize: 17),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.label,
    required this.link,
    required this.onPressed,
  });

  final String label;
  final Uri link;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return PixelPressable(
      semanticLabel: '$label: $link',
      onPressed: onPressed,
      builder: (context, state) => DecoratedBox(
        decoration: BoxDecoration(
          color: state.pressed
              ? tokens.pressedOverlay
              : state.hovered
              ? tokens.hoverOverlay
              : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: tokens.body(fontSize: 16, color: tokens.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                link.toString(),
                style: tokens.body(fontSize: 16, color: tokens.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextList extends StatelessWidget {
  const _TextList({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < values.length; index++) ...[
            Text(
              values[index],
              style: tokens.body(fontSize: 16, color: tokens.textSecondary),
            ),
            if (index != values.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
