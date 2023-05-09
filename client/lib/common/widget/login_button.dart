import 'package:dio/dio.dart';
import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/constant/common.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
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
        try {
          OAuthToken token = isInstalled
              ? await UserApi.instance.loginWithKakaoTalk()
              : await UserApi.instance.loginWithKakaoAccount();
          dynamic response = await dio.get(
              "https://dokki.kr/users/login/oauth2/kakao",
              queryParameters: {"token": token.accessToken});
          await storage.write(
              key: "ACCESS_TOKEN",
              value: response.data["tokenDto"]["accessToken"]);
          await storage.write(
              key: "REFRESH_TOKEN",
              value: response.data["tokenDto"]["refreshToken"]);
          await storage.write(
              key: "userId",
              value: response.data["userDto"]["userId"].toString());
          await storage.write(
              key: "username", value: response.data["userDto"]["username"]);
          await storage.write(
              key: "email", value: response.data["userDto"]["email"]);
          await storage.write(
              key: "nickname", value: response.data["userDto"]["nickname"]);
          await storage.write(
              key: "profileImageUrl",
              value: response.data["userDto"]["profileImageUrl"]);
          Navigator.popAndPushNamed(context, RoutesName.main);
        } catch (e) {
          print(e.toString());
          Utils.flushBarErrorMessage("네트워크에 문제가 발생했습니다.", context);
          rethrow;
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
