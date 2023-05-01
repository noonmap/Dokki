import 'dart:math';

import 'package:dokki/constants/colors.dart';
import 'package:dokki/ui/common_widgets/thumb_image.dart';
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final String imagePath;
  final double width, height, depth;
  final double rotateX, rotateY;
  const BookItem({
    Key? key,
    required this.width,
    required this.height,
    required this.depth,
    required this.imagePath,
    rotateX = 0.0,
    rotateY = 0.0,
  })  : rotateY = rotateY % (pi * 2),
        rotateX = rotateX % (pi * 2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    late final front = Transform(
      transform: Matrix4.translationValues(0.0, 0.0, depth / -2),
      child: ThumbImage(
        thumbImagePath: imagePath,
        width: width,
        height: height,
      ),
    );

    late final back = Transform(
      transform: Matrix4.translationValues(0.0, 0.0, depth / 2),
      alignment: Alignment.center,
      child: ThumbImage(
        thumbImagePath: imagePath,
        width: width,
        height: height,
      ),
    );
    final List<Widget> children;
    late final top = _buildSide(side: 0);
    late final starboard = _buildSide(side: 1);
    late final bottom = _buildSide(side: 2);
    late final port = _buildSide(side: 3);

    if (rotateY < pi / 4) {
      children = [starboard, front];
    } else if (rotateY < pi / 2) {
      children = [front, starboard];
    } else if (rotateY < 3 * pi / 4) {
      children = [back, starboard];
    } else if (rotateY < pi) {
      children = [starboard, back];
    } else if (rotateY < 5 * pi / 4) {
      children = [port, back];
    } else if (rotateY < 3 * pi / 2) {
      children = [back, port];
    } else if (rotateY < 7 * pi / 4) {
      children = [front, port];
    } else {
      children = [port, front];
    }

    if (rotateX > 0.0) {
      children.add(top);
    } else {
      children.add(bottom);
    }
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(rotateX)
        ..rotateY(rotateY),
      alignment: Alignment.center,
      child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: grayColor200,
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: Stack(children: children)),
    );
  }

  Widget _buildSide({required int side}) {
    final double translate;
    switch (side) {
      case 0: // top
        translate = height / -2;
        break;
      case 1: // starboard
        translate = width / 2;
        break;
      case 2: // bottom
        translate = height / 2;
        break;
      case 3: // port
        translate = width / -2;
        break;
      default:
        throw Exception("Invalid side : $side");
    }

    final topOrBottom = side == 0 || side == 2;
    final Matrix4 transform;
    if (topOrBottom) {
      transform = Matrix4.identity()
        ..translate(0.0, translate, 0.0)
        ..rotateX(pi / 2);
    } else {
      transform = Matrix4.identity()
        ..translate(translate, 0.0, 0.0)
        ..rotateY(pi / 2);
    }
    return Positioned.fill(
      child: Transform(
        transform: transform,
        alignment: Alignment.center,
        child: Center(
          child: Container(
            width: topOrBottom ? width : depth,
            height: topOrBottom ? depth : height,
            decoration: const BoxDecoration(
              color: grayColor100,
            ),
          ),
        ),
      ),
    );
  }
}
