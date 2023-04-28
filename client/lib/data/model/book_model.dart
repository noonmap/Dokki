import 'dart:convert';

class Book {
  Book({
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCoverPath,
    required this.bookPublishYear,
    required this.bookPublisher,
  });

  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final String bookCoverPath;
  final String bookPublishYear;
  final String bookPublisher;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        bookId: json["bookId"],
        bookTitle: json["bookTitle"],
        bookAuthor: json["bookAuthor"],
        bookCoverPath: json["bookCoverPath"],
        bookPublishYear: json["bookPublishYear"],
        bookPublisher: json["bookPublisher"],
      );

  Map<String, dynamic> toJson() => {
        "bookId": bookId,
        "bookTitle": bookTitle,
        "bookAuthor": bookAuthor,
        "bookCoverPath": bookCoverPath,
        "bookPublishYear": bookPublishYear,
        "bookPublisher": bookPublisher,
      };

  @override
  String toString() {
    return 'Book{bookId: $bookId, bookTitle: $bookTitle, bookAuthor: $bookAuthor, bookCoverPath: $bookCoverPath, bookPublishYear: $bookPublishYear, bookPublisher: $bookPublisher}';
  }
}
