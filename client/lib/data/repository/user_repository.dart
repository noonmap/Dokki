import 'dart:convert';

import 'package:dokki/data/model/user/user_bio_model.dart';
import 'package:dokki/utils/services/api_service.dart';
import "package:http/http.dart" as http;

class UserRepository {
  final APIService _apiService = APIService();

  // GET : 유저 프로필 바이오
  Future<UserBioModel> getUserBioData(int userId) async {
    http.Response res = await _apiService.get('/users/profile/$userId', null);

    if (res.statusCode == 200) {
      final dynamic userBio = jsonDecode(utf8.decode(res.bodyBytes));
      return UserBioModel.fromJson(userBio);
    }
    throw Error();
  }
}
