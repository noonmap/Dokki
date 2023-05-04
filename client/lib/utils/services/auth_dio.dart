import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthApi {
  Dio api = Dio();
  final String baseUrl = dotenv.env['BASE_PROD_URL'] as String;
  final _storage = const FlutterSecureStorage();

  AuthApi() {
    api.interceptors.clear();

    api.options = BaseOptions(
        contentType: 'application/json',
        responseType: ResponseType.json,
        baseUrl: baseUrl);

    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final accessToken = await _storage.read(key: 'ACCESS_TOKEN');

      // 매 요청 마다 헤더에 AccessToken 포함
      options.headers['Authorization'] = 'Bearer $accessToken';
      return handler.next(options);
    }, onError: (DioError error, handler) async {
      if ((error.response?.statusCode == 401 &&
          error.response?.data["code"] == "U003")) {
        // Access Token 만료 됬을 때의 로직
        final accessToken = await _storage.read(key: 'ACCESS_TOKEN');
        final refreshToken = await _storage.read(key: 'REFRESH_TOKEN');

        Dio refreshDio = Dio();

        refreshDio.interceptors.clear();
        refreshDio.interceptors
            .add(InterceptorsWrapper(onError: (error, handler) async {
          // 다시 인증 오류가 발생했을 경우
        }));
      }
      return handler.next(error);
    }));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =
        Options(method: requestOptions.method, headers: requestOptions.headers);
    return api.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    final response = await api.get('/users/refresh',
        options: Options(headers: {
          "Refresh": refreshToken,
        }));

    if (response.statusCode == 401 && response.data['code'] == 'U008') {
      // refresh token 이 만료 된 경우
      _storage.deleteAll();
    }
  }
}
