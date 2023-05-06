import "package:dio/dio.dart";
import "package:dokki/utils/services/auth_dio.dart";
import "package:http/http.dart" as http;

class APIService {
  Dio api = AuthDio().dio;
  Future<dynamic> get(String url, Map<String, dynamic>? params) async {
    try {
      if (params == null) {
        final response = await api.get(url);
        if (response.statusCode == 200) {
          return response.data;
        } else {
          return http.Response({"message": response.statusMessage}.toString(),
              response.statusCode as int);
        }
      } else {
        final response = await api.get(url, queryParameters: params);
        if (response.statusCode == 200) {
          return response.data;
        } else {
          return http.Response({"message": response.statusMessage}.toString(),
              response.statusCode as int);
        }
      }
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> data) async {
    try {
      final response = await api.post(url, data: data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return http.Response({"message": response.statusMessage}.toString(),
            response.statusCode as int);
      }
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }

  Future<dynamic> put(String url, Map<String, dynamic> data) async {
    try {
      final response = await api.put(url, data: data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return http.Response({"message": response.statusMessage}.toString(),
            response.statusCode as int);
      }
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }

  Future<dynamic> delete(String url) async {
    try {
      final response = await api.delete(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return http.Response({"message": response.statusMessage}.toString(),
            response.statusCode as int);
      }
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }
}
