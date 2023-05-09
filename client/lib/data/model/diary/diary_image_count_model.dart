class DiaryImageCountModel {
  DiaryImageCountModel({
    required this.count,
  });

  final int count;

  DiaryImageCountModel.fromJson(Map<String, dynamic> json)
      : count = json['count'];
}
