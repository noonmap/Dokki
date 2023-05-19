import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class Review {
  Review({
    required this.commentId,
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
  final int commentId;
  final int score;
  final String content;
  final String created;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  @override
  String toString() {
    return 'Review{userId: $userId, nickname: $nickname, profileImagePath: $profileImagePath, score: $score, content: $content, created: $created}';
  }
}
