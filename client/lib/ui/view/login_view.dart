import 'package:dokki/constants/colors.dart';
import 'package:dokki/constants/image_strings.dart';
import 'package:dokki/ui/widgets/login_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(splashScreenLogo),
            ),
            SizedBox(
              height: 66,
            ),
            LoginButton(
              text: "카카오",
              iconPath: kakaoLogo,
            ),
          ],
        ),
      ),
    );
  }
}
