import 'dart:developer';

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> get(String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );
      return response;
    } on DioException catch (e) {
      log('Dio error: ${e.message}');
      log('Response data: ${e.response?.data}');
      rethrow;
    }
  }

  void _handleError(DioException e) {
    // log / handle errors globally
    print("Dio error: ${e.message}");
  }
}
