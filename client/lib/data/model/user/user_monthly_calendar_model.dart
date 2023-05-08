class UserMonthlyCalendarModel {
  final int day, dayOfWeek;
  final String bookId, bookTitle, bookCoverPath;

  UserMonthlyCalendarModel({
    required this.day,
    required this.dayOfWeek,
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverPath,
  });

  factory UserMonthlyCalendarModel.fromJson(Map<String, dynamic> json) {
    return UserMonthlyCalendarModel(
      day: json['day'],
      dayOfWeek: json['dayOfWeek'],
      bookId: json['bookId'],
      bookTitle: json['bookTitle'],
      bookCoverPath: json['bookCoverPath'],
    );
  }
}
