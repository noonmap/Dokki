import "package:dokki/constants/urls/book_api.dart";
import "package:http/http.dart" as http;

class BookRepository {
  Future<dynamic> fetchSearchBookListApi(
      String search, String queryType, int page, int size) async {
    dynamic response = await http
        .get(Uri.parse(BookApiUrl.getSearchUrl(search, queryType, page, size)));
    return response;
  }
}
