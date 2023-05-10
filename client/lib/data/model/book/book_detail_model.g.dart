// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDetailModel _$BookDetailModelFromJson(Map<String, dynamic> json) =>
    BookDetailModel(
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      bookSummary: json['bookSummary'] as String,
      bookAuthor: json['bookAuthor'] as String,
      bookLink: json['bookLink'] as String,
      bookCoverPath: json['bookCoverPath'] as String,
      bookCoverBackImagePath: json['bookCoverBackImagePath'] as String,
      bookCoverSideImagePath: json['bookCoverSideImagePath'] as String,
      bookPublishYear: json['bookPublishYear'] as String,
      bookPublisher: json['bookPublisher'] as String,
      bookTotalPage: json['bookTotalPage'] as int,
      review: (json['review'] as List<dynamic>)
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      readerCount: json['readerCount'] as int,
      meanScore: (json['meanScore'] as num).toDouble(),
      meanReadTime: (json['meanReadTime'] as num).toDouble(),
      isBookMarked: json['isBookMarked'] as bool,
      isReading: json['isReading'] as bool,
      isComplete: json['isComplete'] as bool,
    );

Map<String, dynamic> _$BookDetailModelToJson(BookDetailModel instance) =>
    <String, dynamic>{
      'bookId': instance.bookId,
      'bookTitle': instance.bookTitle,
      'bookSummary': instance.bookSummary,
      'bookAuthor': instance.bookAuthor,
      'bookLink': instance.bookLink,
      'bookCoverPath': instance.bookCoverPath,
      'bookCoverBackImagePath': instance.bookCoverBackImagePath,
      'bookCoverSideImagePath': instance.bookCoverSideImagePath,
      'bookPublishYear': instance.bookPublishYear,
      'bookPublisher': instance.bookPublisher,
      'bookTotalPage': instance.bookTotalPage,
      'review': instance.review,
      'readerCount': instance.readerCount,
      'meanScore': instance.meanScore,
      'meanReadTime': instance.meanReadTime,
      'isBookMarked': instance.isBookMarked,
      'isReading': instance.isReading,
      'isComplete': instance.isComplete,
    };
