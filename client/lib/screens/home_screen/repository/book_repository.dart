import 'package:dokki/datasources/remote.dart';
import 'package:dokki/screens/home_screen/model/book.dart';

// 싱글톤 디자인 패턴 도입
class BookRepository {
  Future<List<BookModel>> getBookList(String keyword) {
    return RemoteDataSource.getBookList(keyword);
  }
}
