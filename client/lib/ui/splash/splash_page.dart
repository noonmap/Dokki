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
    dynamic accessToken = await storage.read(key: "ACCESS_TOKEN");
    if (accessToken != null) {
      // 로그인 한 상태이면 바로 메인 페이지로 이동
      Timer(const Duration(milliseconds: 2500), () {
        Navigator.pushReplacementNamed(context, RoutesName.main);
      });
    } else {
      Timer(const Duration(milliseconds: 2500), () {
        Navigator.popAndPushNamed(context, RoutesName.login);
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
