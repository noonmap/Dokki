// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_timer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookTimerModel _$BookTimerModelFromJson(Map<String, dynamic> json) =>
    BookTimerModel(
      bookId: json['bookId'] as String,
      bookStatusId: json['bookStatusId'] as int,
      bookTitle: json['bookTitle'] as String,
      accumReadTime: json['accumReadTime'] as int,
      bookCoverPath: json['bookCoverPath'] as String,
      bookCoverBackImagePath: json['bookCoverBackImagePath'] as String,
      bookCoverSideImagePath: json['bookCoverSideImagePath'] as String,
    );

Map<String, dynamic> _$BookTimerModelToJson(BookTimerModel instance) =>
    <String, dynamic>{
      'bookId': instance.bookId,
      'bookStatusId': instance.bookStatusId,
      'bookTitle': instance.bookTitle,
      'accumReadTime': instance.accumReadTime,
      'bookCoverPath': instance.bookCoverPath,
      'bookCoverBackImagePath': instance.bookCoverBackImagePath,
      'bookCoverSideImagePath': instance.bookCoverSideImagePath,
    };
