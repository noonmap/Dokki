import 'package:dokki/data/model/user/user_bio_model.dart';
import 'package:dokki/data/repository/user_repository.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  UserBioModel _userBio = {} as UserBioModel;
  UserBioModel get userBio => _userBio;
  bool isLoading = true;

  Future<void> getUserBio(int userId) async {
    UserBioModel userBioData = await _userRepository.getUserBioData(userId);
    _userBio = userBioData;
    isLoading = false;
    notifyListeners();
  }
}
