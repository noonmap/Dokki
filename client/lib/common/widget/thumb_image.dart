import 'package:flutter/material.dart';

class ThumbImage extends StatelessWidget {
  const ThumbImage({
    super.key,
    required this.thumbImagePath,
    required this.width,
    required this.height,
  });

  final String thumbImagePath;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Image.network(
        thumbImagePath,
        width: width,
        height: height,
        fit: BoxFit.fill,
      ),
    );
  }
}
