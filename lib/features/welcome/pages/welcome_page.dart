import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/app_images.dart';
import '../../../core/providers/app_launch_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/ui/clock_system_ui.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  static const _slides = [
    _WelcomeSlide(
      image: AppImages.welcome1Png,
      title: '翻页时钟，重新想象',
      description: '极简、专注、优雅。让每一次翻页，\n都成为时间流动的仪式。',
    ),
    _WelcomeSlide(
      image: AppImages.welcome2Png,
      title: '一眼，看清时间',
      description: '醒目的大数字，没有多余干扰。\n轻轻抬眼，时间清晰可见。',
    ),
    _WelcomeSlide(
      image: AppImages.welcome3Png,
      title: '少些打扰，多些专注',
      description: '适合书桌、床头与专注时刻。\n让 Tiqlo 陪你沉浸当下。',
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
    _pageController.nextPage(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x00000000),
                    Color(0xE6000000),
                    Colors.black,
                  ],
                  stops: [0, 0.5, 0.76, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(24, 12, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isFinishing ? null : _finish,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                      backgroundColor: const Color(0x33000000),
                    ),
                    child: const Text('跳过'),
                  ),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  child: Column(
                    key: ValueKey(_currentPage),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _slides[_currentPage].title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.18,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _slides[_currentPage].description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    for (var index = 0; index < _slides.length; index++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        width: index == _currentPage ? 24 : 7,
                        height: 7,
                        margin: const EdgeInsets.only(right: 7),
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? const Color(0xFFE8B66B)
                              : Colors.white30,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: _isFinishing ? null : _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFE8B66B),
                        foregroundColor: Colors.black,
                        minimumSize: const Size(132, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(_isLastPage ? '开始使用' : '下一步'),
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
