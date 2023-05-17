import 'package:dokki/common/constant/colors.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/providers/review_provider.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class CustomDialogBox extends StatefulWidget {
  final int bookStatusId;
  final String bookId;
  final String title;
  final int accumReadTime;
  const CustomDialogBox({
    Key? key,
    required this.title,
    required this.accumReadTime,
    required this.bookStatusId,
    required this.bookId,
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
        borderRadius: BorderRadius.circular(12.0),
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
          Text(
            "책을 다 읽으셨다면 완독 버튼을 눌러주세요.",
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "책을 읽은 총 시간은 다음과 같습니다.",
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: brandColor300,
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
                      "총 읽은 시간",
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
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: ElevatedButton(
              onPressed: () async {
                // 완독 + 리뷰 작성
                await context
                    .read<BookProvider>()
                    .updateCompleteBook(widget.bookStatusId);
                Navigator.pop(context);
                Navigator.pop(context);
                Utils.flushBarSuccessMessage("해당 책이 서재로 이동되었습니다.", context);
              },
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
              child: const Text(
                "완독",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: brandColor100,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
