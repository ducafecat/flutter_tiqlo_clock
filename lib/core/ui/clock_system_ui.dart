import 'package:flutter/services.dart';

abstract final class ClockSystemUi {
  static Future<void> hide() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  static Future<void> show() {
    return SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }
}
