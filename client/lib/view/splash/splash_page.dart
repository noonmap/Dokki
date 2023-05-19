import 'dart:async';

import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/constant/common.dart';
import 'package:dokki/common/constant/image_strings.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _asyncLoginCheck() async {
    final accessToken = await storage.read(key: "ACCESS_TOKEN");
    final refreshToken = await storage.read(key: "REFRESH_TOKEN");
    final userId = await storage.read(key: "userId");
    final nickname = await storage.read(key: "nickname");

    if (accessToken == null ||
        refreshToken == null ||
        userId == null ||
        nickname == null) {
      // 로그인 페이지로
      Timer(const Duration(milliseconds: 2500), () {
        Navigator.popAndPushNamed(context, RoutesName.login);
      });
    } else {
      // 자동 로그인
      Timer(const Duration(milliseconds: 2500), () {
        Navigator.pushReplacementNamed(context, RoutesName.main,
            arguments: {"userId": userId, "nickname": nickname});
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncLoginCheck();
    });
  }

  void ss() async {
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: brandColor100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(splashScreenLogo),
            ),
          ],
        ),
      ),
    );
  }
}
