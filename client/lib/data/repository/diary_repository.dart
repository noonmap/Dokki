import 'package:dokki/data/model/diary/diary_model.dart';
import 'package:dokki/utils/services/api_service.dart';

class DiaryRepository {
  final APIService _apiService = APIService();

  // GET : 감정 일기 목록 조회
  Future<Map<String, dynamic>> getDiarysData({
    required int page,
  }) async {
    const int dataSize = 10;
    Map<String, String> params = {
      'page': '$page',
      'size': '$dataSize',
    };

    dynamic response = await _apiService.get('/reviews/diary', params);

    final diarysData = response['content'] as List;
    List<DiaryModel> diarys =
        diarysData.map((diary) => DiaryModel.fromJson(diary)).toList();

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
      'diarys': diarys,
      'pageData': pageData,
    };

    return rst;
  }
}
