import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/paragraph.dart';
import 'package:dokki/common/widget/pink_button.dart';
import 'package:dokki/providers/user_provider.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/view/profile/widget/follow_button.dart';
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
    void onFollowButtonTap() {
      if (up.userBio?.isFollowed == true) {
        up.followById(userId: userId, category: 'unfollow');
      } else if (up.userBio?.isFollowed == false) {
        up.followById(userId: userId, category: 'follow');
      }
    }

    void onEditButtonTap() {
      Navigator.pushNamed(context, RoutesName.profileEdit);
    }

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
                        ? PinkButton(
                            text: '프로필 편집',
                            onTap: onEditButtonTap,
                          )
                        : FollowButton(
                            isFollowed: up.userBio!.isFollowed,
                            onTap: onFollowButtonTap,
                          ),
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
