import 'package:dokki/constants/colors.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      onTap: () {
        Navigator.pushNamed(context, RoutesName.home);
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
