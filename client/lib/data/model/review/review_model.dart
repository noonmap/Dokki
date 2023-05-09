class Review {
  Review({
    required this.userId,
    required this.nickname,
    required this.profileImagePath,
    required this.score,
    required this.content,
    required this.created,
  });

  final int userId;
  final String nickname;
  final String profileImagePath;
  final int score;
  final String content;
  final String created;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        userId: json["userId"],
        nickname: json["nickname"],
        profileImagePath: json["profileImagePath"],
        score: json["score"],
        content: json["content"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "nickname": nickname,
        "profileImagePath": profileImagePath,
        "score": score,
        "content": content,
        "created": created,
      };

  @override
  String toString() {
    return 'Review{userId: $userId, nickname: $nickname, profileImagePath: $profileImagePath, score: $score, content: $content, created: $created}';
  }
}
