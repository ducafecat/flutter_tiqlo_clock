import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// 请求/响应/错误日志拦截器，便于调试网络层。
class LoggingInterceptor extends Interceptor {
  /// [logger] 可注入自定义 Logger；默认 PrettyPrinter、无 emoji
  LoggingInterceptor({Logger? logger})
    : _logger =
          logger ??
          Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d(
      '→ ${options.method} ${options.uri}\n'
      'headers: ${options.headers}\n'
      'data: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d(
      '← ${response.statusCode} ${response.requestOptions.uri}\n'
      'data: ${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '✗ ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      'status: ${err.response?.statusCode}\n'
      'data: ${err.response?.data}\n'
      'message: ${err.message}',
    );
    handler.next(err);
  }
}
