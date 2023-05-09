class DiaryModel {
  DiaryModel({
    required this.bookId,
    required this.bookTitle,
    required this.diaryId,
    required this.diaryImagePath,
    required this.diaryContent,
    required this.created,
  });

  final String bookId, bookTitle;
  final int diaryId;
  final String diaryImagePath, diaryContent, created;

  DiaryModel.fromJson(Map<String, dynamic> json)
      : bookId = json['bookId'],
        bookTitle = json['bookTitle'],
        diaryId = json['diaryId'],
        diaryImagePath = json['diaryImagePath'],
        diaryContent = json['diaryContent'],
        created = json['created'];
}
