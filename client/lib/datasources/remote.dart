// 외부 서버 통신과 관련된 리모트 데이터 소스
import 'dart:convert';

import 'package:dokki/screens/home_screen/model/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class RemoteDataSource {
  // 현재는 알라딘 api로 데이터를 요청해서 model과 다른 데이터가 들어온다.
  // 백엔드가 구현이 완료 되면 백엔드 REST API로 요청할 예정이므로 문제 없을듯
  static const String baseUrl = "aladin.co.kr";
  // REST API에 데이터를 요청하는 메소드 생성 (ServiceApi) 단계라고 보면 될듯
  static Future<List<BookModel>> getBookList(String keyword) async {
    List<BookModel> bookInstances = [];
    // query parameter을 이용한 request 요청
    const path = "/ttb/api/ItemSearch.aspx";
    debugPrint(keyword);
    final params = {
      "ttbkey": "ttbtjrghks961722001",
      "SearchTarget": "Book",
      "Output": "JS",
      "MaxResults": "10",
      "start": "1",
      "Version": "20131101",
      "Query": keyword,
    };
    final uri = Uri.https(baseUrl, path, params);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> books = jsonDecode(response.body);

      for (var book in books) {
        bookInstances.add(BookModel.fromJson(book));
        debugPrint(book);
      }
      return bookInstances;
    }
    throw Error();
  }
}
