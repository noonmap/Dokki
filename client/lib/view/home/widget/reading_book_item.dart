import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/data/model/book/book_timer_model.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';

class ReadingBookItem extends StatelessWidget {
  final int bookStatusId;
  final String bookTitle;
  final int accumReadTime;

  const ReadingBookItem({
    Key? key,
    required this.bookStatusId,
    required this.bookTitle,
    required this.accumReadTime,
  }) : super(key: key);

  factory ReadingBookItem.fromModel({required BookTimerModel model}) {
    return ReadingBookItem(
      bookStatusId: model.bookStatusId,
      bookTitle: model.bookTitle,
      accumReadTime: model.accumReadTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
