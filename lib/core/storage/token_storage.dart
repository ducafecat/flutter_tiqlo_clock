import 'package:shared_preferences/shared_preferences.dart';

/// 访问令牌在设备上的持久化封装。
///
/// [SharedPreferences] 是 Flutter 常用的键值对本地存储（异步写入、进程内缓存），
/// 适合存非敏感或已脱敏的会话信息；本类不负责加密，调用方需知悉风险。
/// **可扩展：** 若需更高安全级别，可替换为 `flutter_secure_storage` 等方案，接口可保持类似。
class TokenStorage {
  TokenStorage(this._prefs);

  /// 与业务无关的存储键前缀，避免与其它模块键名冲突。
  static const _kAccessToken = 'auth.access_token';
  static const _kRefreshToken = 'auth.refresh_token';
  static const _kExpiresAt = 'auth.expires_at';

  final SharedPreferences _prefs;

  /// 当前保存的访问令牌；未写入时为 `null`。
  String? get accessToken => _prefs.getString(_kAccessToken);

  /// 刷新令牌，用于在访问令牌过期后向服务端换取新令牌。
  String? get refreshToken => _prefs.getString(_kRefreshToken);

  /// 访问令牌过期的绝对时间戳（毫秒，与 [DateTime.now] 的 epoch 一致）。
  int? get expiresAt => _prefs.getInt(_kExpiresAt);

  /// 写入登录/刷新接口返回的令牌信息。
  ///
  /// 1. 持久化 `accessToken`、`refreshToken`。
  /// 2. 若传入 [expiresInSeconds]，则根据「当前时刻 + 有效秒数」计算过期时间戳并写入。
  ///
  /// [expiresInSeconds] 通常为服务端返回的「剩余有效时间」，相对当前时间累加更贴近实际。
  /// ⚠️ 设备系统时间被用户修改会导致本地计算的过期时刻不可靠；严谨场景可结合服务端时间或短期校验。
  Future<void> save({
    required String accessToken,
    required String refreshToken,
    int? expiresInSeconds,
  }) async {
    await _prefs.setString(_kAccessToken, accessToken);
    await _prefs.setString(_kRefreshToken, refreshToken);
    if (expiresInSeconds != null) {
      final expireTs =
          DateTime.now().millisecondsSinceEpoch + expiresInSeconds * 1000;
      await _prefs.setInt(_kExpiresAt, expireTs);
    }
  }

  /// 登出或令牌失效时清除本地三项数据，避免残留导致误用旧会话。
  Future<void> clear() async {
    await _prefs.remove(_kAccessToken);
    await _prefs.remove(_kRefreshToken);
    await _prefs.remove(_kExpiresAt);
  }

  /// 是否具备非空的访问令牌；路由守卫、拦截器可据此判断是否视为「已登录态」。
  ///
  /// ⚠️ 仅有令牌不代表一定有效（可能已服务端吊销）；网络层仍应以 401 等为准做刷新或清会话。
  bool get hasToken {
    final t = accessToken;
    return t != null && t.isNotEmpty;
  }
}
