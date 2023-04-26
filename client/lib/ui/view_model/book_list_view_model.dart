import 'dart:convert';

import 'package:dokki/data/model/book_list_model.dart';
import 'package:dokki/data/model/pageable_model.dart';
import 'package:dokki/data/model/sort_model.dart';
import 'package:dokki/data/repository/book_repository.dart';
import 'package:flutter/material.dart';

class BookListViewModel with ChangeNotifier {
  final _bookRepo = BookRepository();
  static const baseUrl = "http://10.0.2.2:5010/books";

  bool isLoading = true;
  String error = "";
  BookListModel bookList = BookListModel(
      content: [],
      pageable: Pageable(
          sort: Sort(sorted: false, unsorted: true, empty: true),
          pageNumber: 0,
          pageSize: 0,
          offset: 0,
          paged: false,
          unpaged: false),
      numberOfElements: 0,
      sort: Sort(sorted: false, unsorted: true, empty: true),
      first: false,
      last: false,
      number: 0,
      size: 0,
      empty: false);

  Future<void> fetchSearchBookListApi(
      String search, String queryType, int page, int size) async {
    try {
      await Future.delayed(const Duration(seconds: 5));
      dynamic response =
          await _bookRepo.fetchSearchBookListApi(search, queryType, page, size);
      if (response.statusCode == 200) {
        bookList = bookListModelFromJson(utf8.decode(response.bodyBytes));
      } else {
        error = response.statusCode.toString();
      }
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
