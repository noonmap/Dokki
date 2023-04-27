import "dart:convert";

import "package:http/http.dart" as http;

class APIService {
  final String _baseUrl = "http://172.30.1.42:51070";
  final Map<String, String> _headers = {
    "content-type": "application/json",
    "accept": "application/json",
  };

  Future<http.Response> get(String url, Map<String, dynamic> params) async {
    try {
      print(url);
      print(params.toString());
      Uri uri = Uri.parse(_baseUrl + url).replace(queryParameters: params);
      http.Response response =
          await http.get(uri).timeout(Duration(seconds: 10));
      return response;
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    try {
      Uri uri = Uri.parse(_baseUrl + url);
      String bodyString = jsonEncode(body);
      http.Response response =
          await http.post(uri, headers: _headers, body: bodyString);
      return response;
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    try {
      Uri uri = Uri.parse(_baseUrl + url);
      String bodyString = jsonEncode(body);
      http.Response response =
          await http.put(uri, headers: _headers, body: bodyString);
      return response;
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }

  Future<http.Response> delete(String url) async {
    try {
      Uri uri = Uri.parse(_baseUrl + url);
      http.Response response = await http.delete(uri, headers: _headers);
      return response;
    } catch (e) {
      return http.Response({"message": e}.toString(), 400);
    }
  }
}
