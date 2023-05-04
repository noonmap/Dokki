import 'dart:convert';

import 'package:dokki/data/model/user/user_bio_model.dart';
import 'package:dokki/data/model/user/user_monthly_calendar_model.dart';
import 'package:dokki/data/model/user/user_monthly_count_model.dart';
import 'package:dokki/utils/services/api_service.dart';
import "package:http/http.dart" as http;

class UserRepository {
  final APIService _apiService = APIService();

  // GET : 프로필 바이오
  Future<UserBioModel> getUserBioDataById(int userId) async {
    http.Response res = await _apiService.get('/users/profile/$userId', null);

    if (res.statusCode == 200) {
      final dynamic userBio = jsonDecode(utf8.decode(res.bodyBytes));
      return UserBioModel.fromJson(userBio);
    }
    throw Error();
  }

  // GET : 독서 달력
  Future<List<UserMonthlyCalendarModel>> getUserMonthlyCalendarData(
      {required userId, required year, required month}) async {
    Map<String, String> params = {
      'year': '$year',
      'month': '$month',
    };

    http.Response res =
        await _apiService.get('/timers/history/month/$userId', params);

    if (res.statusCode == 200) {
      final List<dynamic> monthlyData = jsonDecode(utf8.decode(res.bodyBytes));

      List<UserMonthlyCalendarModel> monthlyCalendarData = monthlyData
          .map((dailyData) => UserMonthlyCalendarModel.fromJson(dailyData))
          .toList();

      return monthlyCalendarData;
    }
    throw Error();
  }

  // GET : 한 해 기록
  Future<List<UserMonthlyCountModel>> getUserMonthlyCountData({
    required userId,
    required year,
  }) async {
    Map<String, String> params = {
      'year': '$year',
    };

    http.Response res =
        await _apiService.get('/timers/history/year/$userId', params);

    if (res.statusCode == 200) {
      final List<dynamic> monthlyData = jsonDecode(utf8.decode(res.bodyBytes));

      List<UserMonthlyCountModel> monthlyCountData = monthlyData
          .map((dailyData) => UserMonthlyCountModel.fromJson(dailyData))
          .toList();

      return monthlyCountData;
    }
    throw Error();
  }
}
