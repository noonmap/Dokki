import 'dart:convert';

import 'package:dokki/data/model/library/library_book_model.dart';
import 'package:dokki/utils/services/api_service.dart';
import "package:http/http.dart" as http;

class LibraryRepository {
  final APIService _apiService = APIService();

  // GET : 서재 조회
  Future<Map<String, dynamic>> getLibraryBooksData({
    required int userId,
    required int page,
  }) async {
    const int dataSize = 12;
    Map<String, dynamic> params = {
      'userId': '$userId',
      'page': '$page',
      'size': '$dataSize',
    };

    http.Response res = await _apiService.get('/books/collections', params);

    if (res.statusCode == 200) {
      final dynamic allData = jsonDecode(utf8.decode(res.bodyBytes));

      final libraryBooksData = allData['content'] as List;
      List<LibraryBookModel> libraryBooks = libraryBooksData
          .map((book) => LibraryBookModel.fromJson(book))
          .toList();

      final first = allData['first'];
      final last = allData['last'];
      final numberOfElements = allData['numberOfElements'];
      final empty = allData['empty'];

      Map<String, dynamic> pageData = {
        'numberOfElements': numberOfElements,
        'empty': empty,
        'first': first,
        'last': last,
      };

      Map<String, dynamic> libraryData = {
        'libraryBooks': libraryBooks,
        'pageData': pageData,
      };

      return libraryData;
    }
    throw Error();
  }
}
