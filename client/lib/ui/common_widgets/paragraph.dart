import 'package:dokki/constants/colors.dart';
import 'package:flutter/material.dart';

enum WeightType {
  bold,
  semiBold,
  medium,
  regular,
}

class Paragraph extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final WeightType weightType;

  static Map<WeightType, FontWeight> weightInfo = {
    WeightType.bold: FontWeight.w800,
    WeightType.semiBold: FontWeight.w600,
    WeightType.medium: FontWeight.w500,
    WeightType.regular: FontWeight.w300,
  };

  const Paragraph({
    super.key,
    required this.text,
    this.size = 16,
    this.color = grayColor500,
    this.weightType = WeightType.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weightInfo[weightType],
      ),
    );
  }
}
