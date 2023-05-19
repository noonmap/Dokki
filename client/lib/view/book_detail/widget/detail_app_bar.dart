import 'package:dio/dio.dart';
import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/alert_dialog.dart';
import 'package:dokki/common/widget/bottom_sheet_modal.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DetailAppBar({
    super.key,
    required this.bookId,
    required this.isBookMarked,
    required this.isReading,
    required this.isComplete,
    required this.deleteLikeBook,
    required this.addLikeBook,
    required this.getBookById,
  });

  final String bookId;
  final bool isBookMarked;
  final bool isReading;
  final bool isComplete;
  final Function deleteLikeBook;
  final Function addLikeBook;
  final Function getBookById;

  @override
  State<DetailAppBar> createState() => _DetailAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(
        double.maxFinite,
        50,
      );
}

class _DetailAppBarState extends State<DetailAppBar> {
  bool isStatusBook() {
    if (widget.isReading || widget.isComplete) {
      return true;
    }
    return false;
  }

  int getCurrentStatus() {
    if (widget.isReading) {
      return 0;
    }
    if (widget.isComplete) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        !isStatusBook()
            ? IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12.0))),
                      builder: (BuildContext context) {
                        return BottomSheetModal(
                          isState: isStatusBook(),
                          currentState: getCurrentStatus(),
                          bookId: widget.bookId,
                        );
                      });
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add),
                color: brandColor300,
              )
            : IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomAlertDialog(
                            onPressedFunction: () {
                              context
                                  .read<BookProvider>()
                                  .deleteBookStatus(widget.bookId);
                              context
                                  .read<BookProvider>()
                                  .getBookById(widget.bookId);
                              Navigator.pop(context);
                              Utils.flushBarSuccessMessage(
                                  "삭제 되었습니다.", context);
                            },
                            question: widget.isReading
                                ? "타이머에서 삭제할까요?"
                                : "서재에서 삭제할까요 ?",
                            commentId: 1,
                            bookId: "0");
                      });
                },
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete_forever_rounded),
                color: brandColor300,
              ),
        IconButton(
          onPressed: () {
            if (widget.isBookMarked) {
              // 북마크 취소
              widget
                  .deleteLikeBook(widget.bookId)
                  .then((value) => widget.getBookById(widget.bookId));
              Utils.flushBarErrorMessage("북마크가 취소되었습니다.", context);
            } else {
              widget
                  .addLikeBook(widget.bookId)
                  .then((value) => widget.getBookById(widget.bookId));
              Utils.flushBarSuccessMessage("북마크가 저장되었습니다.", context);
            }
          },
          icon: widget.isBookMarked
              ? const Icon(Icons.bookmark_added_sharp)
              : const Icon(Icons.bookmark_add_outlined),
          color: brandColor300,
        ),
      ],
      iconTheme: const IconThemeData(
        color: grayColor500,
      ),
    );
  }
}
