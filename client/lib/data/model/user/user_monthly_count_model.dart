class UserMonthlyCountModel {
  final int month, count;

  UserMonthlyCountModel({
    required this.month,
    required this.count,
  });

  UserMonthlyCountModel.fromJson(Map<String, dynamic> json)
      : month = json['month'],
        count = json['count'];
}
