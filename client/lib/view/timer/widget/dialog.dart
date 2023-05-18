import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomDialogBox extends StatefulWidget {
  final int bookStatusId;
  final String bookId;
  final String title;
  final int accumReadTime;
  final Function onPressedOkCallback;
  const CustomDialogBox({
    Key? key,
    required this.title,
    required this.accumReadTime,
    required this.bookStatusId,
    required this.bookId,
    required this.onPressedOkCallback,
  }) : super(key: key);

  @override
  State<CustomDialogBox> createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  double selectedScore = 3.0;
  String textFieldValue = "";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      height: 200,
      decoration: BoxDecoration(
        color: brandColor000,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "완독하셨나요?",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Ionicons.time_outline,
                color: brandColor300,
                size: 32,
              ),
              const SizedBox(width: 40),
              Text(
                "${Utils.secondTimeToFormatString(widget.accumReadTime)}",
                style: TextStyle(
                  color: brandColor300,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  widget.onPressedOkCallback();
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
                    "예",
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
                    "아니오",
                    style: TextStyle(
                      color: brandColor100,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
