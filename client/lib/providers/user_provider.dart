import 'package:dokki/data/model/user/user_bio_model.dart';
import 'package:dokki/data/model/user/user_monthly_calendar_model.dart';
import 'package:dokki/data/model/user/user_monthly_count_model.dart';
import 'package:dokki/data/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  bool isLoading = false;

  UserBioModel? userBio;
  List<UserMonthlyCalendarModel> userMonthlyCalendar = [];
  List<UserMonthlyCountModel> userMonthlyCount = [];

  // GET : 프로필 바이오
  Future<void> getUserBioById(int userId) async {
    isLoading = true;

    try {
      UserBioModel userBioData =
          await _userRepository.getUserBioDataById(userId);
      userBio = userBioData;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET : 독서 달력
  Future<void> getUserMonthlyCalendar({
    required userId,
    required year,
    required month,
  }) async {
    isLoading = true;

    try {
      List<UserMonthlyCalendarModel> userMonthlyCalendarData =
          await _userRepository.getUserMonthlyCalendarData(
              userId: userId, year: year, month: month);
      userMonthlyCalendar = userMonthlyCalendarData;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET : 한 해 기록
  Future<void> getUserMonthlyCount({
    required userId,
    required year,
  }) async {
    isLoading = true;

    try {
      List<UserMonthlyCountModel> userMonthlyCountData = await _userRepository
          .getUserMonthlyCountData(userId: userId, year: year);
      userMonthlyCount = userMonthlyCountData;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
