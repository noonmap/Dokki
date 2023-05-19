import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TimerPageAlertDialog extends StatefulWidget {
  final String question;
  final int accumReadTime;
  final Function onPressedOKFunction;
  final int restTime;
  const TimerPageAlertDialog({
    Key? key,
    required this.question,
    required this.onPressedOKFunction,
    required this.accumReadTime,
    required this.restTime,
  }) : super(key: key);

  @override
  State<TimerPageAlertDialog> createState() => _TimerPageAlertDialogState();
}

class _TimerPageAlertDialogState extends State<TimerPageAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Container(
      height: 231,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: grayColor000,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              widget.question,
              style: TextStyle(
                color: grayColor600,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Ionicons.book_outline,
                  color: brandColor300,
                  size: 28,
                ),
                Text(
                  "${widget.restTime}회",
                  style: const TextStyle(
                    color: brandColor300,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Ionicons.time_outline,
                  color: brandColor300,
                  size: 32,
                ),
                Text(
                  Utils.secondTimeToFormatString(widget.accumReadTime),
                  style: const TextStyle(
                    color: brandColor300,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  widget.onPressedOKFunction();
                },
                child: Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                    color: brandColor300,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "확인",
                    style: TextStyle(
                      color: brandColor100,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 90,
                  height: 40,
                  decoration: BoxDecoration(
                    color: brandColor300,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "취소",
                    style: TextStyle(
                      color: brandColor100,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
