import "dart:convert";

import "package:dokki/constants/common.dart";
import "package:dokki/data/model/book_model.dart";
import "package:dokki/utils/services/api_service.dart";
import "package:http/http.dart" as http;

class BookRepository {
  final APIService _apiService = APIService();

  Future<Map<String, dynamic>> getSearchBookList(
      String search, String queryType, String page) async {
    Map<String, String> params = {
      "search": search,
      "queryType": queryType,
      "page": page,
      "size": PAGE_LIMIT,
    };
    http.Response response = await _apiService.get("/books/search", params);
    dynamic responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    final booksData = responseJson["content"] as List;
    List<Book> bookList = booksData.map((json) => Book.fromJson(json)).toList();
    final first = responseJson["first"];
    final last = responseJson["last"];
    final empty = responseJson["empty"];
    final numberOfElements = responseJson["numberOfElements"];
    Map<String, dynamic> pagesData = {
      "numberOfElements": numberOfElements,
      "empty": empty,
      "first": first,
      "last": last,
    };
    Map<String, dynamic> returnData = {
      "bookList": bookList,
      "pageData": pagesData,
    };
    return returnData;
  }
}
