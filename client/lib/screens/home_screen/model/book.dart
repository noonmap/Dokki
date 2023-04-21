class BookModel {
  final String bookId, bookTitle, bookAuthor, bookCoverPath, bookPublishYear;

  BookModel.fromJson(Map<String, dynamic> json)
      : bookId = json['bookId'],
        bookTitle = json['bookTitle'],
        bookCoverPath = json['bookCoverPath'],
        bookAuthor = json['bookAuthor'],
        bookPublishYear = json['bookPublishYear'];
}
