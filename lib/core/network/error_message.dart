import 'package:dio/dio.dart';

import 'api_exception.dart';

/// UI 展示用：仅业务文案，不含 Dio / ApiException 等包装前缀。
String userFacingErrorMessage(Object? error, {String fallback = '操作失败，请稍后重试'}) {
  if (error == null) return fallback;
  if (error is ApiException) return error.message;
  if (error is DioException) {
    final inner = error.error;
    if (inner is ApiException) return inner.message;
    final data = error.response?.data;
    if (data is Map) {
      for (final key in ['message', 'msg', 'error']) {
        final v = data[key];
        if (v is String) {
          final t = v.trim();
          if (t.isNotEmpty) return t;
        }
      }
    }
    final m = error.message?.trim();
    if (m != null && m.isNotEmpty) return m;
    return fallback;
  }
  return error.toString();
}
