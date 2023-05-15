import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/data/model/user/user_simple_model.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class FollowListItem extends StatelessWidget {
  const FollowListItem({
    super.key,
    required this.user,
  });

  final UserSimpleModel user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RoutesName.profile,
                arguments: {'userId': '${user.userId}'});
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  user.profileImagePath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Paragraph(
                text: user.nickname,
                size: 20,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              RoutesName.library,
              arguments: {
                'userId': '${user.userId}',
                'nickname': user.nickname
              },
            );
          },
          child: const Paragraph(
            text: '서재',
            size: 18,
            color: brandColor400,
          ),
        )
      ],
    );
  }
}
