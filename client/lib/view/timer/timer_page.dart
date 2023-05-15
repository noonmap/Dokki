import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/custom_app_bar.dart';
import 'package:dokki/providers/timer_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:dokki/view/book_detail/widget/book_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  final int bookStatusId;
  final String bookTitle;
  final String bookCoverPath;
  final String bookCoverBackImagePath;
  final String bookCoverSideImagePath;
  const TimerPage({
    Key? key,
    required this.bookTitle,
    required this.bookStatusId,
    required this.bookCoverPath,
    required this.bookCoverBackImagePath,
    required this.bookCoverSideImagePath,
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: widget.bookTitle.length > 14
            ? '${widget.bookTitle.substring(0, 14)}...'
            : widget.bookTitle,
        titleWidget: const Icon(
          Icons.watch_later,
          color: grayColor000,
          size: 24,
        ),
        leading: IconButton(
          onPressed: () {
            context.read<TimerProvider>().exit();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.home,
            color: grayColor000,
            size: 28,
          ),
        ),
        showActionIcon: true,
        onMenuActionTap: () {
          print("메뉴 버튼 클릭");
        },
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: grayColor600,
            ),
            child: CustomPaint(
              painter: BackgroundPainter(),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            decoration: BoxDecoration(
                color: grayColor600,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0))),
            child: Consumer<TimerProvider>(builder: (context, provider, child) {
              final time = provider.currentTime;
              final isPlaying = provider.timerPlaying;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  BookItem(
                    width: clientWidth / 2.3,
                    height: clientWidth / 1.8,
                    depth: 60,
                    imagePath: widget.bookCoverPath,
                    sideImagePath: widget.bookCoverSideImagePath,
                    backImagePath: widget.bookCoverBackImagePath,
                    isDetail: false,
                    bookStatusId: widget.bookStatusId,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    Utils.secondTimeToFormatString(time),
                    style: const TextStyle(
                      color: brandColor100,
                      fontSize: 44,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        isPlaying
                            ? provider.pause(widget.bookStatusId)
                            : provider.start(widget.bookStatusId);
                      },
                      icon: isPlaying
                          ? const Icon(
                              Icons.stop_circle,
                            )
                          : const Icon(
                              Icons.play_circle,
                            ),
                      iconSize: 90,
                      color: brandColor100,
                    ),
                  ),
                ],
              );
            }),
          )
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
    path.lineTo(size.width * 0.2, 0);
    path.lineTo(0, size.height * 0.5);
    path.close();

    final path2 = Path();

    path2.moveTo(size.width, 0);
    path2.lineTo(size.width * 0.8, 0);
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
