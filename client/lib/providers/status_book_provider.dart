import 'package:dio/dio.dart';
import 'package:dokki/data/model/book/book_model.dart';
import 'package:dokki/data/model/book/book_timer_model.dart';
import 'package:dokki/data/repository/book_repository.dart';
import 'package:dokki/data/repository/timer_repository.dart';
import 'package:flutter/material.dart';

class StatusBookProvider extends ChangeNotifier {
  final BookRepository _bookRepository = BookRepository();
  final TimerRepository _timerRepository = TimerRepository();

  List<Book> _likeBookList = [];
  List<Book> get likeBookList => _likeBookList;
  List<BookTimerModel> _readingBookList = [];
  List<BookTimerModel> get readingBookList => _readingBookList;
  int _todayReadTime = 0;
  int get todayReadTime => _todayReadTime;

  Map<String, dynamic> pageData = {};

  bool isPostLoading = false;
  bool isReadingLoading = false;
  bool isLikeLoading = false;
  String success = "";
  String error = "";

  // GET 찜 목록 리스트 가져오기
  Future<void> getLikeBookList(String page, String size) async {
    isLikeLoading = true;
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
      error = "error";
      rethrow;
    } finally {
      isLikeLoading = false;
      notifyListeners();
    }
  }

  Future<void> getReadingBookList(String page, String size) async {
    isReadingLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> returnData =
          await _bookRepository.getReadingBookList(page, size);

      List<BookTimerModel> pageBookList = returnData["readingBookList"];
      pageData = returnData["pageData"];
      for (int i = 0; i < pageBookList.length; i++) {
        _readingBookList.add(pageBookList[i]);
      }
    } catch (e) {
      error = "error";
      rethrow;
    } finally {
      isReadingLoading = false;
      notifyListeners();
    }
  }

  // GET 오늘 누적 독서 시간
  Future<void> getReadTimeToday(String userId) async {
    try {
      dynamic todayTime = await _timerRepository.getReadTimeToday(userId);
      _todayReadTime = todayTime as int;
    } on DioError catch (e) {
      print(e.response!.statusCode);
    }
  }

  // 찜 목록에 책 추가
  Future<void> addLikeBook(String bookId) async {
    isPostLoading = true;
    notifyListeners();
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

  // POST : 타이머에 책 추가
  Future<void> addReadingBook(Map<String, dynamic> data) async {
    isPostLoading = true;
    notifyListeners();
    try {
      await _bookRepository.addReadingBookData(data);
      // 성공 한 경우
      success = "타이머에 추가 했습니다.";
    } on DioError catch (e) {
      print(e.response!.statusCode);
      error = "타이머에 추가 하지 못했습니다.";
    } finally {
      isPostLoading = false;
      notifyListeners();
    }
  }

  void initProvider() {
    _likeBookList = [];
    _readingBookList = [];
    error = "";
    success = "";
  }
}
