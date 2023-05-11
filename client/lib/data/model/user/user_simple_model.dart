class UserSimpleModel {
  final int userId;
  final String nickname;
  final String profileImagePath;

  UserSimpleModel({
    required this.userId,
    required this.nickname,
    required this.profileImagePath,
  });

  UserSimpleModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        nickname = json['nickname'],
        profileImagePath = json['profileImagePath'];
}
