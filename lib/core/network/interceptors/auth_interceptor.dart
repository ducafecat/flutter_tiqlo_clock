import 'package:dio/dio.dart';

import '../../storage/token_storage.dart';

/// 【鉴权拦截器】
///
/// **作用**：在 HTTP 层统一处理「谁有权访问接口」：
/// - **发请求前**：给需要鉴权的接口自动加上 `Authorization: Bearer <accessToken>`。
/// - **收到 401**：用本地 `refreshToken` 换一对新 token，成功后**重放**刚才失败的请求。
///
/// **为什么用拦截器**：业务代码只关心业务 URL，不必每个接口手写 Header；
/// 刷新与重试集中在一处，避免重复代码。
///
/// **关键概念**：
/// - **Access Token**：短期凭证，放在请求头里证明身份。
/// - **Refresh Token**：长期凭证，只用于换新的 access（通常不随每次业务请求发送）。
/// - **401 Unauthorized**：服务端认为「未登录或 token 无效」，常见触发刷新流程。
class AuthInterceptor extends Interceptor {
  /// 构造依赖说明：
  /// - [tokenStorage]：读写本地持久化的 token（access / refresh）。
  /// - [refreshDio]：**单独**的 Dio 实例，只负责调用 `/api/auth/refresh`。
  ///   **为什么不用主 Dio**：主客户端往往也挂了本拦截器；用同一个实例刷新可能再次进入
  ///   `onError`，形成**递归/循环**，所以刷新必须用「干净」的客户端。
  /// - [onUnauthorized]：刷新失败或没有 refresh 时的回调（例如清空路由栈、跳转登录页）。
  AuthInterceptor({
    required this.tokenStorage,
    required this.refreshDio,
    this.onUnauthorized,
  });

  /// 本地 token 存储抽象，具体实现可能是 SharedPreferences、安全存储等。
  final TokenStorage tokenStorage;

  /// 仅用于刷新 token 的 Dio（baseUrl 等应与主客户端一致，保证路径正确）。
  final Dio refreshDio;

  /// 需要重新登录时的副作用（UI 层注册，网络层不直接依赖具体页面）。
  final void Function()? onUnauthorized;

  /// 白名单：这些路径**不**自动带 `Authorization`，也**不**在 401 时走刷新逻辑。
  ///
  /// 典型场景：登录、刷新接口本身若带上过期 access 或误触发刷新，会造成逻辑混乱。
  static const _whitelist = <String>['/api/auth/login', '/api/auth/refresh'];

  /// 并发控制标志：多个请求同时 401 时，只允许**一条**刷新链路在执行。
  ///
  /// **为什么需要**：否则可能并发打出多次 refresh，后写盘的 token 互相覆盖，或浪费配额。
  bool _refreshing = false;

  /// **时机**：请求即将发出前（`Interceptor.onRequest`）。
  ///
  /// **输入**：[options] 本次请求的完整配置（含 path、headers 等）；[handler] 用于继续或中断链。
  /// **输出**：无直接返回值；通过 `handler.next(options)` 把（可能已改过的）请求交给下一个拦截器。
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 白名单接口：既不拼 Bearer，也避免把登录请求当成「已登录业务请求」。
    if (!_isWhitelisted(options.path)) {
      final token = tokenStorage.accessToken;
      if (token != null && token.isNotEmpty) {
        // Bearer 是 OAuth/JWT 生态里常用的方案：服务端从 Header 解析 token 校验签名与过期时间。
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  /// **时机**：请求已发出且 Dio 判定为失败（网络错误、4xx/5xx 等）。
  ///
  /// **输入**：[err] 包装了原始异常与 `Response`（若有）；[handler] 可 `next`（继续抛错）或 `resolve`（把错误「改成成功」）。
  /// **输出**：无；通过 handler 结束本次拦截链路。
  ///
  /// **401 分支的核心流程（步骤式）**：
  /// 1. 过滤：非 401 / 白名单 / 正在刷新 → 不处理，原样交给后续逻辑。
  /// 2. 若没有 refresh：清空本地凭证，通知上层重新登录，原样传递401。
  /// 3. 加锁 `_refreshing = true`，调用刷新接口拿到新 token 并 `save`。
  /// 4. 用**新 access** 更新原请求的 Header，再 `fetch` 一次原请求；成功则 `handler.resolve`，对调用方等价于「第一次就成功了」。
  /// 5. 任一步失败：`clear` + `onUnauthorized` + `handler.next(err)`，让上层仍能看到原始失败。
  /// 6. `finally` 里释放锁，保证无论成功失败都能恢复并发刷新能力。
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final path = err.requestOptions.path;

    // 不满足「可刷新」的前置条件时，不要拦截：保持 Dio 默认错误语义。⚠️ `_refreshing == true` 时其它并发 401 会直接 `next`，不会排队等刷新完成；要「全链路自动重试」需额外队列/Completer 协调。
    if (status != 401 || _isWhitelisted(path) || _refreshing) {
      return handler.next(err);
    }

    final refreshToken = tokenStorage.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      await tokenStorage.clear();
      onUnauthorized?.call();
      return handler.next(err);
    }

    _refreshing = true;
    try {
      final resp = await refreshDio.post<Map<String, dynamic>>(
        '/api/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final data = resp.data;
      if (data == null) throw err;

      await tokenStorage.save(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
        expiresInSeconds: (data['expiresIn'] as num?)?.toInt(),
      );

      // 重放：复用原 RequestOptions（URL、method、body 等不变），只更新 Authorization。
      // `..` 级联：在拷贝/复用的 options 上就地改 headers，再作为 fetch 参数。
      final retried = await refreshDio.fetch<dynamic>(
        err.requestOptions
          ..headers['Authorization'] = 'Bearer ${tokenStorage.accessToken}',
      );
      return handler.resolve(retried);
    } catch (_) {
      await tokenStorage.clear();
      onUnauthorized?.call();
      return handler.next(err);
    } finally {
      _refreshing = false;
    }
  }

  /// **作用**：判断 [path] 是否命中白名单。
  ///
  /// **匹配方式**：`endsWith` 后缀——简单直观，但若 path 带查询串（如 `.../login?x=1`）可能匹配不到，
  /// 需要服务端/路由约定 path 形态。
  ///
  /// **输入**：[path] 一般为相对路径（是否含 query 取决于 Dio 配置）。
  /// **输出**：`true` 表示视为登录相关接口，跳过鉴权与刷新。
  ///
  /// ⚠️ **潜在问题**：重试使用的是 [refreshDio] 而非「主业务 Dio」，若主客户端还有其它拦截器
  /// （签名、埋点、统一 baseUrl 处理），重试请求**不会**再走那一套；复杂项目可考虑用主实例
  /// 的 clone 或仅复制必要配置后 fetch。
  bool _isWhitelisted(String path) {
    return _whitelist.any((p) => path.endsWith(p));
  }
}
