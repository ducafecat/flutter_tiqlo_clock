import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dio_provider.dart';

part 'api_providers.g.dart';

/// 轻量 API 门面。
///
/// 职责：
/// - 屏蔽 Dio 的直接使用，让 feature 层通过更稳定的 ApiClient 入口发请求。
/// - 先提供 get/post 两个最常用方法，后续可按项目需要补 put/delete/upload。
///
/// ⚠️ 注意：
/// 这里不做 JSON model 解析；具体响应类型建议放在 feature repository 或 api 文件里处理。
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  /// GET 请求。
  ///
  /// queryParameters 会被 Dio 拼到 URL 查询串中，适合列表筛选、分页 cursor 等场景。
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  /// POST 请求。
  ///
  /// data 通常传 JSON body；queryParameters 仍可用于少量 URL 参数。
  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }
}

/// ApiClient Provider。
///
/// feature 层可 `ref.watch(apiClientProvider)` 复用全局 Dio 配置。
@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient(ref.watch(dioProvider));
}
