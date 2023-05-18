import 'package:dio/dio.dart';
import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginButton extends StatelessWidget {
  final String text, iconPath;
  const LoginButton({
    super.key,
    required this.text,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final Dio dio = Dio();
        bool isInstalled = await isKakaoTalkInstalled();
        print(isInstalled);
        if (isInstalled) {
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
            dynamic response = await dio.get(
                "https://k8e2041.p.ssafy.io/users/login/oauth2/kakao",
                queryParameters: {"token": token.accessToken});
            Utils.setLoginStorage(response, context);
          } catch (error) {
            print('카카오톡 로그인 실패 $error');

            // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
            // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리
            if (error is PlatformException && error.code == 'CANCELED') {
              return;
            }

            // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오 계정으로 로그인
            try {
              OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
              dynamic response = await dio.get(
                  "https://k8e2041.p.ssafy.io/users/login/oauth2/kakao",
                  queryParameters: {"token": token.accessToken});
              Utils.setLoginStorage(response, context);

              print("카카오톡 계정으로 로그인 성공");
            } catch (error) {
              print('카카오 계정으로 로그인 실패 $error');
            }
          }
        } else {
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
            dynamic response = await dio.get(
                "https://k8e2041.p.ssafy.io/users/login/oauth2/kakao",
                queryParameters: {"token": token.accessToken});
            Utils.setLoginStorage(response, context);
          } catch (error) {
            print("카카오 계정으로 로그인 실패 $error");
          }
        }
      },
      child: Container(
        width: 230,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: grayColor200,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 30,
              height: 30,
            ),
            Text(
              "$text로 시작하기",
              style: const TextStyle(
                color: grayColor500,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
