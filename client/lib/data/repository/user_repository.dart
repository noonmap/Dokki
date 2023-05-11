import 'package:dokki/data/model/book/book_model.dart';
import 'package:dokki/data/model/user/user_bio_model.dart';
import 'package:dokki/data/model/user/user_monthly_calendar_model.dart';
import 'package:dokki/data/model/user/user_monthly_count_model.dart';
import 'package:dokki/data/model/user/user_simple_model.dart';
import 'package:dokki/utils/services/api_service.dart';

class UserRepository {
  final APIService _apiService = APIService();

  // GET : 유저 상세 조회
  Future<UserBioModel> getUserBioDataById(int userId) async {
    try {
      dynamic response = await _apiService.get('/users/profile/$userId', {});
      UserBioModel userData = UserBioModel.fromJson(response);
      return userData;
    } catch (e) {
      rethrow;
    }
  }

  // GET : 팔로잉/팔로워 목록 조회
  Future<List<UserSimpleModel>> getFollowListData(
      {required userId, required category, required page}) async {
    int dataSize = 50;
    Map<String, String> params = {'page': '$page', 'size': '$dataSize'};
    try {
      dynamic response =
          await _apiService.get('/users/$category/$userId', params) as List;
      List<UserSimpleModel> followListData =
          response.map((data) => UserSimpleModel.fromJson(data)).toList();

      return followListData;
    } catch (e) {
      rethrow;
    }
  }

  // GET : 독서 달력
  Future<List<UserMonthlyCalendarModel>> getUserMonthlyCalendarData(
      {required userId, required year, required month}) async {
    try {
      Map<String, String> params = {
        'year': '$year',
        'month': '$month',
      };

      dynamic response =
          await _apiService.get('/timers/history/month/$userId', params);

      final responseData = response as List;
      List<UserMonthlyCalendarModel> monthlyCalendarData = responseData
          .map((dailyData) => UserMonthlyCalendarModel.fromJson(dailyData))
          .toList();
      return monthlyCalendarData;
    } catch (e) {
      rethrow;
    }
  }

  // GET : 한 해 기록
  Future<List<UserMonthlyCountModel>> getUserMonthlyCountData({
    required userId,
    required year,
  }) async {
    Map<String, String> params = {
      'year': '$year',
    };
    try {
      dynamic response =
          await _apiService.get('/timers/history/year/$userId', params);
      // response 가 dynamic이므로 어떠한 값이라도 올 수 있다.
      // 때문에 받은 데이터가 List<dynamic>
      final responseData = response as List;
      List<UserMonthlyCountModel> monthlyCountData = responseData
          .map((dailyData) => UserMonthlyCountModel.fromJson(dailyData))
          .toList();

      return monthlyCountData;
    } catch (e) {
      rethrow;
    }
  }

  // GET : 찜한 책 조회
  Future<Map<String, dynamic>> getWishlistData({
    required int page,
  }) async {
    const int dataSize = 10;
    Map<String, String> params = {
      'page': '$page',
      'size': '$dataSize',
    };

    dynamic response = await _apiService.get('/books/like', params);

    final wishlistBooksData = response['content'] as List;
    List<Book> wishlistBooks =
        wishlistBooksData.map((book) => Book.fromJson(book)).toList();

    final first = response['first'];
    final last = response['last'];
    final numberOfElements = response['numberOfElements'];
    final isEmpty = response['empty'];

    Map<String, dynamic> pageData = {
      'numberOfElements': numberOfElements,
      'isEmpty': isEmpty,
      'first': first,
      'last': last,
    };

    Map<String, dynamic> wishlistData = {
      'wishlistBooks': wishlistBooks,
      'pageData': pageData,
    };

    return wishlistData;
  }

  // POST : 팔로우
  Future<void> followById({required userId}) async {
    try {
      await _apiService.post('/users/follow/$userId', {});
    } catch (e) {
      rethrow;
    }
  }

  // DELETE : 언팔로우
  Future<void> unfollowById({required userId}) async {
    try {
      await _apiService.delete('/users/follow/$userId');
    } catch (e) {
      rethrow;
    }
  }
}
