import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/user_provider.dart';
import 'package:dokki/ui/common_widgets/paragraph.dart';
import 'package:dokki/ui/profile/widgets/follow_button.dart';
import 'package:dokki/ui/profile/widgets/logout_button.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class userBio extends StatelessWidget {
  const userBio({
    super.key,
    required this.up,
    required this.userId,
    required this.isMine,
  });

  final UserProvider up;
  final String userId;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // 프로필 사진
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.network(
              up.userBio!.profileImagePath,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 닉네임
                    Paragraph(
                      text: up.userBio!.nickname,
                      size: 24,
                      weightType: WeightType.semiBold,
                    ),
                    // 팔로우 버튼
                    isMine
                        ? const LogoutButton()
                        : FollowButton(isFollowed: up.userBio!.isFollowed),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 팔로우
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.follow,
                            arguments: {
                              'userId': userId,
                              "category": 'following',
                            });
                      },
                      child: Row(
                        children: [
                          const Paragraph(
                            text: '팔로잉  ',
                            color: grayColor300,
                            size: 16,
                          ),
                          Paragraph(
                            text: up.userBio!.followingCount.toString(),
                            color: grayColor300,
                            size: 18,
                            weightType: WeightType.semiBold,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // 팔로워
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.follow,
                            arguments: {
                              'userId': userId,
                              'category': 'follower',
                            });
                      },
                      child: Row(
                        children: [
                          const Paragraph(
                            text: '팔로워  ',
                            color: grayColor300,
                            size: 16,
                          ),
                          Paragraph(
                            text: up.userBio!.followerCount.toString(),
                            color: grayColor300,
                            size: 18,
                            weightType: WeightType.semiBold,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
