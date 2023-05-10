import 'package:dio/dio.dart';
import 'package:dokki/data/model/diary/diary_model.dart';
import 'package:dokki/data/repository/diary_repository.dart';
import 'package:flutter/material.dart';

class DiaryProvider extends ChangeNotifier {
  final DiaryRepository _diaryRepository = DiaryRepository();
  bool isLoading = false;
  bool isDetailLoading = false;
  bool isCountLoading = false;
  bool isImageLoading = false;
  bool isImageLoaded = false;

  List<DiaryModel> diaries = [];
  Map<String, dynamic> pageData = {};
  DiaryModel? diary;
  int? diaryImageCount;
  String? diaryImage;

  void initProvider() {
    diaries = [];
    pageData = {};
    isLoading = false;
    isDetailLoading = false;
    isCountLoading = false;
    isImageLoading = false;
    isImageLoaded = false;
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
      diaryImageCount = await _diaryRepository.getDiaryImageCountData();
    } on DioError catch (e) {
      print(e.response);
    } finally {
      isCountLoading = false;
      notifyListeners();
    }
  }

  // POST : AI 이미지 생성
  Future<void> postDiaryImage({
    required String content,
  }) async {
    isImageLoading = true;
    isImageLoaded = false;
    isCountLoading = true;

    try {
      Map<String, dynamic> rst =
          await _diaryRepository.postDiaryImageData(content: content);
      diaryImage = rst['diaryImagePath'];
      diaryImageCount = rst['count'];
    } on DioError catch (e) {
      print(e.response);
    } finally {
      isImageLoading = false;
      isImageLoaded = true;
      isCountLoading = false;
      notifyListeners();
    }
  }

  Future<void> postDiary({
    required String bookId,
    required String content,
    required String imagePath,
  }) async {
    try {
      await _diaryRepository.postDiaryData(
          bookId: bookId, content: content, imagePath: imagePath);
    } on DioError catch (e) {
      print(e.response);
    }
  }
}
