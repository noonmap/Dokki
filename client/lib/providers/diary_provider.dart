import 'package:dio/dio.dart';
import 'package:dokki/data/model/diary/diary_image_count_model.dart';
import 'package:dokki/data/model/diary/diary_model.dart';
import 'package:dokki/data/repository/diary_repository.dart';
import 'package:flutter/material.dart';

class DiaryProvider extends ChangeNotifier {
  final DiaryRepository _diaryRepository = DiaryRepository();
  bool isLoading = false;
  bool isDetailLoading = false;
  bool isCountLoading = false;

  List<DiaryModel> diaries = [];
  Map<String, dynamic> pageData = {};
  DiaryModel? diary;
  DiaryImageCountModel? diaryImageCount;

  void initProvider() {
    diaries = [];
    pageData = {};
    isLoading = false;
  }

  // GET : 감정 일기 목록 조회
  Future<void> getDiaries({
    required int page,
  }) async {
    isLoading = true;

    try {
      Map<String, dynamic> diariesData =
          await _diaryRepository.getDiariesData(page: page);
      diaries.addAll(diariesData['diaries']);
      pageData = diariesData['pageData'];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // GET : 감정 일기 단일 조회
  Future<void> getDiaryByBookId({
    required String bookId,
  }) async {
    isDetailLoading = true;

    try {
      DiaryModel diaryData =
          await _diaryRepository.getDiaryDataByBookId(bookId: bookId);
      diary = diaryData;
    } on DioError catch (e) {
      print(e.response);
    } finally {
      isDetailLoading = false;
      notifyListeners();
    }
  }

  // GET : AI 이미지 생성 가능 횟수 조회
  Future<void> getDiaryImageCount() async {
    isCountLoading = true;

    try {
      DiaryImageCountModel countData =
          await _diaryRepository.getDiaryImageCountData();
      diaryImageCount = countData;
    } on DioError catch (e) {
      print(e.response);
    } finally {
      isCountLoading = false;
      notifyListeners();
    }
  }
}
