class LibraryBookModel {
  LibraryBookModel({
    required this.bookStatusId,
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverPath,
  });

  final int bookStatusId;
  final String bookId, bookTitle, bookCoverPath;

  LibraryBookModel.fromJson(Map<String, dynamic> json)
      : bookStatusId = json['bookStatusId'],
        bookId = json['bookId'],
        bookTitle = json['bookTitle'],
        bookCoverPath = json['bookCoverPath'];
}
