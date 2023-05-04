import 'package:dokki/constants/colors.dart';
import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem(
      {Key? key,
      required this.profileImagePath,
      required this.nickname,
      required this.content,
      required this.score})
      : super(key: key);

  final String profileImagePath;
  final String nickname;
  final String content;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(54))),
            child: Image.network(
              profileImagePath,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        nickname,
                        style: const TextStyle(
                          color: grayColor300,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (num i = 0; i < score; i++)
                              const Icon(
                                Icons.star,
                                color: yellowColor400,
                              ),
                            for (num i = 0; i < 5 - score; i++)
                              const Icon(
                                Icons.star_outline,
                                color: yellowColor400,
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
