import "package:dokki/constants/common.dart";
import 'package:dokki/data/model/book/book_detail_model.dart';
import "package:dokki/data/model/book/book_model.dart";
import "package:dokki/utils/services/api_service.dart";

class BookRepository {
  final APIService _apiService = APIService();
  // GET : 키워드에 맞는 책 리스트 데이터
  Future<Map<String, dynamic>> getSearchBookListData(
      String search, String queryType, String page) async {
    Map<String, String> params = {
      "search": search,
      "queryType": queryType,
      "page": page,
      "size": PAGE_LIMIT,
    };
    dynamic response = await _apiService.get("/books/search", params);
    final booksData = response["content"] as List;
    List<Book> bookList = booksData.map((json) => Book.fromJson(json)).toList();

    final first = response["first"];
    final last = response["last"];
    final empty = response["empty"];
    final numberOfElements = response["numberOfElements"];
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

  // GET : 책 상세 데이터
  Future<BookDetailModel> getBookByIdData(String bookId) async {
    dynamic response = await _apiService.get("/books/$bookId", null);
    if (response["bookCoverPath"] == null) {
      response["bookCoverPath"] = "";
    }
    if (response["bookCoverBackImagePath"] == null) {
      response["bookCoverBackImagePath"] = "";
    }
    if (response["bookCoverSideImagePath"] == null) {
      response["bookCoverSideImagePath"] = "";
    }
    if (response["readerCount"] == null) {
      response["readerCount"] = 0;
    }
    if (response["meanScore"] == null) {
      response["meanScore"] = 0;
    }
    if (response["meanReadTime"] == null) {
      response["meanReadTime"] = 0;
    }
    if (response["review"] == null) {
      response["review"] = [];
    }
    BookDetailModel bookDetailData = BookDetailModel.fromJson(response);
    return bookDetailData;
  }

  // GET : 찜 목록 데이터
  Future<Map<String, dynamic>> getLikeBookListData(
      String page, String size) async {
    Map<String, String> params = {
      "page": page,
      "size": size,
    };
    dynamic response = await _apiService.get("/books/like", params);
    final booksData = response["content"] as List;
    List<Book> bookList = booksData.map((json) => Book.fromJson(json)).toList();

    final first = response["first"];
    final last = response["last"];
    final empty = response["empty"];
    final numberOfElements = response["numberOfElements"];
    Map<String, dynamic> pagesData = {
      "numberOfElements": numberOfElements,
      "empty": empty,
      "first": first,
      "last": last,
    };
    Map<String, dynamic> returnData = {
      "likeBookList": bookList,
      "pageData": pagesData,
    };
    return returnData;
  }

  // POST : 찜 목록 추가
  Future<dynamic> addLikeBookData(String bookId) async {
    try {
      dynamic response = await _apiService.post("/books/like/$bookId", {});

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
