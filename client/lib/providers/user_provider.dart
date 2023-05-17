import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dokki/data/model/book/book_model.dart';
import 'package:dokki/data/model/user/user_bio_model.dart';
import 'package:dokki/data/model/user/user_monthly_calendar_model.dart';
import 'package:dokki/data/model/user/user_monthly_count_model.dart';
import 'package:dokki/data/model/user/user_simple_model.dart';
import 'package:dokki/data/repository/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  final _storage = const FlutterSecureStorage();
  bool isLoading = false;
  bool isLoading2 = false;
  bool isLoading3 = false;
  String error = "";

  UserBioModel? userBio;
  List<UserMonthlyCalendarModel> userMonthlyCalendar = [];
  List<UserMonthlyCountModel> userMonthlyCount = [];

  bool wishlistLoading = false;
  List<Book> wishlistBooks = [];
  Map<String, dynamic> wishlistPageData = {};

  bool followListLoading = false;
  List<UserSimpleModel> followList = [];
  Map<String, dynamic> followListPageData = {};

  void initProvider() {
    wishlistBooks = [];
    wishlistPageData = {};
    wishlistLoading = false;

    followList = [];
    followListPageData = {};
    followListLoading = false;
  }

  // GET : 프로필 바이오 조회
  Future<void> getUserBioById(String userId) async {
    isLoading = true;
    try {
      UserBioModel userBioData =
          await _userRepository.getUserBioDataById(int.parse(userId));
      userBio = userBioData;
    } on DioError catch (e) {
      print(e.response);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET : 팔로잉/팔로워 목록 조회
  Future<void> getFollowList({
    required userId,
    required category,
    required page,
  }) async {
    followListLoading = true;
    try {
      Map<String, dynamic> followListData = await _userRepository
          .getFollowListData(userId: userId, category: category, page: page);
      followList.addAll(followListData['followList']);
      followListPageData = followListData['pageData'];
    } on DioError catch (e) {
      print(e.response);
    } finally {
      followListLoading = false;
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
    } on DioError catch (e) {
      print(e.response);
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
    } on DioError catch (e) {
      print(e.response);
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
      wishlistPageData = wishlistData['pageData'];
    } on DioError catch (e) {
      print(e.response);
    } finally {
      wishlistLoading = false;
      notifyListeners();
    }
  }

  // POST, DELETE : 팔로우, 언팔로우
  Future<void> followById({required userId, required category}) async {
    int followerCount = userBio!.followerCount;

    try {
      if (category == 'follow') {
        await _userRepository.followById(userId: userId);
        followerCount += 1;
      } else {
        await _userRepository.unfollowById(userId: userId);
        followerCount -= 1;
      }

      UserBioModel newUserBio = UserBioModel(
          userId: userBio!.userId,
          nickname: userBio!.nickname,
          profileImagePath: userBio!.profileImagePath,
          isFollowed: !userBio!.isFollowed,
          followingCount: userBio!.followingCount,
          followerCount: followerCount);
      userBio = newUserBio;

      notifyListeners();
    } on DioError catch (e) {
      print(e.response);
    }
  }

  // PUT : 유저 닉네임 변경
  Future<void> putNickname({required nickname}) async {
    try {
      await _userRepository.putNickname(nickname: nickname);
      _storage.write(key: 'nickname', value: nickname);

      UserBioModel newUserBio = UserBioModel(
          userId: userBio!.userId,
          nickname: nickname,
          profileImagePath: userBio!.profileImagePath,
          isFollowed: !userBio!.isFollowed,
          followingCount: userBio!.followingCount,
          followerCount: userBio!.followerCount);
      userBio = newUserBio;
      notifyListeners();
    } on DioError catch (e) {
      print(e.response);
    }
  }

  // POST : 유저 프로필 사진 변경
  Future<void> postProfileImage({required File img}) async {
    try {
      String res = await _userRepository.postProfileImage(img: img);
      await _storage.write(key: 'profileImageUrl', value: res);
      UserBioModel newUserBio = UserBioModel(
          userId: userBio!.userId,
          nickname: userBio!.nickname,
          profileImagePath: res,
          isFollowed: !userBio!.isFollowed,
          followingCount: userBio!.followingCount,
          followerCount: userBio!.followerCount);
      userBio = newUserBio;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
