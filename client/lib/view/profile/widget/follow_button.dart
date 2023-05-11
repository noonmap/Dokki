import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  FollowButton({
    super.key,
    required this.isFollowed,
    required this.onTap,
  });

  final bool isFollowed;
  void Function()? onTap;

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
            text: isFollowed ? '팔로잉' : '팔로우',
            color: brandColor300,
            size: 16,
            weightType: WeightType.semiBold,
          ),
        ),
      ),
    );
  }
}
