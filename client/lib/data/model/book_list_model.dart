import 'package:dokki/data/model/pageable_model.dart';
import 'package:dokki/data/model/sort_model.dart';

class BookListModel {
  List<Content>? content;
  Pageable? pageable;
  bool? last;
  int? totalPages;
  int? totalElements;
  int? size;
  int? number;
  Sort? sort;
  bool? first;
  int? numberOfElements;
  bool? empty;

  BookListModel(
      {this.content,
      this.pageable,
      this.last,
      this.totalPages,
      this.totalElements,
      this.size,
      this.number,
      this.sort,
      this.first,
      this.numberOfElements,
      this.empty});

  BookListModel.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
    pageable =
        json['pageable'] != null ? Pageable.fromJson(json['pageable']) : null;
    last = json['last'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    size = json['size'];
    number = json['number'];
    sort = json['sort'] != null ? Sort.fromJson(json['sort']) : null;
    first = json['first'];
    numberOfElements = json['numberOfElements'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    if (pageable != null) {
      data['pageable'] = pageable!.toJson();
    }
    data['last'] = last;
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    data['size'] = size;
    data['number'] = number;
    if (sort != null) {
      data['sort'] = sort!.toJson();
    }
    data['first'] = first;
    data['numberOfElements'] = numberOfElements;
    data['empty'] = empty;
    return data;
  }
}

class Content {
  String? bookId;
  String? bookTitle;
  String? bookAuthor;
  String? bookCoverPath;
  String? bookPublishYear;
  String? bookPublisher;

  Content(
      {this.bookId,
      this.bookTitle,
      this.bookAuthor,
      this.bookCoverPath,
      this.bookPublishYear,
      this.bookPublisher});

  Content.fromJson(Map<String, dynamic> json) {
    bookId = json['bookId'];
    bookTitle = json['bookTitle'];
    bookAuthor = json['bookAuthor'];
    bookCoverPath = json['bookCoverPath'];
    bookPublishYear = json['bookPublishYear'];
    bookPublisher = json['bookPublisher'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookId'] = bookId;
    data['bookTitle'] = bookTitle;
    data['bookAuthor'] = bookAuthor;
    data['bookCoverPath'] = bookCoverPath;
    data['bookPublishYear'] = bookPublishYear;
    data['bookPublisher'] = bookPublisher;
    return data;
  }
}
