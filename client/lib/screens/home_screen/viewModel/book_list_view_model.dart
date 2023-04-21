import 'package:dokki/screens/home_screen/model/book.dart';
import 'package:dokki/screens/home_screen/repository/book_repository.dart';
import 'package:flutter/material.dart';

class BookListViewModel with ChangeNotifier {
  late final BookRepository _bookRepository;

  List<BookModel> get items => _items;
  List<BookModel> _items = [];

  BookListViewModel() {
    _bookRepository = BookRepository();
    _loadItems("프로그래");
  }

  Future<void> _loadItems(keyword) async {
    _items = await _bookRepository.getBookList(keyword);
  }
}
