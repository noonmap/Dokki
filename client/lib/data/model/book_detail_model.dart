import 'dart:convert';

import 'package:dokki/data/model/review_model.dart';

class BookDetailModel {
  BookDetailModel({
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
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
  });
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
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

  factory BookDetailModel.fromJson(Map<String, dynamic> json) =>
      BookDetailModel(
        bookId: json["bookId"],
        bookTitle: json["bookTitle"],
        bookAuthor: json["bookAuthor"],
        bookCoverPath: json["bookCoverPath"],
        bookCoverBackImagePath: json["bookCoverBackImagePath"],
        bookCoverSideImagePath: json["bookCoverSideImagePath"],
        bookPublishYear: json["bookPublishYear"],
        bookPublisher: json["bookPublisher"],
        bookTotalPage: json["bookTotalPage"],
        review:
            List<Review>.from(json["review"].map((x) => Review.fromJson(x))),
        readerCount: json["readerCount"],
        meanScore: json["meanScore"].toDouble(),
        meanReadTime: json["meanReadTime"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "bookId": bookId,
        "bookTitle": bookTitle,
        "bookAuthor": bookAuthor,
        "bookCoverPath": bookCoverPath,
        "bookCoverBackImagePath": bookCoverBackImagePath,
        "bookCoverSideImagePath": bookCoverSideImagePath,
        "bookPublishYear": bookPublishYear,
        "bookPublisher": bookPublisher,
        "bookTotalPage": bookTotalPage,
        "review": List<dynamic>.from(review.map((x) => x.toJson())),
        "readerCount": readerCount,
        "meanScore": meanScore,
        "meanReadTime": meanReadTime,
      };

  @override
  String toString() {
    return 'BookDetailModel{bookId: $bookId, bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookCoverPath: $bookCoverPath, bookCoverBackImagePath: $bookCoverBackImagePath, bookCoverSideImagePath: $bookCoverSideImagePath, bookPublishYear: $bookPublishYear, bookPublisher: $bookPublisher, bookTotalPage: $bookTotalPage, review: $review, readerCount: $readerCount, meanScore: $meanScore, meanReadTime: $meanReadTime}';
  }
}
