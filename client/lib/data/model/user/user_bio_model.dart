class UserBioModel {
  final int userId, followingCount, followerCount;
  final String nickname, profileImagePath;
  final bool isFollowed;

  UserBioModel({
    required this.userId,
    required this.followingCount,
    required this.followerCount,
    required this.nickname,
    required this.profileImagePath,
    required this.isFollowed,
  });

  UserBioModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        nickname = json['nickname'],
        profileImagePath = json['profileImagePath'],
        followingCount = json['followingCount'],
        followerCount = json['followerCount'],
        isFollowed = json['isFollowed'];
}
