import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

abstract final class ClockWake {
  static Future<void> setEnabled(bool on) async {
    try {
      if (on) {
        await WakelockPlus.enable();
      } else {
        await WakelockPlus.disable();
      }
    } catch (_) {}
  }
}

abstract final class NightBrightness {
  static Future<void> setEnabled(bool on) async {
    try {
      if (on) {
        await ScreenBrightness.instance.setApplicationScreenBrightness(0.15);
      } else {
        await ScreenBrightness.instance.resetApplicationScreenBrightness();
      }
    } catch (_) {}
  }
}
