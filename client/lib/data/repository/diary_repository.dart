import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dokki/data/model/diary/diary_model.dart';
import 'package:dokki/utils/services/api_service.dart';

class DiaryRepository {
  final APIService _apiService = APIService();
  final String commonPath = '/reviews/diary';

  // GET : 감정 일기 목록 조회
  Future<Map<String, dynamic>> getDiariesData({
    required int page,
  }) async {
    const int dataSize = 10;
    Map<String, String> params = {
      'page': '$page',
      'size': '$dataSize',
    };

    dynamic response = await _apiService.get('/$commonPath', params);

    final diariesData = response['content'] as List;
    List<DiaryModel> diaries =
        diariesData.map((diary) => DiaryModel.fromJson(diary)).toList();

    final first = response['first'];
    final last = response['last'];
    final numberOfElements = response['numberOfElements'];
    final isEmpty = response['empty'];

    Map<String, dynamic> pageData = {
      'numberOfElements': numberOfElements,
      'isEmpty': isEmpty,
      'first': first,
      'last': last,
    };

    Map<String, dynamic> rst = {
      'diaries': diaries,
      'pageData': pageData,
    };

    return rst;
  }

  // GET : 감정 일기 단일 조회
  Future<DiaryModel> getDiaryDataByBookId({required String bookId}) async {
    try {
      dynamic response = await _apiService.get('/$commonPath/$bookId', {});
      DiaryModel diaryData = DiaryModel.fromJson(response);
      return diaryData;
    } catch (e) {
      rethrow;
    }
  }

  // GET : AI 이미지 생성 가능 횟수 조회
  Future<int> getDiaryImageCountData() async {
    try {
      dynamic response = await _apiService.get('/$commonPath/image/count', {});
      int diaryImageCountData = response['count'];

      return diaryImageCountData;
    } catch (e) {
      rethrow;
    }
  }

  // POST : AI 이미지 생성
  Future<Map<String, dynamic>> postDiaryImageData(
      {required String content}) async {
    Map<String, String> data = {'content': content};

    try {
      Response<dynamic> response =
          await _apiService.post('/$commonPath/image/creation', data);
      String diaryImageData = response.data['diaryImagePath'];
      int diaryImageCountData = response.data['count'];
      Map<String, dynamic> rst = {
        'diaryImagePath': diaryImageData,
        'count': diaryImageCountData,
      };
      return rst;
    } catch (e) {
      rethrow;
    }
  }

  // POST : 감정 일기 저장
  Future<void> postDiaryData({
    required String bookId,
    required String content,
    required String imagePath,
  }) async {
    Map<String, String> data = {
      'content': content,
      'diaryImagePath': imagePath
    };

    try {
      await _apiService.post('/$commonPath/$bookId', data);
    } catch (e) {
      rethrow;
    }
  }

  // POST : 감정 일기 이미지 저장 후 path 반환
  Future<String> postDiaryUserImage({required File img}) async {
    FormData formData =
        FormData.fromMap({'image': await MultipartFile.fromFile(img.path)});
    try {
      Response<dynamic> res =
          await _apiService.post('/reviews/diary/image', formData);

      return res.data["diaryImagePath"];
    } catch (e) {
      rethrow;
    }
  }

  // PUT : 감정 일기 수정
  Future<void> putDiaryData({
    required int diaryId,
    required String content,
    required String imagePath,
  }) async {
    Map<String, String> data = {
      'content': content,
      'diaryImagePath': imagePath,
    };

    try {
      await _apiService.put('/$commonPath/$diaryId', data);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE : 감정 일기 삭제
  Future<void> deleteDiary({required diaryId}) async {
    try {
      await _apiService.delete('/reviews/diary/$diaryId');
    } catch (e) {
      rethrow;
    }
  }
}
