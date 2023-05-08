class SimpleBook {
  SimpleBook({
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverPath,
  });

  final String bookId;
  final String bookTitle;
  final String bookCoverPath;

  factory SimpleBook.fromJson(Map<String, dynamic> json) => SimpleBook(
        bookId: json["bookId"],
        bookTitle: json["bookTitle"],
        bookCoverPath: json["bookCoverPath"],
      );

  Map<String, dynamic> toJson() => {
        "bookId": bookId,
        "bookTitle": bookTitle,
        "bookCoverPath": bookCoverPath,
      };

  @override
  String toString() {
    return 'SimpleBook{bookId: $bookId, bookTitle: $bookTitle, bookCoverPath: $bookCoverPath}';
  }
}
