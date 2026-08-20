/// 应用级静态配置入口。
///
/// 职责：
/// - 集中管理 App 名称、网络参数与 UI 设计稿尺寸。
/// - 通过 `String.fromEnvironment` / `bool.fromEnvironment` 支持编译期环境覆盖。
///
/// ⚠️ 注意：
/// 这里不读取运行时远程配置；如果需要动态切环境，应在更上层注入配置对象。
abstract final class AppConfig {
  /// 应用标题，供 MaterialApp、系统任务列表等位置复用。
  static const appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Riverpod App',
  );

  /// 网络默认配置。
  ///
  /// `BASE_URL` 和 `ENABLE_HTTP_LOG` 可通过 `--dart-define` 覆盖，便于 dev/staging/prod 共用模板。
  static const network = NetworkConfig(
    baseUrl: String.fromEnvironment(
      'BASE_URL',
      defaultValue: 'https://example.com',
    ),
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 30),
    sendTimeout: Duration(seconds: 30),
    enableLogging: bool.fromEnvironment('ENABLE_HTTP_LOG', defaultValue: true),
  );

  /// UI 适配基准尺寸，通常取设计稿宽高。
  static const ui = UiConfig(designWidth: 390, designHeight: 844);
}

/// 网络层基础参数。
///
/// DioClient 会读取这里的 baseUrl、超时与日志开关，避免网络配置散落在各个 API 调用里。
class NetworkConfig {
  const NetworkConfig({
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
    required this.enableLogging,
  });

  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final bool enableLogging;
}

/// UI 适配参数。
///
/// ScreenAdapt 会基于该尺寸计算缩放比例，使模板在常见手机和平板宽度下保持近似视觉节奏。
class UiConfig {
  const UiConfig({required this.designWidth, required this.designHeight});

  final double designWidth;
  final double designHeight;
}
