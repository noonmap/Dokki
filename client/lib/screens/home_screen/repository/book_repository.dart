import 'package:dokki/datasources/remote.dart';
import 'package:dokki/screens/home_screen/model/book.dart';

class BookRepository {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  Future<List<BookModel>> getSearchBookList(String search, int page, int size) {
    return _remoteDataSource.getSearchBookList(search, page, size);
  }
}
