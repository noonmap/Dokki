import 'package:dio/dio.dart';
import 'package:dokki/common/constant/common.dart';
import 'package:dokki/data/model/book/book_detail_model.dart';
import 'package:dokki/data/model/book/book_model.dart';
import 'package:dokki/data/repository/book_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class BookProvider extends ChangeNotifier {
  final BookRepository _bookRepository = BookRepository();
  List<Book> _bookList = [];
  List<Book> get bookList => _bookList;
  Map<String, dynamic> pageData = {};
  BookDetailModel? book;
  String error = "";
  String success = "";
  bool isListLoading = false;
  bool isDetailLoading = false;
  bool isPostLoading = false;

  Future<void> getBookById(String bookId) async {
    isDetailLoading = true;
    notifyListeners();
    try {
      BookDetailModel returnData =
          await _bookRepository.getBookByIdData(bookId);
      book = returnData;
    } catch (e) {
      error = "error";
      rethrow;
    } finally {
      isDetailLoading = false;
      notifyListeners();
    }
  }

  Future<void> getBookListSearch(
      String search, String queryType, String page) async {
    isListLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> returnData =
          await _bookRepository.getSearchBookListData(search, queryType, page);

      List<Book> pageBookList = returnData["bookList"];
      pageData = returnData["pageData"];
      for (int i = 0; (i < int.parse(PAGE_LIMIT)); i++) {
        _bookList.add(pageBookList[i]);
      }
    } catch (e) {
      error = "error";
      rethrow;
    } finally {
      isListLoading = false;
      notifyListeners();
    }
  }

  // 찜 목록에 책 추가
  Future<void> addLikeBook(String bookId) async {
    isPostLoading = true;
    try {
      await _bookRepository.addLikeBookData(bookId);
      success = '북마크에 추가 했습니다.';
    } on DioError catch (e) {
      switch (e.response?.data["code"]) {
        case "C001":
          error = "이미 북마크된 책 입니다.";
          break;
        case "C003":
          error = "존재 하지 않는 책 ID 입니다.";
          break;
        case "U002":
          error = e.response?.data["message"];
          break;
        default:
          rethrow;
      }
    } finally {
      isPostLoading = false;
      notifyListeners();
    }
  }

  // 찜 목록에 책 삭제
  Future<void> deleteLikeBook(String bookId) async {
    isPostLoading = true;
    try {
      await _bookRepository.deleteLikeBookData(bookId);
      success = '북마크에 추가 했습니다.';
    } on DioError catch (e) {
      error = "북마크 삭제에 실패 했습니다.";
      rethrow;
    } finally {
      isPostLoading = false;
      notifyListeners();
    }
  }

  void initProvider() {
    success = "";
    error == "";
    _bookList = [];
    pageData = {};
    isListLoading = false;
    isPostLoading = false;
    isDetailLoading = false;
  }
}
