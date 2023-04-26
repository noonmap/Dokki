// To parse this JSON data, do
//
//     final bookListModel = bookListModelFromJson(jsonString);

import 'dart:convert';

import 'package:dokki/data/model/pageable_model.dart';
import 'package:dokki/data/model/sort_model.dart';

BookListModel bookListModelFromJson(String str) =>
    BookListModel.fromJson(json.decode(str));

String bookListModelToJson(BookListModel data) => json.encode(data.toJson());

class BookListModel {
  BookListModel({
    required this.content,
    required this.pageable,
    required this.numberOfElements,
    required this.sort,
    required this.first,
    required this.last,
    required this.number,
    required this.size,
    required this.empty,
  });

  final List<Content> content;
  final Pageable pageable;
  final int numberOfElements;
  final Sort sort;
  final bool first;
  final bool last;
  final int number;
  final int size;
  final bool empty;

  factory BookListModel.fromJson(Map<String, dynamic> json) => BookListModel(
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
        pageable: Pageable.fromJson(json["pageable"]),
        numberOfElements: json["numberOfElements"],
        sort: Sort.fromJson(json["sort"]),
        first: json["first"],
        last: json["last"],
        number: json["number"],
        size: json["size"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
        "pageable": pageable.toJson(),
        "numberOfElements": numberOfElements,
        "sort": sort.toJson(),
        "first": first,
        "last": last,
        "number": number,
        "size": size,
        "empty": empty,
      };
}

class Content {
  Content({
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

  factory Content.fromJson(Map<String, dynamic> json) => Content(
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
}
