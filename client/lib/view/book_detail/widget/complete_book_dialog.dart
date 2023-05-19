import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';

class CompleteBookDialog extends StatelessWidget {
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final String bookCoverPath;
  final String bookPublishYear;
  final String bookPublisher;
  final int accumTime;
  const CompleteBookDialog({
    Key? key,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCoverPath,
    required this.bookPublishYear,
    required this.bookPublisher,
    required this.accumTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: grayColor000,
      ),
      padding: EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: grayColor100,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.timer,
                      color: grayColor400,
                      size: 22,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "완독 시간",
                      style: TextStyle(
                        color: grayColor400,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  Utils.secondTimeToFormatString(accumTime),
                  style: TextStyle(
                    color: grayColor400,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, RoutesName.diaryCreate,
                      arguments: {
                        "bookId": bookId,
                        "bookTitle": bookTitle,
                        "bookAuthor": bookAuthor,
                        "bookCoverPath": bookCoverPath,
                        "bookPublisher": bookPublisher,
                        "bookPublishYear": bookPublishYear
                      });
                },
                style: ElevatedButton.styleFrom(
                  primary: brandColor300,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                child: const Text("감정 일기 작성",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, RoutesName.reviewCreate,
                      arguments: {
                        "bookId": bookId,
                        "bookTitle": bookTitle,
                        "bookAuthor": bookAuthor,
                        "bookCoverPath": bookCoverPath,
                        "bookPublisher": bookPublisher,
                        "bookPublishYear": bookPublishYear
                      });
                },
                child: Text("리뷰 작성",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                style: ElevatedButton.styleFrom(
                  primary: brandColor300,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
