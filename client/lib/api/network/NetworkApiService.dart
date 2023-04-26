import 'dart:convert';
import 'dart:io';

import 'package:dokki/api/app_exceptions.dart';
import 'package:dokki/api/network/BaseApiServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .post(
            Uri.parse(url),
            body: data,
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPutApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .put(
            Uri.parse(url),
            body: data,
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getDeleteApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http
          .delete(
            Uri.parse(url),
            body: data,
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(utf8.decode(response.bodyBytes));
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnAuthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error accoured while communicating with server' +
                'with status code' +
                response.statusCode.toString());
    }
  }
}
