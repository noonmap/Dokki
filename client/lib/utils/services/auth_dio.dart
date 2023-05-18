import 'package:dio/dio.dart';
import 'package:dokki/main.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storage.read(key: 'ACCESS_TOKEN');
    final refresh = await storage.read(key: 'REFRESH_TOKEN');
    options.headers.addAll({'authorization': 'Bearer $token'});
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401 에러가 났을 때 (status code)
    // 토큰을 재발급 받는 시도
    // 다시 새로운 토큰으로 요청
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: 'REFRESH_TOKEN');
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');
    final String baseUrl = dotenv.env['BASE_PROD_URL'] as String;

    if (refreshToken == null || accessToken == null) {
      return handler.reject(err);
    }

    print("statusCode : ${err.response?.statusCode}");
    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/users/refresh';

    if (isStatus401 && !isPathRefresh) {
      print('[ERR] [${err.requestOptions.method}] accessToken 만료');

      // 401 에러가 발생 + 일반 REST API 요청에서 에러가 발생한 경우 -> accessToken 재발급
      final dio = Dio();
      dio.options.baseUrl = baseUrl;
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
        'Refresh': 'Bearer $refreshToken'
      };

      try {
        final resp = await dio.get('/users/refresh');

        final newAccessToken = resp.data['accessToken'];
        final newRefreshToken = resp.data['refreshToken'];

        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'Authorization': 'Bearer $newAccessToken',
        });

        // 변경된 값 storage에 다시 저장
        await storage.write(key: 'ACCESS_TOKEN', value: newAccessToken);
        await storage.write(key: 'REFRESH_TOKEN', value: newRefreshToken);

        // 요청 재전송
        final response = await dio.fetch(options);

        // 정상 적인 response 값 리턴
        return handler.resolve(response);
      } on DioError catch (e) {
        print('[ERR] [${e.requestOptions.method}] refreshToken 만료');
        storage.deleteAll();
        navigatorKey.currentState?.pushNamed(RoutesName.splash);
        // refresh token의 상태가 만료
        // 로그인 페이지로 이동
        return handler.reject(e);
      }
    }

    // if (err.response?.statusCode == 500) {
    //   final dio = Dio();
    //   dio.options.baseUrl = baseUrl;
    //   dio.options.headers = {
    //     'Authorization': 'Bearer $accessToken',
    //     'Refresh': 'Bearer $refreshToken'
    //   };
    //
    //   final response = await dio.fetch(err.requestOptions);
    //   return handler.resolve(response);
    // }
    // Token과 관련된 에러가 아닌 경우
    return handler.reject(err);
  }
}
