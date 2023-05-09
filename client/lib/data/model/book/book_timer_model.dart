import 'package:json_annotation/json_annotation.dart';

part 'book_timer_model.g.dart';

@JsonSerializable()
class BookTimerModel {
  final int bookStatusId;
  final String bookTitle;
  final int accumReadTime; // 초 단위로 보낸다. -> '00 : 00 : 00' 형태로 변환

  BookTimerModel({
    required this.bookStatusId,
    required this.bookTitle,
    required this.accumReadTime,
  });

  factory BookTimerModel.fromJson(Map<String, dynamic> json) =>
      _$BookTimerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookTimerModelToJson(this);
}
