/// API 层统一异常基类。
///
/// 职责：
/// - 把 Dio 的低层错误转换成业务侧更容易理解的异常。
/// - 保留状态码与响应体，方便 UI 展示、日志上报或按错误码分支。
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => message;
}

/// 400：请求参数、格式或业务校验不通过。
class BadRequestException extends ApiException {
  const BadRequestException(super.message, {super.data})
    : super(statusCode: 400);
}

/// 401：登录态无效；通常由鉴权拦截器先尝试刷新 token。
class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message, {super.data})
    : super(statusCode: 401);
}

/// 403：已登录但没有权限访问目标资源。
class ForbiddenException extends ApiException {
  const ForbiddenException(super.message, {super.data})
    : super(statusCode: 403);
}

/// 404：资源不存在或接口路径不匹配。
class NotFoundException extends ApiException {
  const NotFoundException(super.message, {super.data}) : super(statusCode: 404);
}

/// 409：资源状态冲突，例如重复提交或版本冲突。
class ConflictException extends ApiException {
  const ConflictException(super.message, {super.data}) : super(statusCode: 409);
}

/// 5xx：服务端错误，statusCode 可能是 500、502、503 等。
class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode, super.data});
}

/// 网络不可达、超时、证书失败等客户端侧连接问题。
class NetworkException extends ApiException {
  const NetworkException(super.message);
}

/// 请求被主动取消，通常不需要按失败 toast 处理。
class CancelException extends ApiException {
  const CancelException(super.message);
}

/// 未能归类的兜底异常，避免错误信息丢失。
class UnknownException extends ApiException {
  const UnknownException(super.message, {super.statusCode, super.data});
}
