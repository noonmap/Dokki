import 'package:dokki/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OpacityLoading extends StatelessWidget {
  const OpacityLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Container(
        alignment: Alignment.center,
        color: blackColor200,
        child: const SpinKitFadingFour(
          color: brandColor500,
          size: 50.0,
        ),
      ),
    );
  }
}
