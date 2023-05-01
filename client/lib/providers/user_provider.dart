import 'package:dokki/data/model/user/user_bio_model.dart';
import 'package:dokki/data/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  UserBioModel? userBio;
  bool isLoading = true;

  Future<void> getUserBioById(int userId) async {
    if (isLoading == true) {
      UserBioModel userBioData =
          await _userRepository.getUserBioDataById(userId);
      userBio = userBioData;
      isLoading = false;
      notifyListeners();
    }
  }
}
