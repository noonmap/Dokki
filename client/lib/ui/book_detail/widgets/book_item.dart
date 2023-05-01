import 'dart:math';

import 'package:dokki/ui/common_widgets/thumb_image.dart';
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final String imagePath;
  final double width, height, depth;
  const BookItem({
    Key? key,
    required this.width,
    required this.height,
    required this.depth,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final front = Transform(
      transform: Matrix4.translationValues(0.0, 0.0, depth / -2)
        ..rotateZ(45)
        ..rotateX(90),
      alignment: Alignment.center,
      child: ThumbImage(
        thumbImagePath: imagePath,
        width: width,
        height: height,
      ),
    );
    return Stack(
      children: [
        front,
      ],
    );
  }
}
