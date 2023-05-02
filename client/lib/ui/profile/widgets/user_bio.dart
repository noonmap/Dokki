import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/user_provider.dart';
import 'package:dokki/ui/common_widgets/paragraph.dart';
import 'package:flutter/material.dart';

class userBio extends StatelessWidget {
  const userBio({
    super.key,
    required this.up,
  });

  final UserProvider up;

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
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 72,
                        height: 28,
                        decoration: const BoxDecoration(
                            color: brandColor100,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Paragraph(
                            text: up.userBio!.isFollowed ? '팔로잉' : '팔로우',
                            color: brandColor300,
                            size: 16,
                            weightType: WeightType.semiBold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 팔로우
                    const Paragraph(
                      text: '팔로우  ',
                      color: grayColor300,
                      size: 16,
                    ),
                    Paragraph(
                      text: up.userBio!.followingCount.toString(),
                      color: grayColor300,
                      size: 18,
                      weightType: WeightType.semiBold,
                    ),
                    const SizedBox(width: 24),
                    // 팔로워
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
