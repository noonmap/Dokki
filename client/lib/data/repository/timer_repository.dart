import 'package:dokki/utils/services/api_service.dart';

class TimerRepository {
  final APIService _apiService = APIService();

  // POST timer 시작
  Future<void> readStart(int bookStatusId) async {
    try {
      await _apiService.post("/timers/$bookStatusId/start", {});
    } catch (e) {
      rethrow;
    }
  }

  // POST timer 종료
  Future<void> readEnd(int bookStatusId) async {
    try {
      await _apiService.post("/timers/$bookStatusId/end", {});
    } catch (e) {
      rethrow;
    }
  }

  // GET 오늘 누적 독서 시간
  Future<dynamic> getReadTimeToday(String userId) async {
    try {
      dynamic response =
          await _apiService.get("/timers/history/today/$userId", {});
      if (response["todayTime"] == null) {
        response["todayTime"] = 0;
      }
      return response["todayTime"];
    } catch (e) {
      rethrow;
    }
  }
}
