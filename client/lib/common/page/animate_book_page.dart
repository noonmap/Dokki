import 'dart:math';

import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/constant/image_strings.dart';
import 'package:dokki/data/model/diary/diary_model.dart';
import 'package:dokki/data/model/library/library_book_model.dart';
import 'package:flutter/material.dart';

class AnimateBookPage extends StatefulWidget {
  final List<LibraryBookModel> libraryBooks;
  final List<DiaryModel> diarys;
  final bool isDiary;
  const AnimateBookPage({
    Key? key,
    required this.libraryBooks,
    required this.diarys,
    required this.isDiary,
  }) : super(key: key);

  @override
  State<AnimateBookPage> createState() => _AnimateBookPageState();
}

class _AnimateBookPageState extends State<AnimateBookPage> {
  final _controller = PageController();
  final _notifierScroll = ValueNotifier(0.0);

  void _listener() {
    _notifierScroll.value = _controller.page!;
  }

  @override
  void initState() {
    _controller.addListener(_listener);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bookHeight = size.height * 0.45;
    final bookWidth = size.width * 0.6;
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(animateBG, fit: BoxFit.cover),
        ),
        Center(
          child: ValueListenableBuilder<double>(
            valueListenable: _notifierScroll,
            builder: (context, value, _) {
              return PageView.builder(
                itemCount: widget.isDiary
                    ? widget.diarys.length
                    : widget.libraryBooks.length,
                controller: _controller,
                itemBuilder: (context, index) {
                  late LibraryBookModel book;
                  late DiaryModel diary;
                  if (widget.isDiary) {
                    diary = widget.diarys[index];
                  } else {
                    book = widget.libraryBooks[index];
                  }
                  final percentage = index - value;
                  final rotation = percentage.clamp(0.0, 1.0);
                  final fixRotation = pow(rotation, 0.35);

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Stack(
                          children: [
                            Container(
                              height: bookHeight,
                              width: bookWidth,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 20,
                                      offset: Offset(5.0, 5.0),
                                      spreadRadius: 10,
                                    ),
                                  ]),
                            ),
                            Transform(
                              alignment: Alignment.centerLeft,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.002)
                                ..rotateY(1.7 * fixRotation)
                                ..translate(-rotation * size.width * 0.8)
                                ..scale(1 + rotation),
                              child: Image.network(
                                widget.isDiary
                                    ? diary.diaryImagePath
                                    : book.bookCoverPath,
                                fit: BoxFit.fill,
                                height: bookHeight,
                                width: bookWidth,
                              ),
                            ),
                          ],
                        )),
                        const SizedBox(
                          height: 40,
                        ),
                        Opacity(
                          opacity: 1 - rotation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isDiary
                                    ? diary.bookTitle
                                    : book.bookTitle,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              widget.isDiary
                                  ? Text(
                                      diary.diaryContent,
                                      style: const TextStyle(
                                        color: grayColor300,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
