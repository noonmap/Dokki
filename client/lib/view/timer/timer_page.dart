import 'package:audioplayers/audioplayers.dart';
import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/providers/timer_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:dokki/view/timer/widget/alert_dialog.dart';
import 'package:dokki/view/timer/widget/dialog.dart';
import 'package:dokki/view/timer/widget/timer_rotate_book_item.dart';
import 'package:flutter/material.dart';
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
  late AudioPlayer audioPlayer;
  late ScrollController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setAudio();
    _controller = ScrollController();
    context.read<TimerProvider>().initTimer();
  }

  Future setAudio() async {
    audioPlayer = AudioPlayer();
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    final player = AudioCache(prefix: "assets/mp3/");
    final url = await player.load('rain.mp3');
    audioPlayer.setSourceUrl(url.path);
  }

  @override
  Widget build(BuildContext context) {
    final clientWidth = MediaQuery.of(context).size.width;
    final clientHeight = MediaQuery.of(context).size.height;
    final tp = Provider.of<TimerProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (tp.currentTime == 0) {
          Navigator.pop(context);
        } else {
          if (tp.timerPlaying) {
            tp.pause(widget.bookStatusId);
            audioPlayer.pause();
            tp.rotatePause();

            _controller.animateTo(_controller.position.maxScrollExtent + 100,
                duration: const Duration(seconds: 1), curve: Curves.ease);
          }
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return TimerPageAlertDialog(
                restTime: tp.timerList.length,
                question: "타이머를 종료합니다.",
                onPressedOKFunction: () {
                  audioPlayer.stop();
                  tp.exit();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                accumReadTime: tp.currentTime,
              );
            },
          );
        }
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: brandColor200,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (tp.currentTime == 0) {
                Navigator.pop(context);
              } else {
                if (tp.timerPlaying) {
                  tp.pause(widget.bookStatusId);
                  tp.rotatePause();

                  audioPlayer.pause();

                  _controller.animateTo(
                      _controller.position.maxScrollExtent + 100,
                      duration: const Duration(seconds: 1),
                      curve: Curves.ease);
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TimerPageAlertDialog(
                      restTime: tp.timerList.length,
                      question: "타이머를 종료합니다.",
                      onPressedOKFunction: () {
                        tp.exit();
                        audioPlayer.stop();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      accumReadTime: tp.currentTime,
                    );
                  },
                );
              }
            },
          ),
          backgroundColor: brandColor200,
          foregroundColor: grayColor600,
        ),
        body: Stack(
          children: [
            Container(
              width: clientWidth,
              height: clientHeight * 0.78,
              margin: EdgeInsets.only(top: clientHeight * 0.22),
              decoration: const BoxDecoration(
                color: brandColor100,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(36.0),
                  topLeft: Radius.circular(36.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 70, 16, 10),
                child: Consumer<TimerProvider>(
                  builder: (context, provider, child) {
                    final time = provider.currentTime;
                    return Column(
                      children: [
                        Text(
                          Utils.secondTimeToFormatString(time),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: ListView.separated(
                              controller: _controller,
                              itemCount: provider.timerList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: brandColor000,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: brandColor200,
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: brandColor300,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        Utils.secondTimeToFormatString(
                                          provider.timerList[index],
                                        ),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 12,
                                );
                              },
                            ),
                          ),
                        ),
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
                                  child: provider.timerPlaying
                                      ? const Icon(
                                          Icons.pause,
                                          color: brandColor300,
                                          size: 32,
                                        )
                                      : const Icon(
                                          Icons.play_arrow,
                                          color: brandColor300,
                                          size: 32,
                                        ),
                                ),
                                onTap: () async {
                                  if (provider.timerPlaying) {
                                    // 종료
                                    provider.pause(widget.bookStatusId);
                                    provider.rotatePause();

                                    audioPlayer.pause();

                                    _controller.animateTo(
                                        _controller.position.maxScrollExtent +
                                            100,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.ease);
                                  } else {
                                    provider.start(widget.bookStatusId);
                                    provider.rotateStart();
                                    audioPlayer.resume();
                                  }
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: clientWidth / 2 - 24,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: brandColor300,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    "완독",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: brandColor100,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                                onTap: () async {
                                  if (provider.timerPlaying) {
                                    provider.pause(widget.bookStatusId);
                                    provider.rotatePause();

                                    audioPlayer.pause();

                                    _controller.animateTo(
                                        _controller.position.maxScrollExtent +
                                            100,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.ease);
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogBox(
                                        bookId: widget.bookId,
                                        title: widget.bookTitle,
                                        accumReadTime: widget.accumReadTime +
                                            provider.currentTime,
                                        bookStatusId: widget.bookStatusId,
                                        onPressedOkCallback: () async {
// 완독 + 리뷰 작
                                          await context
                                              .read<BookProvider>()
                                              .updateCompleteBook(
                                                  widget.bookStatusId);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Utils.flushBarSuccessMessage(
                                              "해당 책이 서재로 이동되었습니다.", context);
                                        },
                                      );
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              height: clientHeight * 0.3,
              child: TimerRotateBookTimer(
                imagePath: widget.bookCoverPath,
                backImagePath: widget.bookCoverBackImagePath,
                sideImagePath: widget.bookCoverSideImagePath,
                width: clientWidth / 2.5,
                height: clientWidth / 2,
                isDetail: true,
                depth: 50,
                rotateValue: tp.rotateValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class BackgroundPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = Colors.white.withOpacity(0.1);
//     final path = Path();
//
//     path.moveTo(0, 0);
//     path.lineTo(size.width * 0.25, 0);
//     path.lineTo(0, size.height * 0.5);
//     path.close();
//
//     final path2 = Path();
//
//     path2.moveTo(size.width, 0);
//     path2.lineTo(size.width * 0.79, 0);
//     path2.lineTo(size.width * 0.5, size.height);
//     path2.lineTo(size.width, size.height);
//     path2.close();
//
//     canvas.drawPath(path, paint);
//     canvas.drawPath(path2, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     return false;
//   }
// }
