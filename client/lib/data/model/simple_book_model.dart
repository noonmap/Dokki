class SimpleBookModel {
  SimpleBookModel({
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverPath,
  });

  final String bookId, bookTitle, bookCoverPath;

  factory SimpleBookModel.fromJson(Map<String, dynamic> json) =>
      SimpleBookModel(
        bookId: json['bookId'],
        bookTitle: json['bookTitle'],
        bookCoverPath: json['bookCoverPath'],
      );
}
