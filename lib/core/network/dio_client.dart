import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// 网络层入口：封装 [Dio] 的创建与拦截器装配。
///
/// **作用**：业务代码只拿一个配置好的 [Dio]，不必重复写超时、BaseURL、鉴权、日志、错误转换。
///
/// **数据流（概念）**：`Repository / Api` → 本类产出的 [Dio] → `AuthInterceptor`（加 token、必要时刷新）
/// → 可选 `LoggingInterceptor` → `ErrorInterceptor`（把 Dio 异常转成业务可读的异常类型）。
///
/// **可扩展点**：新增全局行为时通常加拦截器；换环境 BaseURL 走 [AppConfig.network] 或传入 [baseUrl]。
class DioClient {
  /// 创建一个已装配拦截器的 [Dio] 实例。
  ///
  /// **输入**
  /// - [baseUrl]：接口根地址；为 `null` 时使用 [AppConfig.network.baseUrl]（与运行环境配置一致）。
  /// - [tokenStorage]：读写 access / refresh token 的存储抽象；鉴权拦截器依赖它完成「带票请求 / 刷新」。
  /// - [onUnauthorized]：当刷新 token 失败或必须重新登录时的回调（常见：清会话、跳登录页）。
  /// - ⚠️ 具体何时触发由 [AuthInterceptor] 实现决定，调用方需保证线程安全（如在 Flutter 里用 `SchedulerBinding` 切回 UI 线程再导航）。
  /// - [enableLogging]：是否打印请求日志；为 `null` 时跟随 [AppConfig.network.enableLogging]（便于按环境开关）。
  ///
  /// **输出**
  /// - 配置好 [BaseOptions] 与拦截器链的 [Dio]，可直接 `dio.get/post` 等。
  ///
  /// **关键概念**
  /// - [BaseOptions]：Dio 的全局默认配置（超时、默认头、响应解析类型等）。
  /// - **拦截器链**：请求发出前 / 响应返回后按添加顺序执行；顺序会影响行为（例如先鉴权再记日志，错误最后统一处理）。
  static Dio create({
    String? baseUrl,
    required TokenStorage tokenStorage,
    void Function()? onUnauthorized,
    bool? enableLogging,
  }) {
    // 从集中配置读取超时、默认日志开关等，避免魔法数字散落在业务里。
    final cfg = AppConfig.network;
    // 「调用方覆盖 > 全局默认」：单测或临时指向 mock 时可传 baseUrl；日常用配置即可。
    final effectiveBaseUrl = baseUrl ?? cfg.baseUrl;
    final effectiveEnableLogging = enableLogging ?? cfg.enableLogging;

    // 主实例：承载业务请求与完整拦截器链。
    final dio = Dio(
      BaseOptions(
        baseUrl: effectiveBaseUrl,
        connectTimeout: cfg.connectTimeout,
        receiveTimeout: cfg.receiveTimeout,
        sendTimeout: cfg.sendTimeout,
        // 期望服务端返回 JSON，Dio 会尝试按 JSON 解析（具体解析还受泛型/转换器影响）。
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
        // Accept 声明客户端能处理的表示类型，常见于 REST API 协商。
        headers: {'Accept': 'application/json'},
      ),
    );

    // 刷新 token 专用客户端：与主 [dio] 分离，避免拦截器递归。
    // 步骤理解：
    // 1) 主 dio 发业务请求 → 401 → AuthInterceptor 用 refreshDio 调刷新接口；
    // 2) 若 refreshDio 也挂同一套拦截器，刷新请求可能再次进「刷新逻辑」→ 死循环或栈溢出。
    // ⚠️ 因此 refresh 客户端通常保持「最小配置」：同源 BaseURL + 超时，但不挂 AuthInterceptor。
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: effectiveBaseUrl,
        connectTimeout: cfg.connectTimeout,
        receiveTimeout: cfg.receiveTimeout,
        sendTimeout: cfg.sendTimeout,
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
      ),
    );

    // 拦截器顺序说明（自上而下 = 先添加的先接到请求/后接到响应，具体以 Dio 文档为准；此处与项目约定一致）：
    // 1) Auth：统一注入 Authorization、处理 401 与刷新；
    // 2) Logging：仅调试/排障，生产可按配置关闭；
    // 3) Error：把网络层错误映射为上层统一的异常类型，UI 只关心「用户可读文案 + 错误码」。
    dio.interceptors.addAll([
      AuthInterceptor(
        tokenStorage: tokenStorage,
        refreshDio: refreshDio,
        onUnauthorized: onUnauthorized,
      ),
      if (effectiveEnableLogging) LoggingInterceptor(),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}
