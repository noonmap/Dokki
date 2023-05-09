import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/thumb_image.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class BookListItem extends StatelessWidget {
  final String bookId;
  final String bookTitle;
  final String bookCoverPath;
  final String bookAuthor;
  final String bookPublisher;
  final String bookPublishYear;
  final double imageWidth;
  final double imageHeight;
  final bool isLikeList;

  const BookListItem({
    super.key,
    required this.bookId,
    required this.bookTitle,
    required this.bookCoverPath,
    required this.bookAuthor,
    required this.bookPublisher,
    required this.bookPublishYear,
    required this.imageWidth,
    required this.imageHeight,
    this.isLikeList = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: GestureDetector(
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
              ThumbImage(
                  thumbImagePath: bookCoverPath,
                  width: imageWidth,
                  height: imageHeight),
              SizedBox(
                width: isLikeList ? 12.0 : 20.0,
              ),
              Expanded(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
