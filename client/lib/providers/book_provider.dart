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
  final List<Book> _likeBookList = [];
  List<Book> get likeBookList => _likeBookList;
  List<Book> get bookList => _bookList;
  Map<String, dynamic> pageData = {};
  BookDetailModel? book;
  String errorMessage = "";
  String successMessage = "";
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
      errorMessage = "errorMessage";
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
      errorMessage = "errorMessage";
      rethrow;
    } finally {
      isListLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLikeBookList(String page, String size) async {
    isListLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> returnData =
          await _bookRepository.getLikeBookListData(page, size);

      List<Book> pageBookList = returnData["likeBookList"];
      pageData = returnData["pageData"];
      for (int i = 0; i < pageBookList.length; i++) {
        _likeBookList.add(pageBookList[i]);
      }
    } catch (e) {
      errorMessage = "errorMessage";
      rethrow;
    } finally {
      isListLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLikeBook(String bookId) async {
    isPostLoading = true;
    notifyListeners();
    try {
      await _bookRepository.addLikeBookData(bookId);
      successMessage = '북마크에 추가 했습니다.';
    } on DioError catch (e) {
      switch (e.response?.data["code"]) {
        case "C001":
          errorMessage = "이미 북마크된 책 입니다.";
          break;
        case "C003":
          errorMessage = "존재 하지 않는 책 ID 입니다.";
          break;
        case "U002":
          errorMessage = e.response?.data["message"];
          break;
        default:
          rethrow;
      }
    } finally {
      isPostLoading = false;
      notifyListeners();
    }
  }

  void initProvider() {
    successMessage = "";
    errorMessage == "";
    _bookList = [];
    pageData = {};
    isListLoading = false;
    isPostLoading = false;
    isDetailLoading = false;
  }
}
