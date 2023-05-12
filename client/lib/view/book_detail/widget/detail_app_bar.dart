import 'package:dokki/common/constant/colors.dart';
import 'package:flutter/material.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DetailAppBar({
    super.key,
    required this.bookId,
    required this.isBookMarked,
    required this.deleteLikeBook,
    required this.addLikeBook,
    required this.getBookById,
  });

  final String bookId;
  final bool isBookMarked;
  final Function deleteLikeBook;
  final Function addLikeBook;
  final Function getBookById;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Book Details",
        style: TextStyle(
          color: grayColor600,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            if (isBookMarked) {
              // 북마크 취소
              deleteLikeBook(bookId).then((value) => getBookById(bookId));
            } else {
              addLikeBook(bookId).then((value) => getBookById(bookId));
            }
          },
          child: isBookMarked
              ? const Icon(
                  Icons.bookmark_added_sharp,
                  color: brandColor300,
                )
              : const Icon(
                  Icons.bookmark_add_outlined,
                  color: brandColor300,
                ),
        ),
      ],
      iconTheme: const IconThemeData(
        color: grayColor500,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(
        double.maxFinite,
        50,
      );
}
