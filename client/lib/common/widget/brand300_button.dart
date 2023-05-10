import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:flutter/material.dart';

class Brand300Button extends StatelessWidget {
  const Brand300Button({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        backgroundColor: brandColor300,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      ),
      child: Paragraph(
        text: text,
        color: grayColor000,
        weightType: WeightType.regular,
      ),
    );
  }
}
