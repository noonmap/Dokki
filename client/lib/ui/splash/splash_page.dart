import 'dart:async';

import 'package:dokki/constants/colors.dart';
import 'package:dokki/constants/common.dart';
import 'package:dokki/constants/image_strings.dart';
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

    if (accessToken == null || refreshToken == null) {
      // 로그인 페이지로
      Timer(const Duration(milliseconds: 2500), () {
        Navigator.popAndPushNamed(context, RoutesName.login);
      });
    } else {
      // 자동 로그인
      Timer(const Duration(milliseconds: 2500), () {
        Navigator.pushReplacementNamed(context, RoutesName.main);
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
