import "package:dio/dio.dart";
import "package:dokki/utils/services/auth_dio.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:http/http.dart" as http;

class APIService {
  late Dio api;
  late FlutterSecureStorage storage;
  APIService() {
    AuthDio authDio = AuthDio();
    api = authDio.dio;
    storage = const FlutterSecureStorage();
  }
  Future<dynamic> get(String url, Map<String, dynamic>? params) async {
    api.options.headers['Authorization'] =
        'Bearer ${await storage.read(key: "ACCESS_TOKEN")}';
    try {
      if (params == null) {
        final response = await api.get(url);
        return response.data;
      } else {
        final response = await api.get(url, queryParameters: params);
        return response.data;
      }
    } catch (e) {
      return e;
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> data) async {
    api.options.headers['Authorization'] =
        'Bearer ${await storage.read(key: "ACCESS_TOKEN")}';
    try {
      final response = await api.post(url, data: data);
      return response.data;
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }

  Future<dynamic> put(String url, Map<String, dynamic> data) async {
    api.options.headers['Authorization'] =
        'Bearer ${await storage.read(key: "ACCESS_TOKEN")}';
    try {
      final response = await api.put(url, data: data);
      return response.data;
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }

  Future<dynamic> delete(String url) async {
    api.options.headers['Authorization'] =
        'Bearer ${await storage.read(key: "ACCESS_TOKEN")}';
    try {
      final response = await api.delete(url);
      return response.data;
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }
}
