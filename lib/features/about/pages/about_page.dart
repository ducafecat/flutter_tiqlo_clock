import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/adaptive_page_frame.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/pixel/pixel_ui.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  layout.isLandscape ? 24 : 16,
                  0,
                  layout.isLandscape ? 24 : 16,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: layout.isLandscape
                      ? CrossAxisAlignment.stretch
                      : CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    PixelPanel(
                      child: Text(
                        'Version ${AppConfig.version}',
                        style: tokens.body(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(flex: 2),
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
