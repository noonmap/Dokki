import 'dart:math';

import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/thumb_image.dart';
import 'package:dokki/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerRotateBookTimer extends StatefulWidget {
  final String imagePath;
  final String sideImagePath;
  final String backImagePath;
  final double width, height, depth, rotateValue;
  final bool isDetail;
  final int bookStatusId;
  const TimerRotateBookTimer({
    Key? key,
    required this.width,
    required this.height,
    required this.depth,
    required this.imagePath,
    required this.sideImagePath,
    required this.backImagePath,
    required this.isDetail,
    this.bookStatusId = -1,
    required this.rotateValue,
  }) : super(key: key);

  @override
  State<TimerRotateBookTimer> createState() => _TimerRotateBookTimerState();
}

class _TimerRotateBookTimerState extends State<TimerRotateBookTimer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.rotateValue);
    late final front = Transform(
      transform: Matrix4.translationValues(0.0, 0.0, widget.depth / -2),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: grayColor200,
              blurRadius: widget.isDetail ? 4.0 : 0,
              spreadRadius: widget.isDetail ? 1.0 : 0,
              offset: widget.isDetail ? Offset(0, 4) : Offset(0, 0),
            ),
          ],
        ),
        child: ThumbImage(
          thumbImagePath: widget.imagePath,
          width: widget.width,
          height: widget.height,
        ),
      ),
    );

    late final back = Transform(
      transform: Matrix4.translationValues(0.0, 0.0, widget.depth / 2)
        ..rotateY(180 * pi / 180),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: grayColor200,
              blurRadius: widget.isDetail ? 4.0 : 0,
              spreadRadius: widget.isDetail ? 1.0 : 0,
              offset: widget.isDetail ? const Offset(0, 4) : const Offset(0, 0),
            ),
          ],
        ),
        child: ThumbImage(
          thumbImagePath: widget.backImagePath == ""
              ? widget.imagePath
              : widget.backImagePath,
          width: widget.width,
          height: widget.height,
        ),
      ),
    );
    late final starboard = _buildSide(side: 1);
    late final bottom = _buildSide(side: 2);
    late final port = _buildSide(side: 3);
    List<Widget> children = [bottom];
    if (widget.rotateValue >= 0) {
      if (widget.rotateValue < pi / 4) {
        print("1");
        children = [starboard, front];
      } else if (widget.rotateValue < pi / 2) {
        print("2");
        children = [front, starboard];
      } else if (widget.rotateValue < 3 * pi / 4) {
        print("3");
        children = [back, starboard];
      } else if (widget.rotateValue < pi) {
        print("4");
        children = [starboard, back];
      } else if (widget.rotateValue < 5 * pi / 4) {
        print("5");
        children = [port, back];
      } else if (widget.rotateValue < 3 * pi / 2) {
        print("6");
        children = [back, port];
      } else if (widget.rotateValue < 7 * pi / 4) {
        print("7");
        children = [front, port];
      } else {
        print("8");
        children = [port, front];
      }
    } else {
      if (widget.rotateValue > pi / 4 * -1) {
        children = [port, front];
      } else if (widget.rotateValue > pi / 2 * -1) {
        children = [front, port];
      } else if (widget.rotateValue > 3 * pi / 4 * -1) {
        children = [back, port];
      } else if (widget.rotateValue > -pi) {
        children = [port, back];
      } else if (widget.rotateValue > 5 * pi / 4 * -1) {
        children = [starboard, back];
      } else if (widget.rotateValue > 3 * pi / 2 * -1) {
        children = [back, starboard];
      } else if (widget.rotateValue > 7 * pi / 4 * -1) {
        children = [front, starboard];
      } else {
        children = [starboard, front];
      }
    }
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(-0.02)
          ..rotateY(widget.rotateValue),
        alignment: Alignment.center,
        child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: grayColor200,
                  blurRadius: widget.isDetail ? 4.0 : 0,
                  spreadRadius: widget.isDetail ? 1.0 : 0,
                  offset: widget.isDetail ? Offset(0, 4) : Offset(0, 0),
                ),
              ],
            ),
            child: Stack(children: children)),
      ),
    );
  }

  Widget _buildSide({required int side}) {
    final double translate;
    switch (side) {
      case 0: // top
        translate = widget.height / -2;
        break;
      case 1: // starboard
        translate = widget.width / 2;
        break;
      case 2: // bottom
        translate = widget.height / 2;
        break;
      case 3: // port
        translate = widget.width / -2;
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
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: grayColor200,
                      blurRadius: widget.isDetail ? 4.0 : 0,
                      spreadRadius: widget.isDetail ? 1.0 : 0,
                      offset: widget.isDetail ? Offset(0, 4) : Offset(0, 0),
                    ),
                  ]),
                  child: ThumbImage(
                    thumbImagePath: widget.sideImagePath == ""
                        ? widget.imagePath
                        : widget.sideImagePath,
                    width: widget.depth,
                    height: widget.height,
                  ),
                )
              : Container(
                  width: topOrBottom ? widget.width : widget.depth,
                  height: topOrBottom ? widget.depth : widget.height,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFEFC),
                    boxShadow: [
                      BoxShadow(
                        color: grayColor200,
                        blurRadius: widget.isDetail ? 4.0 : 0,
                        spreadRadius: widget.isDetail ? 1.0 : 0,
                        offset: widget.isDetail ? Offset(0, 4) : Offset(0, 0),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
