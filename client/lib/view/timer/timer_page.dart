import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/alert_dialog.dart';
import 'package:dokki/common/widget/custom_app_bar.dart';
import 'package:dokki/providers/timer_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:dokki/view/book_detail/book_detail_page.dart';
import 'package:dokki/view/book_detail/widget/book_item.dart';
import 'package:dokki/view/timer/widget/alert_dialog.dart';
import 'package:dokki/view/timer/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  final int bookStatusId;
  final String bookId;
  final String bookTitle;
  final String bookCoverPath;
  final int accumReadTime;
  final String bookCoverBackImagePath;
  final String bookCoverSideImagePath;
  const TimerPage({
    Key? key,
    required this.bookTitle,
    required this.bookStatusId,
    required this.bookCoverPath,
    required this.bookCoverBackImagePath,
    required this.bookCoverSideImagePath,
    required this.accumReadTime,
    required this.bookId,
  }) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    super.initState();
    context.read<TimerProvider>().initTimer();
  }

  @override
  Widget build(BuildContext context) {
    final clientWidth = MediaQuery.of(context).size.width;
    final clientHeight = MediaQuery.of(context).size.height;
    final tp = Provider.of<TimerProvider>(context);
    return Scaffold(
      backgroundColor: brandColor200,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Book Timer",
          style: TextStyle(
            color: grayColor600,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (tp.currentTime == 0) {
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TimerPageAlertDialog(
                      question: "타이머 종료",
                      onPressedOKFunction: () {
                        tp.exit();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      accumReadTime: tp.currentTime,
                    );
                  },
                );
              }
            }),
        backgroundColor: brandColor200,
        foregroundColor: grayColor600,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    bookId: widget.bookId,
                    title: widget.bookTitle,
                    accumReadTime: widget.accumReadTime,
                    bookStatusId: widget.bookStatusId,
                  );
                },
              );
            },
            icon: Icon(Ionicons.book_outline),
            iconSize: 24,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: clientWidth,
            height: clientHeight * 0.75,
            margin: EdgeInsets.only(top: clientHeight * 0.25),
            decoration: const BoxDecoration(
              color: brandColor100,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(36.0),
                topLeft: Radius.circular(36.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),
              child: Column(
                children: [
                  Consumer<TimerProvider>(
                    builder: (context, provider, child) {
                      final time = provider.currentTime;
                      return Text(
                        Utils.secondTimeToFormatString(time),
                        style: const TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    },
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Container(
                            width: clientWidth / 2 - 24,
                            height: 45,
                            decoration: BoxDecoration(
                              color: brandColor200,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: Alignment.center,
                            child: tp.timerPlaying
                                ? const Text(
                                    "PAUSE",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: brandColor400,
                                    ),
                                  )
                                : const Text(
                                    "START",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: brandColor400,
                                    ),
                                  ),
                          ),
                          onTap: () {
                            if (tp.timerPlaying) {
                              // 종료
                              tp.pause(widget.bookStatusId);
                            } else {
                              tp.start(widget.bookStatusId);
                            }
                          },
                        ),
                        InkWell(
                          child: Container(
                            width: clientWidth / 2 - 24,
                            height: 45,
                            decoration: BoxDecoration(
                              color: brandColor400,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "EXIT",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: brandColor200,
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TimerPageAlertDialog(
                                  question: "타이머 종료",
                                  onPressedOKFunction: () {
                                    tp.exit();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  accumReadTime: tp.currentTime,
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: clientHeight * 0.34,
            child: BookItem(
              imagePath: widget.bookCoverPath,
              backImagePath: widget.bookCoverBackImagePath,
              sideImagePath: widget.bookCoverSideImagePath,
              width: clientWidth / 2.5,
              height: clientWidth / 2,
              isDetail: true,
              depth: 50,
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white.withOpacity(0.1);
    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width * 0.25, 0);
    path.lineTo(0, size.height * 0.5);
    path.close();

    final path2 = Path();

    path2.moveTo(size.width, 0);
    path2.lineTo(size.width * 0.79, 0);
    path2.lineTo(size.width * 0.5, size.height);
    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
