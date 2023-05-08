import 'package:dokki/data/model/user/user_bio_model.dart';
import 'package:dokki/data/model/user/user_monthly_calendar_model.dart';
import 'package:dokki/data/model/user/user_monthly_count_model.dart';
import 'package:dokki/utils/services/api_service.dart';

class UserRepository {
  final APIService _apiService = APIService();

  // GET : 다른 유저 상세 조회
  Future<UserBioModel> getUserBioDataById(String userId) async {
    print("getUser");
    dynamic response = await _apiService.get('/users/profile/$userId', null);
    UserBioModel userData = UserBioModel.fromJson(response);
    return userData;
  }

  // GET : 독서 달력
  Future<List<UserMonthlyCalendarModel>> getUserMonthlyCalendarData(
      {required userId, required year, required month}) async {
    Map<String, String> params = {
      'year': '$year',
      'month': '$month',
    };
    print("getUserCale");

    dynamic response =
        await _apiService.get('/timers/history/month/$userId', params);

    final responseData = response as List;
    List<UserMonthlyCalendarModel> monthlyCalendarData = responseData
        .map((dailyData) => UserMonthlyCalendarModel.fromJson(dailyData))
        .toList();
    return monthlyCalendarData;
  }

  // GET : 한 해 기록
  Future<List<UserMonthlyCountModel>> getUserMonthlyCountData({
    required userId,
    required year,
  }) async {
    Map<String, String> params = {
      'year': '$year',
    };
    print("getUserCount");

    dynamic response =
        await _apiService.get('/timers/history/year/$userId', params);
    // response 가 dynamic이므로 어떠한 값이라도 올 수 있다.
    // 때문에 받은 데이터가 List<dynamic>
    final responseData = response as List;
    List<UserMonthlyCountModel> monthlyCountData = responseData
        .map((dailyData) => UserMonthlyCountModel.fromJson(dailyData))
        .toList();

    return monthlyCountData;
  }
}
