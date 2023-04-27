import 'package:dokki/data/model/book_model.dart';
import 'package:dokki/data/repository/book_repository.dart';
import 'package:flutter/foundation.dart';

class BookProvider extends ChangeNotifier {
  final BookRepository _bookRepository = BookRepository();
  List<Book> _bookList = [];
  List<Book> get bookList => _bookList;
  Map<String, dynamic> pageData = {};
  String error = "";
  bool isLoading = false;

  Future<void> getBookListSearch(
      String search, String queryType, String page) async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    try {
      Map<String, dynamic> returnData =
          await _bookRepository.getSearchBookList(search, queryType, page);

      List<Book> pageBookList = returnData["bookList"];
      pageData = returnData["pageData"];
      _bookList = pageBookList;
    } catch (e) {
      error = "error";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void initProvider() {
    _bookList = [];
    pageData = {};
    isLoading = false;
  }
}
