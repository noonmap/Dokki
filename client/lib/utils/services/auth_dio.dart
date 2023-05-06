import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthDio {
  Dio dio = Dio();
  final String baseUrl = dotenv.env['BASE_PROD_URL'] as String;
  final _storage = const FlutterSecureStorage();

  AuthDio() {
    dio.interceptors.clear();

    dio.options = BaseOptions(
        contentType: 'application/json',
        responseType: ResponseType.json,
        baseUrl: baseUrl);

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final accessToken = await _storage.read(key: 'ACCESS_TOKEN');
      dio.options.headers["Authorization"] = 'Bearer $accessToken';
      print("intercepter request0");
      print(dio.options.headers.toString());
      // 매 요청 마다 헤더에 AccessToken 포함
      return handler.next(options);
    }, onError: (DioError error, handler) async {
      if ((error.response?.statusCode == 401 &&
          error.response?.data['code'] == 'U003')) {
        print(error.response?.data);
        // Access Token 만료 됬을 때의 로직
        final accessToken = await _storage.read(key: 'ACCESS_TOKEN');
        final refreshToken = await _storage.read(key: 'REFRESH_TOKEN');

        Dio refreshDio = Dio();

        refreshDio.interceptors.clear();
        refreshDio.options = BaseOptions(
            contentType: 'application/json',
            responseType: ResponseType.json,
            baseUrl: baseUrl);

        refreshDio.interceptors
            .add(InterceptorsWrapper(onError: (error, handler) async {
          // 다시 인증 오류가 발생했을 경우
          // refresh 토큰이 만료
          if (error.response?.statusCode == 401 &&
              error.response?.data["code"] == 'U008') {
            // storage에 있는 정보 제거 후 로그인 페이지로 이동
            _storage.deleteAll();
          }
          return handler.next(error);
        }));
        print("intercepter request1");

        // 토큰 갱신 API 요청 시 AccessToken (만료), RefreshToken 포함
        refreshDio.options.headers['Authorization'] = 'Bearer $accessToken';
        refreshDio.options.headers['Refresh'] = 'Bearer $refreshToken';

        // 토큰 갱신 API 요청
        final refreshResponse = await refreshDio.get('/users/refresh');

        // response로 부터 새로 갱신된 AccessTokenr과 RefreshToken 파싱
        final newAccessToken = refreshResponse.data['accessToken'];
        final newRefreshToken = refreshResponse.data['refreshToken'];
        // 새로 받은 accessToken과 refreshToken을 기기에 저장
        await _storage.write(key: "ACCESS_TOKEN", value: newAccessToken);
        await _storage.write(key: 'REFRESH_TOKEN', value: newRefreshToken);

        error.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';

        final clonedRequest = await dio.request(error.requestOptions.path,
            options: Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers),
            data: error.requestOptions.data,
            queryParameters: error.requestOptions.queryParameters);

        return handler.resolve(clonedRequest);
      }
      return handler.next(error);
    }));
  }
}
