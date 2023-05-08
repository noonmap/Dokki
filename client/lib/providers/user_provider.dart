import 'package:dokki/data/model/simple_book_model.dart';
import 'package:dokki/data/model/user/user_bio_model.dart';
import 'package:dokki/data/model/user/user_monthly_calendar_model.dart';
import 'package:dokki/data/model/user/user_monthly_count_model.dart';
import 'package:dokki/data/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  bool isLoading = false;
  bool isLoading2 = false;
  bool isLoading3 = false;
  String error = "";

  UserBioModel? userBio;
  List<UserMonthlyCalendarModel> userMonthlyCalendar = [];
  List<UserMonthlyCountModel> userMonthlyCount = [];

  bool wishlistLoading = false;
  List<SimpleBookModel> wishlistBooks = [];
  Map<String, dynamic> pageData = {};

  void initProvider() {
    wishlistBooks = [];
    pageData = {};
    wishlistLoading = false;
  }

  // GET : 프로필 바이오
  Future<void> getUserBioById(String userId) async {
    isLoading = true;
    try {
      UserBioModel userBioData =
          await _userRepository.getUserBioDataById(userId);
      userBio = userBioData;
    } catch (e) {
      error = "error";
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
    isLoading2 = true;
    try {
      List<UserMonthlyCalendarModel> userMonthlyCalendarData =
          await _userRepository.getUserMonthlyCalendarData(
              userId: userId, year: year, month: month);
      userMonthlyCalendar = userMonthlyCalendarData;
    } catch (e) {
      error = "error";
    } finally {
      isLoading2 = false;
      notifyListeners();
    }
  }

  // GET : 한 해 기록
  Future<void> getUserMonthlyCount({
    required userId,
    required year,
  }) async {
    isLoading3 = true;
    try {
      List<UserMonthlyCountModel> userMonthlyCountData = await _userRepository
          .getUserMonthlyCountData(userId: userId, year: year);
      userMonthlyCount = userMonthlyCountData;
    } catch (e) {
      error = "error";
    } finally {
      isLoading3 = false;
      notifyListeners();
    }
  }

  // GET : 찜한 책 조회
  Future<void> getWishlist({
    required int page,
  }) async {
    wishlistLoading = true;

    try {
      Map<String, dynamic> wishlistData =
          await _userRepository.getWishlistData(page: page);
      wishlistBooks.addAll(wishlistData['wishlistBooks']);
      pageData = wishlistData['pageData'];
    } finally {
      wishlistLoading = false;
      notifyListeners();
    }
  }
}
