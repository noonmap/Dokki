import 'dart:math';

import 'package:dokki/constants/colors.dart';
import 'package:dokki/ui/common_widgets/thumb_image.dart';
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final String imagePath;
  final String sideImagePath;
  final String backImagePath;
  final double width, height, depth;
  final double rotateY;
  const BookItem({
    Key? key,
    required this.width,
    required this.height,
    required this.depth,
    required this.imagePath,
    required this.sideImagePath,
    required this.backImagePath,
    this.rotateY = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final front = Transform(
      transform: Matrix4.translationValues(0.0, 0.0, depth / -2),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: grayColor200,
              blurRadius: 12.0,
              spreadRadius: 2.0,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: ThumbImage(
          thumbImagePath: imagePath,
          width: width,
          height: height,
        ),
      ),
    );

    late final back = Transform(
      transform: Matrix4.translationValues(0.0, 0.0, depth / 2),
      alignment: Alignment.center,
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: grayColor200,
              blurRadius: 12.0,
              spreadRadius: 2.0,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: ThumbImage(
          thumbImagePath: backImagePath == "" ? imagePath : backImagePath,
          width: width,
          height: height,
        ),
      ),
    );
    late final starboard = _buildSide(side: 1);
    late final bottom = _buildSide(side: 2);
    late final port = _buildSide(side: 3);
    print(rotateY);
    List<Widget> children = [bottom];
    if (rotateY >= 0) {
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
    } else {
      if (rotateY > pi / 4 * -1) {
        children = [port, front];
      } else if (rotateY > pi / 2 * -1) {
        children = [front, port];
      } else if (rotateY > 3 * pi / 4 * -1) {
        children = [back, port];
      } else if (rotateY > -pi) {
        children = [port, back];
      } else if (rotateY > 5 * pi / 4 * -1) {
        children = [starboard, back];
      } else if (rotateY > 3 * pi / 2 * -1) {
        children = [back, starboard];
      } else if (rotateY > 7 * pi / 4 * -1) {
        children = [front, starboard];
      } else {
        children = [starboard, front];
      }
    }
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(0)
        ..rotateY(rotateY),
      alignment: Alignment.center,
      child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: grayColor200,
                blurRadius: 12.0,
                spreadRadius: 2.0,
                offset: Offset(0, 14),
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
    final isPort = side == 3;

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
          child: isPort
              ? Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: grayColor200,
                      blurRadius: 12.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 14),
                    ),
                  ]),
                  child: ThumbImage(
                    thumbImagePath:
                        sideImagePath == "" ? imagePath : sideImagePath,
                    width: depth,
                    height: height,
                  ),
                )
              : Container(
                  width: topOrBottom ? width : depth,
                  height: topOrBottom ? depth : height,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFEFC),
                    boxShadow: [
                      BoxShadow(
                        color: grayColor200,
                        blurRadius: 12.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
