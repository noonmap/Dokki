import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/constant/common.dart';
import 'package:dokki/common/widget/alert_dialog.dart';
import 'package:dokki/view/timer/widget/dialog.dart';
import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem(
      {Key? key,
      required this.userId,
      required this.commentId,
      required this.profileImagePath,
      required this.nickname,
      required this.content,
      required this.score,
      required this.loginUserId})
      : super(key: key);

  final String loginUserId;
  final int commentId;
  final int userId;
  final String profileImagePath;
  final String nickname;
  final String content;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
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
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  height: 54,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            nickname,
                            style: const TextStyle(
                              color: grayColor300,
                              fontSize: 13,
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
                                    size: 20,
                                  ),
                                for (num i = 0; i < 5 - score; i++)
                                  const Icon(
                                    Icons.star_outline,
                                    color: yellowColor400,
                                    size: 20,
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                      loginUserId == userId.toString()
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomAlertDialog(
                                          question: "삭제하시겠습니까?",
                                          commentId: commentId);
                                    });
                              },
                              icon: Icon(Icons.delete),
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.zero,
                              color: grayColor600,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: grayColor100,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 17,
                color: grayColor600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
