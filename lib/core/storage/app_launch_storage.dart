import 'package:shared_preferences/shared_preferences.dart';

/// 管理首次启动引导是否已经完成。
class AppLaunchStorage {
  AppLaunchStorage(this._preferences);

  static const _hasSeenWelcomeKey = 'app.has_seen_welcome';

  final SharedPreferences _preferences;

  bool get hasSeenWelcome => _preferences.getBool(_hasSeenWelcomeKey) ?? false;

  Future<void> markWelcomeSeen() async {
    await _preferences.setBool(_hasSeenWelcomeKey, true);
  }
}
