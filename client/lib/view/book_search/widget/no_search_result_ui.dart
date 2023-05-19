import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/constant/image_strings.dart';
import 'package:flutter/material.dart';

class NoSearchResultUI extends StatelessWidget {
  const NoSearchResultUI({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(tDokkiCharacter),
          width: 150,
        ),
        SizedBox(
          height: 5,
        ),
        Text("검색 결과가 없습니다.", style: TextStyle(color: grayColor500)),
      ],
    );
  }
}
