class Review {
  Review({
    required this.userId,
    required this.nickname,
    required this.profileImagePath,
    required this.score,
    required this.content,
  });

  final String userId;
  final String nickname;
  final String profileImagePath;
  final int score;
  final String content;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        userId: json["userId"],
        nickname: json["nickname"],
        profileImagePath: json["profileImagePath"],
        score: json["score"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "nickname": nickname,
        "profileImagePath": profileImagePath,
        "score": score,
        "content": content,
      };
}
