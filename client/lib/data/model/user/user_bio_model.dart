class UserBioModel {
  final int userId;
  final String nickname;
  final String profileImagePath;
  final bool isFollowed;
  final int followingCount;
  final int followerCount;

  UserBioModel({
    required this.userId,
    required this.nickname,
    required this.profileImagePath,
    required this.isFollowed,
    required this.followingCount,
    required this.followerCount,
  });

  UserBioModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        nickname = json['nickname'],
        profileImagePath = json['profileImagePath'],
        followingCount = json['followingCount'],
        followerCount = json['followerCount'],
        isFollowed = json['isFollowed'];
}
