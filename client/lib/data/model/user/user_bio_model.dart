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

  factory UserBioModel.fromJson(Map<String, dynamic> json) => UserBioModel(
        userId: json['userId'],
        nickname: json['nickname'],
        profileImagePath: json['profileImagePath'],
        followingCount: json['followingCount'],
        followerCount: json['followerCount'],
        isFollowed: json['isFollowed'],
      );

  @override
  String toString() {
    return 'UserBioModel{userId: $userId, nickname: $nickname, profileImagePath: $profileImagePath, isFollowed: $isFollowed, followingCount: $followingCount, followerCount: $followerCount}';
  }
}
