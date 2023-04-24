// 외부 서버 통신과 관련된 리모트 데이터 소스
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dokki/screens/home_screen/model/book.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_mock_adapter/http_mock_adapter.dart';

class RemoteDataSource {
  // 현재는 알라딘 api로 데이터를 요청해서 model과 다른 데이터가 들어온다.
  // 백엔드가 구현이 완료 되면 백엔드 REST API로 요청할 예정이므로 문제 없을듯
  static const String baseUrl = "https://dokki.kr";
  // REST API에 데이터를 요청하는 메소드 생성 (ServiceApi) 단계라고 보면 될듯
  static Future<List<BookModel>> getBookList(String keyword) async {
    final dio = Dio();
    final dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;

    List<BookModel> bookInstances = [];
    // query parameter을 이용한 request 요청

    const path = "$baseUrl/books/search";

    dioAdapter.onGet(
      path,
      (server) {
        return server.reply(
          200,
          [
            {
              "bookId": "1",
              "bookTitle": "셰임 머신",
              "bookAuthor": "캐시 오닐",
              "bookCoverPath": "http://image.yes24.com/goods/118345781/XL",
              "bookPublishYear": "2023-04-03"
            }
          ],
          delay: const Duration(seconds: 1),
        );
      },
    );

    final params = {
      "ttbkey": "ttbtjrghks961722001",
      "SearchTarget": "Book",
      "Output": "JS",
      "MaxResults": "10",
      "start": "1",
      "Version": "20131101",
      "Query": keyword,
    };
    // final uri = Uri.https(baseUrl, path, params);
    // final response = await http.get(uri);
    final response = await dio.get(path);
    debugPrint(response.data);
    if (response.statusCode == 200) {
      final List<dynamic> books = jsonDecode(response.data);

      for (var book in books) {
        bookInstances.add(BookModel.fromJson(book));
      }
      return bookInstances;
    }
    throw Error();
  }
}
