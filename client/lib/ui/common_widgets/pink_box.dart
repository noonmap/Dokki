import 'package:dokki/constants/colors.dart';
import 'package:flutter/material.dart';

class PinkBox extends StatelessWidget {
  const PinkBox({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  final width, height, child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: brandColor100),
      child: child,
    );
  }
}
