import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/thumb_image.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

class BookListItem extends StatelessWidget {
  final String bookId;
  final String bookTitle;
  final String bookCoverPath;
  final String bookAuthor;
  final String bookPublisher;
  final String bookPublishYear;

  const BookListItem(
      {super.key,
      required this.bookId,
      required this.bookTitle,
      required this.bookCoverPath,
      required this.bookAuthor,
      required this.bookPublisher,
      required this.bookPublishYear});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.bookDetail,
            arguments: {"bookId": bookId});
      },
      child: Container(
        decoration: const BoxDecoration(
          color: grayColor000,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: ThumbImage(
                  thumbImagePath: bookCoverPath, width: 80, height: 100),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookTitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      color: grayColor500,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    bookAuthor,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      color: grayColor300,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "$bookPublisher • $bookPublishYear",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      color: grayColor300,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
