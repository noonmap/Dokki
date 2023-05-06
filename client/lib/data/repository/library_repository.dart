import 'package:dokki/data/model/library/library_book_model.dart';
import 'package:dokki/utils/services/api_service.dart';

class LibraryRepository {
  final APIService _apiService = APIService();

  // GET : 서재 조회
  Future<Map<String, dynamic>> getLibraryBooksData({
    required int userId,
    required int page,
  }) async {
    const int dataSize = 12;
    Map<String, dynamic> params = {
      'userId': '$userId',
      'page': '$page',
      'size': '$dataSize',
    };

    dynamic response = await _apiService.get('/books/collections', params);

    final libraryBooksData = response['content'] as List;
    List<LibraryBookModel> libraryBooks = libraryBooksData
        .map((book) => LibraryBookModel.fromJson(book))
        .toList();

    final first = response['first'];
    final last = response['last'];
    final numberOfElements = response['numberOfElements'];
    final empty = response['empty'];

    Map<String, dynamic> pageData = {
      'numberOfElements': numberOfElements,
      'empty': empty,
      'first': first,
      'last': last,
    };

    Map<String, dynamic> libraryData = {
      'libraryBooks': libraryBooks,
      'pageData': pageData,
    };

    return libraryData;
  }
}
