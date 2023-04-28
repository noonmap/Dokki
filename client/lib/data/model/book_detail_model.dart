import 'dart:convert';

BookDetailModel bookDetailModelFromJson(String str) =>
    BookDetailModel.fromJson(json.decode(str));

String bookDetailModelToJson(BookDetailModel data) =>
    json.encode(data.toJson());

class BookDetailModel {
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final String bookCoverPath;
  final String bookPublishYear;
  final String bookPublisher;
  final int bookTotalPage;
  final int readerCount;
  final double meanScore;
  final double meanReadTime;

  BookDetailModel({
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCoverPath,
    required this.bookPublishYear,
    required this.bookPublisher,
    required this.bookTotalPage,
    required this.readerCount,
    required this.meanScore,
    required this.meanReadTime,
  });

  factory BookDetailModel.fromJson(Map<String, dynamic> json) =>
      BookDetailModel(
        bookId: json["bookId"],
        bookTitle: json["bookTitle"],
        bookAuthor: json["bookAuthor"],
        bookCoverPath: json["bookCoverPath"],
        bookPublishYear: json["bookPublishYear"],
        bookPublisher: json["bookPublisher"],
        bookTotalPage: json["bookTotalPage"],
        readerCount: json["readerCount"],
        meanScore: json["meanScore"]?.toDouble(),
        meanReadTime: json["meanReadTime"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "bookId": bookId,
        "bookTitle": bookTitle,
        "bookAuthor": bookAuthor,
        "bookCoverPath": bookCoverPath,
        "bookPublishYear": bookPublishYear,
        "bookPublisher": bookPublisher,
        "bookTotalPage": bookTotalPage,
        "readerCount": readerCount,
        "meanScore": meanScore,
        "meanReadTime": meanReadTime,
      };
}
