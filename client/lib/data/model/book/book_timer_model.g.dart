// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_timer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookTimerModel _$BookTimerModelFromJson(Map<String, dynamic> json) =>
    BookTimerModel(
      bookStatusId: json['bookStatusId'] as int,
      bookTitle: json['bookTitle'] as String,
      accumReadTime: json['accumReadTime'] as int,
    );

Map<String, dynamic> _$BookTimerModelToJson(BookTimerModel instance) =>
    <String, dynamic>{
      'bookStatusId': instance.bookStatusId,
      'bookTitle': instance.bookTitle,
      'accumReadTime': instance.accumReadTime,
    };
