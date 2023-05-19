import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/constant/common.dart';
import 'package:dokki/data/model/book/book_timer_model.dart';
import 'package:dokki/providers/status_book_provider.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadingBookItem extends StatelessWidget {
  final String userId;
  final String bookId;
  final int bookStatusId;
  final String bookTitle;
  final int accumReadTime;
  final String bookCoverPath;
  final String bookCoverBackImagePath;
  final String bookCoverSideImagePath;

  const ReadingBookItem({
    Key? key,
    required this.bookStatusId,
    required this.bookTitle,
    required this.accumReadTime,
    required this.bookCoverPath,
    required this.bookCoverBackImagePath,
    required this.bookCoverSideImagePath,
    required this.bookId,
    required this.userId,
  }) : super(key: key);

  factory ReadingBookItem.fromModel(
      {required BookTimerModel model, required String userId}) {
    return ReadingBookItem(
      userId: userId,
      bookStatusId: model.bookStatusId,
      bookTitle: model.bookTitle,
      accumReadTime: model.accumReadTime,
      bookCoverPath: model.bookCoverPath,
      bookCoverBackImagePath: model.bookCoverBackImagePath,
      bookCoverSideImagePath: model.bookCoverSideImagePath,
      bookId: model.bookId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.timer, arguments: {
          "bookId": bookId,
          "bookStatusId": bookStatusId,
          "bookTitle": bookTitle,
          "accumReadTime": accumReadTime,
          "bookCoverPath": bookCoverPath,
          "bookCoverBackImagePath": bookCoverBackImagePath,
          "bookCoverSideImagePath": bookCoverSideImagePath,
        }).then((value) {
          final sbp = Provider.of<StatusBookProvider>(context, listen: false);
          sbp.readingBookList = [];
          Future.wait([
            sbp.getReadTimeToday(userId),
            sbp.getReadingBookList("0", PAGE_LIMIT),
          ]);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: brandColor100,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          child: Row(
            children: [
              const Icon(
                Icons.play_arrow_sharp,
                size: 36,
                color: brandColor300,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(bookTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: grayColor400,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    )),
              ),
              const SizedBox(width: 8.0),
              Text(
                Utils.secondTimeToFormatString(accumReadTime),
                style: const TextStyle(
                  fontSize: 14,
                  color: grayColor400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
