import 'package:dio/dio.dart';
import 'package:dokki/data/model/review/review_model.dart';
import 'package:dokki/data/repository/review_repository.dart';
import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier {
  ReviewRepository _reviewRepository = ReviewRepository();
  List<Review> reviewList = [];
  String success = "";
  String error = "";
  // 리뷰 작성
  Future<Response<dynamic>> addComment(
      String bookId, Map<String, dynamic> data) async {
    try {
      Response<dynamic> response =
          await _reviewRepository.addComment(bookId, data);
      return response;
    } on DioError catch (error) {
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
}
