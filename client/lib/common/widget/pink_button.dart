import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:flutter/material.dart';

class PinkButton extends StatelessWidget {
  const PinkButton({
    super.key,
    this.onTap,
    required this.text,
  });

  final void Function()? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: const BoxDecoration(
            color: brandColor100,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Center(
          child: Paragraph(
            text: text,
            color: brandColor300,
            size: 16,
            weightType: WeightType.medium,
          ),
        ),
      ),
    );
  }
}
