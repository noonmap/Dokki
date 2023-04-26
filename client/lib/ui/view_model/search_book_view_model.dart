import 'package:dokki/api/response/api_response.dart';
import 'package:dokki/data/model/book_list_model.dart';
import 'package:dokki/data/repository/book_repository.dart';
import 'package:flutter/material.dart';

class SearchBookViewModel with ChangeNotifier {
  final _bookRepo = BookRepository();
  ApiResponse<BookListModel> bookList = ApiResponse.loading();

  setBookList(ApiResponse<BookListModel> response) {
    bookList = response;
    notifyListeners();
  }

  Future<void> fetchSearchBookListApi(
      String search, String queryType, int page, int size) async {
    setBookList(ApiResponse.loading());
    _bookRepo
        .fetchSearchBookListApi(search, queryType, page, size)
        .then((data) {
      setBookList(ApiResponse.complete(data));
    }).onError((error, stackTrace) {
      setBookList(ApiResponse.error(error.toString()));
    });
  }
}
