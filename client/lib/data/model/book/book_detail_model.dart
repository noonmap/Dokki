import 'package:dokki/data/model/review/review_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book_detail_model.g.dart';

@JsonSerializable()
class BookDetailModel {
  BookDetailModel({
    required this.bookId,
    required this.bookTitle,
    required this.bookSummary,
    required this.bookAuthor,
    required this.bookLink,
    required this.bookCoverPath,
    required this.bookCoverBackImagePath,
    required this.bookCoverSideImagePath,
    required this.bookPublishYear,
    required this.bookPublisher,
    required this.bookTotalPage,
    required this.review,
    required this.readerCount,
    required this.meanScore,
    required this.meanReadTime,
    required this.isBookMarked,
    required this.isReading,
    required this.isComplete,
  });
  final String bookId;
  final String bookTitle;
  final String bookSummary;
  final String bookAuthor;
  final String bookLink;
  final String bookCoverPath;
  final String bookCoverBackImagePath;
  final String bookCoverSideImagePath;
  final String bookPublishYear;
  final String bookPublisher;
  final int bookTotalPage;
  final List<Review> review;
  final int readerCount;
  final double meanScore;
  final double meanReadTime;
  final bool isBookMarked;
  final bool isReading;
  final bool isComplete;

  factory BookDetailModel.fromJson(Map<String, dynamic> json) =>
      _$BookDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookDetailModelToJson(this);

  @override
  String toString() {
    return 'BookDetailModel{bookId: $bookId, bookTitle: $bookTitle, bookSummary: $bookSummary, bookAuthor: $bookAuthor, bookLink: $bookLink, bookCoverPath: $bookCoverPath, bookCoverBackImagePath: $bookCoverBackImagePath, bookCoverSideImagePath: $bookCoverSideImagePath, bookPublishYear: $bookPublishYear, bookPublisher: $bookPublisher, bookTotalPage: $bookTotalPage, review: $review, readerCount: $readerCount, meanScore: $meanScore, meanReadTime: $meanReadTime, isBookMarked: $isBookMarked, isReading: $isReading, isComplete: $isComplete}';
  }
}
