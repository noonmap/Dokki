import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/common/widget/custom_app_bar.dart';
import 'package:dokki/providers/timer_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  final int bookStatusId;
  final String bookTitle;
  const TimerPage({
    Key? key,
    required this.bookTitle,
    required this.bookStatusId,
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
    Color c = Color(0XFFE57373);
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
              // color: Color(0XFF006266),
              color: c,
            ),
            child: CustomPaint(
              painter: BackgroundPainter(),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 80,
            decoration: BoxDecoration(
                color: c,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0))),
            child: Consumer<TimerProvider>(builder: (context, provider, child) {
              final time = provider.currentTime;
              final isPlaying = provider.timerPlaying;
              return Column(
                children: [
                  Text(
                    Utils.secondTimeToFormatString(time),
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      isPlaying
                          ? provider.pause(widget.bookStatusId)
                          : provider.start(widget.bookStatusId);
                    },
                    icon: isPlaying
                        ? const Icon(Icons.stop_circle, size: 56)
                        : const Icon(Icons.play_circle, size: 56),
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
