import "package:dio/dio.dart";
import "package:dokki/common/constant/common.dart";
import "package:dokki/utils/services/auth_dio.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

class APIService {
  final Dio _dio = Dio();

  APIService() {
    _dio.interceptors.add(CustomInterceptor(storage: storage));
    _dio.options.baseUrl = dotenv.env['BASE_PROD_URL'] as String;
  }

  Future<dynamic> get(String url, Map<String, dynamic> params) async {
    try {
      final response = await _dio.get(url, queryParameters: params);
      return response.data;
    } on DioError catch (error) {
      throw DioError(
          requestOptions: error.requestOptions, response: error.response);
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(url, data: data);
      return response.data;
    } on DioError catch (error) {
      throw DioError(
          requestOptions: error.requestOptions, response: error.response);
    }
  }

  Future<dynamic> put(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(url, data: data);
      return response;
    } on DioError catch (error) {
      throw DioError(
          requestOptions: error.requestOptions, response: error.response);
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      final response = await _dio.delete(url);
      return response;
    } on DioError catch (error) {
      throw DioError(
          requestOptions: error.requestOptions, response: error.response);
    }
  }
}
