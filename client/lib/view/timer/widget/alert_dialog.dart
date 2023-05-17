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
      height: 215,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: grayColor000,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.question,
              style: TextStyle(
                color: grayColor600,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: brandColor300,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Ionicons.restaurant,
                      color: brandColor100,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "휴식 횟수",
                      style: TextStyle(
                        color: brandColor100,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                Text(
                  "${widget.restTime > 0 ? widget.restTime - 1 : widget.restTime}번",
                  style: TextStyle(
                    color: brandColor100,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: brandColor300,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Ionicons.time,
                      color: brandColor100,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "읽은 시간",
                      style: TextStyle(
                        color: brandColor100,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                Text(
                  "${Utils.secondTimeToFormatString(widget.accumReadTime)}",
                  style: TextStyle(
                    color: brandColor100,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.onPressedOKFunction();
                },
                child: Text("확인"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.pressed)) {
                        return brandColor300;
                      }
                      return brandColor300;
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("취소"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.pressed)) {
                        return brandColor300;
                      }
                      return brandColor300;
                    },
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
