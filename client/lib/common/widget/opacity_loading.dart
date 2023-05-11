import 'package:dokki/common/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OpacityLoading extends StatelessWidget {
  const OpacityLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2,
      child: Container(
        alignment: Alignment.center,
        color: grayColor100,
        child: const SpinKitFadingFour(
          color: brandColor500,
          size: 50.0,
        ),
      ),
    );
  }
}
