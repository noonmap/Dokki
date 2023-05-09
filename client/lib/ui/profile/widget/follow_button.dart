import 'package:dokki/constants/colors.dart';
import 'package:dokki/ui/common_widget/paragraph.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    required this.isFollowed,
  });

  final bool isFollowed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
