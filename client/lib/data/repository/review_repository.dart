import 'package:dio/dio.dart';
import 'package:dokki/common/constant/common.dart';
import 'package:dokki/data/model/review/review_model.dart';
import 'package:dokki/utils/services/api_service.dart';

class ReviewRepository {
  APIService _apiService = APIService();

  // GET : 도서 리뷰 목록 조회
  Future<Map<String, dynamic>> getCommentListOfBookData(
      String bookId, String page) async {
    Map<String, String> params = {
      "page": page,
      "size": PAGE_LIMIT,
    };
    dynamic response =
        await _apiService.get("/reviews/comment/$bookId", params);
    final reviewsData = response["content"] as List;
    List<Review> bookList =
        reviewsData.map((json) => Review.fromJson(json)).toList();

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
      "reviewList": bookList,
      "pageData": pagesData,
    };
    return returnData;
  }

  // POST : 도서 리뷰 추가
  Future<Response<dynamic>> addComment(
      String bookId, Map<String, dynamic> data) async {
    try {
      Response<dynamic> response =
          await _apiService.post("/reviews/comment/$bookId", data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT : 도서 리뷰 수정
  Future<Response<dynamic>> updateComment(
      String commentId, Map<String, dynamic> data) async {
    try {
      Response<dynamic> response =
          await _apiService.put("/reviews/comment/$commentId", data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE : 도서 리뷰 삭제
  Future<Response<dynamic>> deleteComment(int commentId) async {
    try {
      Response<dynamic> response =
          await _apiService.delete("/reviews/comment/$commentId");
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
