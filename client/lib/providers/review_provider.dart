import 'package:dio/dio.dart';
import 'package:dokki/common/constant/common.dart';
import 'package:dokki/data/model/review/review_model.dart';
import 'package:dokki/data/repository/review_repository.dart';
import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier {
  ReviewRepository _reviewRepository = ReviewRepository();
  List<Review> _reviewList = [];
  List<Review> get reviewList => _reviewList;
  Map<String, dynamic> pageData = {};
  String success = "";
  String error = "";
  bool isListLoading = false;
  // 리뷰 리스트
  Future<void> getCommentListOfBook(String bookId, String page) async {
    isListLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> returnData =
          await _reviewRepository.getCommentListOfBookData(bookId, page);
      List<Review> pageReviewList = returnData["reviewList"];
      pageData = returnData["pageData"];
      for (int i = 0;
          (i <
              (pageReviewList.length < 10
                  ? pageReviewList.length
                  : int.parse(PAGE_LIMIT)));
          i++) {
        _reviewList.add(pageReviewList[i]);
      }
    } catch (e) {
      error = "error";
      rethrow;
    } finally {
      isListLoading = false;
      notifyListeners();
    }
  }

  // 리뷰 작성
  Future<Response<dynamic>> addComment(
      String bookId, Map<String, dynamic> data) async {
    try {
      Response<dynamic> response =
          await _reviewRepository.addComment(bookId, data);
      success = "리뷰가 작성되었습니다.";
      return response;
    } on DioError catch (e) {
      error = "리뷰 작성에 실패했습니다.";
      rethrow;
    }
  }

  // 리뷰 삭제
  Future<Response<dynamic>> deleteComment(int commentId) async {
    try {
      Response<dynamic> response =
          await _reviewRepository.deleteComment(commentId);
      success = "리뷰가 제거 되었습니다.";
      return response;
    } on DioError catch (e) {
      error = "리뷰 제거 에러";
      rethrow;
    }
  }

  void initProvider() {
    _reviewList = [];
    pageData = {};
    isListLoading = false;
    success = "";
    error = "";
  }
}
