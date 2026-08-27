import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/app_images.dart';
import '../../../core/providers/app_launch_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_system_ui.dart';
import '../../../core/ui/ui.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  static const _slides = [
    _WelcomeSlide(
      image: AppImages.welcome1Png,
      title: 'Flip Clock, Reimagined',
      description:
          'Minimal. Focused. Beautiful.\nLet every flip mark the moment.',
    ),
    _WelcomeSlide(
      image: AppImages.welcome2Png,
      title: 'Time at a Glance',
      description: 'Bold digits. No distractions.\nOne glance is all it takes.',
    ),
    _WelcomeSlide(
      image: AppImages.welcome3Png,
      title: 'Less Noise, More Focus',
      description:
          'Made for your desk, bedside, and focus time.\nStay present with Tiqlo.',
    ),
  ];

  late final PageController _pageController;
  var _currentPage = 0;
  var _isFinishing = false;

  bool get _isLastPage => _currentPage == _slides.length - 1;

  @override
  void initState() {
    super.initState();
    ClockSystemUi.hide();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_isFinishing) return;
    setState(() => _isFinishing = true);
    await ref.read(appLaunchStorageProvider).markWelcomeSeen();
    if (mounted) context.go(AppRoutes.clock);
  }

  void _next() {
    if (_isLastPage) {
      _finish();
      return;
    }
    final tokens = PixelTokens.of(context);
    final duration = tokens.motionDuration(context, tokens.welcomePageDuration);
    if (duration == Duration.zero) {
      _pageController.jumpToPage(_currentPage + 1);
    } else {
      _pageController.nextPage(duration: duration, curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    final contentDuration = tokens.motionDuration(
      context,
      tokens.welcomeContentDuration,
    );
    return Scaffold(
      backgroundColor: tokens.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              return Image.asset(_slides[index].image, fit: BoxFit.cover);
            },
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    tokens.background.withValues(alpha: 0),
                    tokens.background.withValues(alpha: 0),
                    tokens.background.withValues(alpha: 0.9),
                    tokens.background,
                  ],
                  stops: [0, 0.5, 0.76, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            minimum: EdgeInsets.fromLTRB(
              tokens.spacingLg,
              tokens.spacingSm + tokens.spacingXs,
              tokens.spacingLg,
              tokens.spacingMd + tokens.spacingXs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: PixelTextButton(
                    onPressed: _isFinishing ? null : _finish,
                    label: 'SKIP',
                  ),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: contentDuration,
                  child: Column(
                    key: ValueKey(_currentPage),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _slides[_currentPage].title,
                        style: tokens.heading(fontSize: 30),
                      ),
                      SizedBox(height: tokens.spacingSm),
                      Text(
                        _slides[_currentPage].description,
                        style: tokens.body(color: tokens.textSecondary),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: tokens.spacingLg),
                Row(
                  children: [
                    PixelPageIndicator(
                      pageCount: _slides.length,
                      currentPage: _currentPage,
                    ),
                    const Spacer(),
                    PixelTextButton(
                      onPressed: _isFinishing ? null : _next,
                      label: _isLastPage ? 'GET STARTED' : 'NEXT',
                      prominent: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeSlide {
  const _WelcomeSlide({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;
}
