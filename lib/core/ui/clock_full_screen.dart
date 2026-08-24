import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';

/// 将平台全屏状态暴露为 Flutter 可监听值。
abstract final class ClockFullScreen {
  static final ValueNotifier<bool> isFullScreen = ValueNotifier(false);
  static final _ClockFullScreenListener _listener = _ClockFullScreenListener();
  static bool _initialized = false;

  static bool get isSupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  static Future<void> ensureInitialized() async {
    if (!isSupported || _initialized) return;
    await FullScreen.ensureInitialized();
    isFullScreen.value = FullScreen.isFullScreen;
    FullScreen.addListener(_listener);
    _initialized = true;
  }

  static void toggle() {
    if (!_initialized) return;
    FullScreen.setFullScreen(!isFullScreen.value);
  }
}

class _ClockFullScreenListener with FullScreenListener {
  @override
  void onFullScreenChanged(bool enabled, SystemUiMode? systemUiMode) {
    ClockFullScreen.isFullScreen.value = enabled;
  }
}
