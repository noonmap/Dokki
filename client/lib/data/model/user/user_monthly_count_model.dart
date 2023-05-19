class UserMonthlyCountModel {
  final int month, count;

  UserMonthlyCountModel({
    required this.month,
    required this.count,
  });

  factory UserMonthlyCountModel.fromJson(Map<String, dynamic> json) =>
      UserMonthlyCountModel(
        month: json["month"],
        count: json["count"],
      );
}
