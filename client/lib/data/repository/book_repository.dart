import "package:dokki/common/constant/common.dart";
import 'package:dokki/data/model/book/book_detail_model.dart';
import "package:dokki/data/model/book/book_model.dart";
import "package:dokki/data/model/book/book_timer_model.dart";
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
    dynamic response = await _apiService.get("/books/$bookId", {});
    if (response["bookCoverPath"] == null) {
      response["bookCoverPath"] = "";
    }
    if (response["bookCoverBackImagePath"] == null) {
      response["bookCoverBackImagePath"] = "";
    }
    if (response["bookCoverSideImagePath"] == null) {
      response["bookCoverSideImagePath"] = "";
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

  // GET : 타이머 책 목록 리스트
  Future<Map<String, dynamic>> getReadingBookList(
      String page, String size) async {
    Map<String, String> params = {
      "page": page,
      "size": size,
    };
    try {
      dynamic response = await _apiService.get("/books/read-book", params);
      final booksData = response["content"] as List;
      List<BookTimerModel> bookList = booksData.map((json) {
        if (json["bookCoverBackImagePath"] == null) {
          json["bookCoverBackImagePath"] = "";
        }
        if (json["bookCoverSideImagePath"] == null) {
          json["bookCoverSideImagePath"] = "";
        }
        return BookTimerModel.fromJson(json);
      }).toList();

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
        "readingBookList": bookList,
        "pageData": pagesData,
      };
      return returnData;
    } catch (e) {
      rethrow;
    }
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

  // DELETE : /books/like/:bookId -> 찜 목록 삭제
  Future<void> deleteLikeBookData(String bookId) async {
    try {
      final response = await _apiService.delete("/books/like/$bookId");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST : 읽는 중인 책 추가
  Future<void> addReadingBookData(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiService.post("/books/status", data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST : /books/status/direct-complete -> 완독서에 바로 책 추가
  Future<void> addDirectCompleteBookData(Map<String, dynamic> data) async {
    try {
      dynamic response =
          await _apiService.post("/books/status/direct-complete", data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT : /books/status/{bookStatusId}/complete -> 진행중에서 완독서로 상태 변경
  Future<void> updateCompleteBookData(String bookStatusId) async {
    try {
      dynamic response =
          await _apiService.put("/books/status/$bookStatusId/complete", {});
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE : /books/status/{bookStatusId} -> 도서 상태 삭제
  Future<void> deleteBookStatusData(String bookStatusId) async {
    try {
      dynamic response =
          await _apiService.delete("/books/status/$bookStatusId");
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
