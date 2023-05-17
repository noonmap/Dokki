class DiaryModel {
  DiaryModel({
    required this.bookId,
    required this.bookTitle,
    required this.diaryId,
    required this.diaryImagePath,
    required this.diaryContent,
    required this.created,
    required this.bookAuthor,
    required this.bookPublishYear,
    required this.bookPublisher,
    required this.bookCoverPath,
  });

  final String bookId, bookTitle;
  final int diaryId;
  final String diaryImagePath, diaryContent;
  final DateTime created;
  final String bookAuthor, bookPublishYear, bookPublisher, bookCoverPath;

  DiaryModel.fromJson(Map<String, dynamic> json)
      : bookId = json['bookId'],
        bookTitle = json['bookTitle'],
        diaryId = json['diaryId'],
        diaryImagePath = json['diaryImagePath'],
        diaryContent = json['diaryContent'],
        created = DateTime.parse(json['created']),
        bookAuthor = json['bookAuthor'],
        bookPublishYear = json['bookPublishYear'],
        bookPublisher = json['bookPublisher'],
        bookCoverPath = json['bookCoverPath'];

  @override
  String toString() {
    return 'DiaryModel{bookId: $bookId, bookTitle: $bookTitle, diaryId: $diaryId, diaryImagePath: $diaryImagePath, diaryContent: $diaryContent, created: $created, bookAuthor: $bookAuthor, bookPublishYear: $bookPublishYear, bookPublisher: $bookPublisher, bookCoverPath: $bookCoverPath}';
  }
}
