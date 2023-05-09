import 'package:dokki/data/model/diary/diary_image_count_model.dart';
import 'package:dokki/data/model/diary/diary_model.dart';
import 'package:dokki/utils/services/api_service.dart';

class DiaryRepository {
  final APIService _apiService = APIService();

  // GET : 감정 일기 목록 조회
  Future<Map<String, dynamic>> getDiariesData({
    required int page,
  }) async {
    const int dataSize = 10;
    Map<String, String> params = {
      'page': '$page',
      'size': '$dataSize',
    };

    dynamic response = await _apiService.get('/reviews/diary', params);

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
      dynamic response = await _apiService.get('/reviews/diary/$bookId', null);
      DiaryModel diaryData = DiaryModel.fromJson(response);
      return diaryData;
    } catch (e) {
      rethrow;
    }
  }

  // GET : AI 이미지 생성 가능 횟수 조회
  Future<DiaryImageCountModel> getDiaryImageCountData() async {
    try {
      dynamic response =
          await _apiService.get('/reviews/diary/image/count', null);
      DiaryImageCountModel diaryImageCountData =
          DiaryImageCountModel.fromJson(response);

      return diaryImageCountData;
    } catch (e) {
      rethrow;
    }
  }
}
