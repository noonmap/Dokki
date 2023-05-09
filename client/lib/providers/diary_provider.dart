import 'package:dokki/data/model/diary/diary_model.dart';
import 'package:dokki/data/repository/diary_repository.dart';
import 'package:flutter/material.dart';

class DiaryProvider extends ChangeNotifier {
  final DiaryRepository _diaryRepository = DiaryRepository();
  bool isLoading = false;

  List<DiaryModel> diarys = [];
  Map<String, dynamic> pageData = {};

  void initProvider() {
    diarys = [];
    pageData = {};
    isLoading = false;
  }

  // GET : 감정 일기 목록 조회
  Future<void> getDiarys({
    required int page,
  }) async {
    isLoading = true;

    try {
      Map<String, dynamic> diarysData =
          await _diaryRepository.getDiarysData(page: page);
      diarys.addAll(diarysData['diarys']);
      pageData = diarysData['pageData'];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
