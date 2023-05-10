// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      userId: json['userId'] as int,
      nickname: json['nickname'] as String,
      profileImagePath: json['profileImagePath'] as String,
      score: json['score'] as int,
      content: json['content'] as String,
      created: json['created'] as String,
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImagePath': instance.profileImagePath,
      'score': instance.score,
      'content': instance.content,
      'created': instance.created,
    };
