import 'package:dokki/api/network/BaseApiServices.dart';
import 'package:dokki/api/network/NetworkApiService.dart';
import 'package:dokki/constants/urls/book_api.dart';
import 'package:dokki/data/model/book_list_model.dart';

class BookRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<BookListModel> fetchSearchBookListApi(
      String search, String queryType, int page, int size) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(
          BookApiUrl.getSearchUrl(search, queryType, page, size));
      print(response);
      return response = BookListModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
